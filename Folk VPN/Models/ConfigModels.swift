//
//  ConfigModels.swift
//  Folk VPN
//
//  Created by Anant Kumar on 16/09/26.
//

import Foundation

struct ConfigRequest: Encodable {
    let serverId: Int?
    let clientName: String
    let userId: String
    let publicKey: String
    let dns: String
    let protocolName: String
    let deviceId: String?
    let appUserId: String

    enum CodingKeys: String, CodingKey {
        case serverId = "server_id"
        case clientName = "client_name"
        case userId = "user_id"
        case publicKey = "public_key"
        case dns
        case protocolName = "protocol"
        case deviceId = "device_id"
        case appUserId = "app_user_id"
    }
}

struct ConfigResponse: Decodable {
    let message: String
    let configContent: String
    let clientName: String
    // Nullable: the backend sends a literal null here for protocols with no per-client
    // tunnel IP (e.g. a proxy protocol), unlike WireGuard/AmneziaWG.
    let clientIp: String?
    // The actual server IP the backend assigned when the request didn't pin a
    // server_id (an automatic/no-selection connect).
    let remoteIp: String?
}
