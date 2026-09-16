//
//  VPNController.swift
//  Folk VPN
//
//  Created by Anant Kumar on 14/09/26.
//

import Foundation
import NetworkExtension
import Observation

@Observable
final class VPNController {
    private(set) var state: VPNConnectionState = .disconnected
    private(set) var servers: [VPNServer] = []
    private(set) var isLoadingServers = false
    private(set) var loadError: String?
    var selectedServer: VPNServer?

    /// The single tunnel this app manages, backed by the PacketTunnel extension.
    private var tunnelManager: NETunnelProviderManager?
    private var statusObserver: NSObjectProtocol?

    private let tunnelBundleIdentifier = "com.anant.Folk-VPN.PacketTunnel"
    private let tunnelDisplayName = "Folk VPN"

    init() {
        observeStatusChanges()
        Task { await restoreExistingTunnel() }
    }

    deinit {
        if let statusObserver {
            NotificationCenter.default.removeObserver(statusObserver)
        }
    }

    func loadServers() async {
        isLoadingServers = true
        loadError = nil
        do {
            let list = try await ServerService.fetchServers()
            self.servers = list
            if selectedServer == nil || !list.contains(where: { $0.id == selectedServer?.id }) {
                self.selectedServer = list.first
            }
        } catch {
            self.loadError = (error as? APIError)?.errorDescription ?? error.localizedDescription
        }
        isLoadingServers = false
    }

    /// Requests a fresh config from the backend, then hands it to the PacketTunnel
    /// extension: conf-request first, connect once the response comes back — the
    /// tunnel never starts with a config we haven't just fetched.
    func connect() async {
        switch state {
        case .connecting, .connected:
            return
        default:
            break
        }

        guard let server = selectedServer else {
            state = .failed(message: "No server selected")
            return
        }

        state = .connecting

        do {
            let keys = KeyManager.ensureKeys()
            let protocolOption = VPNProtocolOption.current.resolved()
            let dnsOption = DNSOption.current

            let response = try await ConfigService.requestConfig(
                server: server,
                publicKeyBase64: keys.publicKeyBase64,
                protocolOption: protocolOption,
                primaryDNS: dnsOption.primaryDNS
            )

            var configText = VPNConfigText.applyPrivateKey(response.configContent, privateKeyBase64: keys.privateKeyBase64)
            configText = VPNConfigText.applyDNS(configText, servers: dnsOption.servers)

            try await startTunnel(configText: configText, serverAddress: server.ip)
        } catch {
            state = .failed(message: (error as? APIError)?.errorDescription ?? error.localizedDescription)
        }
    }

    func disconnect() async {
        guard let manager = tunnelManager else {
            state = .disconnected
            return
        }
        state = .disconnecting
        manager.connection.stopVPNTunnel()
    }

    // MARK: - Tunnel management

    /// Picks up an already-running (or previously configured) tunnel on launch, so
    /// relaunching the app while connected doesn't show a stale "Disconnected".
    private func restoreExistingTunnel() async {
        guard let managers = try? await NETunnelProviderManager.loadAllFromPreferences(),
              let existing = managers.first(where: {
                  ($0.protocolConfiguration as? NETunnelProviderProtocol)?.providerBundleIdentifier == tunnelBundleIdentifier
              }) else {
            return
        }
        tunnelManager = existing
        state = Self.connectionState(for: existing.connection)
    }

    private func loadOrCreateManager() async throws -> NETunnelProviderManager {
        if let tunnelManager { return tunnelManager }
        let managers = try await NETunnelProviderManager.loadAllFromPreferences()
        if let existing = managers.first(where: {
            ($0.protocolConfiguration as? NETunnelProviderProtocol)?.providerBundleIdentifier == tunnelBundleIdentifier
        }) {
            return existing
        }
        return NETunnelProviderManager()
    }

    private func startTunnel(configText: String, serverAddress: String) async throws {
        let manager = try await loadOrCreateManager()
        tunnelManager = manager

        let proto = NETunnelProviderProtocol()
        proto.providerBundleIdentifier = tunnelBundleIdentifier
        proto.serverAddress = serverAddress
        proto.providerConfiguration = ["WgQuickConfig": configText]

        manager.protocolConfiguration = proto
        manager.localizedDescription = tunnelDisplayName
        manager.isEnabled = true

        try await manager.saveToPreferences()
        // NETunnelProviderManager has a well-known quirk where starting a tunnel
        // immediately after saving can silently fail — reloading first avoids it.
        try await manager.loadFromPreferences()

        try manager.connection.startVPNTunnel()
    }

    private func observeStatusChanges() {
        statusObserver = NotificationCenter.default.addObserver(
            forName: .NEVPNStatusDidChange,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self, let connection = self.tunnelManager?.connection else { return }
            self.state = Self.connectionState(for: connection)
        }
    }

    private static func connectionState(for connection: NEVPNConnection) -> VPNConnectionState {
        switch connection.status {
        case .invalid, .disconnected:
            return .disconnected
        case .connecting, .reasserting:
            return .connecting
        case .connected:
            return .connected(since: connection.connectedDate ?? Date())
        case .disconnecting:
            return .disconnecting
        @unknown default:
            return .disconnected
        }
    }
}
