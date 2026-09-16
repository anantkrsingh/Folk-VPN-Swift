//
//  ConfigService.swift
//  Folk VPN
//
//  Created by Anant Kumar on 16/09/26.
//

import Foundation

enum ConfigService {
    /// Requests a per-device tunnel config from the backend for the given server/
    /// protocol/DNS choice. `server`'s id goes up only for an actual pick — nil (no
    /// server explicitly selected) lets the backend choose one itself, same as the
    /// Android app's ConfigRequest.
    static func requestConfig(
        server: VPNServer?,
        publicKeyBase64: String,
        protocolOption: VPNProtocolOption,
        primaryDNS: String
    ) async throws -> ConfigResponse {
        let deviceId = DeviceIdentifier.current
        let request = ConfigRequest(
            serverId: server?.id,
            clientName: deviceId,
            userId: deviceId,
            publicKey: publicKeyBase64,
            dns: primaryDNS,
            protocolName: protocolOption.backendValue,
            deviceId: deviceId,
            appUserId: deviceId
        )
        return try await APIClient.shared.post("public/conf-request", body: request)
    }
}
