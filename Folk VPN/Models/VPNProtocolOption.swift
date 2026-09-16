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

    static var current: VPNProtocolOption {
        let raw = UserDefaults.standard.string(forKey: storageKey) ?? automatic.rawValue
        return VPNProtocolOption(rawValue: raw) ?? .automatic
    }

    /// Automatic never connects using itself — resolves to a concrete protocol based
    /// on the device's region, the same way the Android app's HomeViewModel.
    /// resolveProtocol() does (some regions are known to actively block plain
    /// WireGuard).
    func resolved() -> VPNProtocolOption {
        guard self == .automatic else { return self }
        let censoredRegions: Set<String> = ["RU", "IR", "BY", "MM", "TR", "AE", "TM", "IQ"]
        let region = Locale.current.region?.identifier.uppercased() ?? ""
        return censoredRegions.contains(region) ? .amneziawg : .wireguard
    }

    /// The value sent as the `protocol` field of a conf-request. Only meaningful on a
    /// resolved (non-automatic) option.
    var backendValue: String {
        switch self {
        case .automatic: return VPNProtocolOption.wireguard.backendValue
        case .wireguard: return "WIREGUARD"
        case .amneziawg: return "AMNEZIA"
        case .xray: return "XRAY"
        }
    }
}
