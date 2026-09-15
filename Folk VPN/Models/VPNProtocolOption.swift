//
//  VPNProtocolOption.swift
//  Folk VPN
//
//  Created by Anant Kumar on 14/09/26.
//

import Foundation

enum VPNProtocolOption: String, CaseIterable, Identifiable {
    case automatic
    case wireguard
    case amneziawg
    case xray

    static let storageKey = "folkvpn.protocolOption"

    var id: String { rawValue }

    var name: String {
        switch self {
        case .automatic: return "Automatic"
        case .wireguard: return "WireGuard"
        case .amneziawg: return "AmneziaWG"
        case .xray: return "Xray"
        }
    }

    var description: String {
        switch self {
        case .automatic:
            return "Let Folk VPN pick the best protocol for your current network conditions."
        case .wireguard:
            return "Fast, modern VPN protocol with minimal overhead. Ideal for most networks."
        case .amneziawg:
            return "WireGuard with traffic obfuscation. Use this on restrictive networks that block plain WireGuard."
        case .xray:
            return "Advanced protocol with strong obfuscation. Best for heavily censored networks."
        }
    }
}
