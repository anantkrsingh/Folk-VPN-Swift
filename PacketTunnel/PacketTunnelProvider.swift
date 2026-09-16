//
//  PacketTunnelProvider.swift
//  PacketTunnel
//
//  Created by Anant Kumar on 16/09/26.
//

import NetworkExtension
import os
import WireGuardKit

enum PacketTunnelProviderError: Error {
    case missingProviderConfiguration
    case invalidWgQuickConfig
}

class PacketTunnelProvider: NEPacketTunnelProvider {
    private static let log = Logger(subsystem: "com.anant.Folk-VPN.PacketTunnel", category: "tunnel")

    private lazy var adapter: WireGuardAdapter = {
        WireGuardAdapter(with: self) { logLevel, message in
            switch logLevel {
            case .error:
                Self.log.error("\(message, privacy: .public)")
            case .verbose:
                Self.log.debug("\(message, privacy: .public)")
            }
        }
    }()

    override func startTunnel(options: [String: NSObject]?, completionHandler: @escaping (Error?) -> Void) {
        guard let tunnelProviderProtocol = protocolConfiguration as? NETunnelProviderProtocol,
              let configText = tunnelProviderProtocol.providerConfiguration?["WgQuickConfig"] as? String else {
            completionHandler(PacketTunnelProviderError.missingProviderConfiguration)
            return
        }

        let tunnelConfiguration: TunnelConfiguration
        do {
            tunnelConfiguration = try TunnelConfiguration(fromWgQuickConfig: configText, called: "FolkVPNTunnel")
        } catch {
            Self.log.error("Failed to parse tunnel configuration: \(String(describing: error), privacy: .public)")
            completionHandler(PacketTunnelProviderError.invalidWgQuickConfig)
            return
        }

        adapter.start(tunnelConfiguration: tunnelConfiguration) { adapterError in
            guard let adapterError else {
                Self.log.info("Tunnel interface is \(self.adapter.interfaceName ?? "unknown", privacy: .public)")
                completionHandler(nil)
                return
            }
            Self.log.error("Adapter failed to start: \(String(describing: adapterError), privacy: .public)")
            completionHandler(adapterError)
        }
    }

    override func stopTunnel(with reason: NEProviderStopReason, completionHandler: @escaping () -> Void) {
        adapter.stop { error in
            if let error {
                Self.log.error("Failed to stop adapter cleanly: \(String(describing: error), privacy: .public)")
            }
            completionHandler()
        }
    }

    override func handleAppMessage(_ messageData: Data, completionHandler: ((Data?) -> Void)?) {
        guard let completionHandler else { return }
        adapter.getRuntimeConfiguration { settings in
            completionHandler(settings?.data(using: .utf8))
        }
    }

    override func sleep(completionHandler: @escaping () -> Void) {
        completionHandler()
    }

    override func wake() {
    }
}
