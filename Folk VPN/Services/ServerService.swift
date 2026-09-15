//
//  ServerService.swift
//  Folk VPN
//
//  Created by Anant Kumar on 14/09/26.
//

import Foundation

struct ServerListResponse: Decodable {
    let servers: [VPNServer]
}

enum ServerService {
    static func fetchServers() async throws -> [VPNServer] {
        let response: ServerListResponse = try await APIClient.shared.get("public/servers")
        return response.servers
    }
}
