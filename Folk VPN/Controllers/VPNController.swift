//
//  VPNController.swift
//  Folk VPN
//
//  Created by Anant Kumar on 14/09/26.
//

import Foundation
import Observation

@Observable
final class VPNController {
    private(set) var state: VPNConnectionState = .disconnected
    private(set) var servers: [VPNServer] = []
    private(set) var isLoadingServers = false
    private(set) var loadError: String?
    var selectedServer: VPNServer?

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

    func connect() async {
        guard selectedServer != nil else {
            state = .failed(message: "No server selected")
            return
        }
        state = .connecting
        try? await Task.sleep(nanoseconds: 800_000_000)
        state = .connected(since: Date())
    }

    func disconnect() async {
        state = .disconnecting
        try? await Task.sleep(nanoseconds: 400_000_000)
        state = .disconnected
    }
}
