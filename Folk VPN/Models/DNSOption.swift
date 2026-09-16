//
//  DNSOption.swift
//  Folk VPN
//
//  Created by Anant Kumar on 14/09/26.
//

import Foundation

enum DNSOption: String, CaseIterable, Identifiable {
    case automatic
    case google
    case cloudflare
    case cloudflareFamily
    case quad9

    static let storageKey = "folkvpn.dnsOption"

    var id: String { rawValue }

    var name: String {
        switch self {
        case .automatic: return "Automatic"
        case .google: return "Google"
        case .cloudflare: return "Cloudflare"
        case .cloudflareFamily: return "Cloudflare Family"
        case .quad9: return "Quad 9"
        }
    }

    var description: String {
        switch self {
        case .automatic:
            return "Let Folk VPN pick the fastest DNS server for your current connection."
        case .google:
            return "Fast, reliable public resolvers operated by Google (8.8.8.8, 8.8.4.4)."
        case .cloudflare:
            return "Privacy-focused resolvers from Cloudflare (1.1.1.1, 1.0.0.1)."
        case .cloudflareFamily:
            return "Cloudflare 1.1.1.1 for Families — blocks malware and adult content (1.1.1.3, 1.0.0.3)."
        case .quad9:
            return "Security-focused resolvers that block known malicious domains (9.9.9.9, 149.112.112.112)."
        }
    }

    var servers: [String] {
        switch self {
        case .automatic: return []
        case .google: return ["8.8.8.8", "8.8.4.4"]
        case .cloudflare: return ["1.1.1.1", "1.0.0.1"]
        case .cloudflareFamily: return ["1.1.1.3", "1.0.0.3"]
        case .quad9: return ["9.9.9.9", "149.112.112.112"]
        }
    }

    static var current: DNSOption {
        let raw = UserDefaults.standard.string(forKey: storageKey) ?? automatic.rawValue
        return DNSOption(rawValue: raw) ?? .automatic
    }

    /// The single DNS IP sent as the `dns` field of a conf-request; defaults to
    /// Cloudflare's 1.1.1.1 for Automatic, since the backend always expects a value.
    var primaryDNS: String {
        servers.first ?? "1.1.1.1"
    }
}
