//
//  VPNServer.swift
//  Folk VPN
//
//  Created by Anant Kumar on 14/09/26.
//

import Foundation

struct VPNServer: Identifiable, Hashable, Decodable {
    let id: Int
    let ip: String
    let region: String
    let serverType: String
    let country: Country
    let protocols: [String]

    struct Country: Hashable, Decodable {
        let name: String
        let flagUrl: URL
    }
}
