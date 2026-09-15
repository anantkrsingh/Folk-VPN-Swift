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
    var selectedServer: VPNServer?

    init() {
        loadServers()
    }

    func loadServers() {
        servers = [
            VPNServer(name: "New York", countryCode: "US", host: "us-ny.folkvpn.net", port: 1194),
            VPNServer(name: "London", countryCode: "GB", host: "uk-lon.folkvpn.net", port: 1194),
            VPNServer(name: "Tokyo", countryCode: "JP", host: "jp-tky.folkvpn.net", port: 1194)
        ]
        selectedServer = servers.first
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
