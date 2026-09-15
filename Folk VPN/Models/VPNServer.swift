//
//  VPNServer.swift
//  Folk VPN
//
//  Created by Anant Kumar on 14/09/26.
//

import Foundation

struct VPNServer: Identifiable, Hashable {
    let id: UUID
    let name: String
    let countryCode: String
    let host: String
    let port: Int

    init(id: UUID = UUID(), name: String, countryCode: String, host: String, port: Int) {
        self.id = id
        self.name = name
        self.countryCode = countryCode
        self.host = host
        self.port = port
    }
}
