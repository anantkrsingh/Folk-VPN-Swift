//
//  VPNConfigText.swift
//  Folk VPN
//
//  Created by Anant Kumar on 16/09/26.
//

import Foundation

/// Plain-text patches applied to a backend-issued wg-quick config before handing it to
/// the tunnel extension. The backend only ever receives our public key, so its
/// PrivateKey line is a placeholder that must be overwritten locally — mirrors the
/// Android app's WireguardManager.applyPrivateKey/applyDnsOverride.
enum VPNConfigText {
    static func applyPrivateKey(_ configText: String, privateKeyBase64: String) -> String {
        setInterfaceField(configText, key: "PrivateKey", value: privateKeyBase64)
    }

    /// Overrides the config's DNS line with the user's chosen servers. Leaves the
    /// config untouched for "Automatic" (empty array), keeping whatever DNS the
    /// server's own config already specifies.
    static func applyDNS(_ configText: String, servers: [String]) -> String {
        guard !servers.isEmpty else { return configText }
        return setInterfaceField(configText, key: "DNS", value: servers.joined(separator: ", "))
    }

    /// Replaces (or inserts) a `key = value` line inside the config's `[Interface]` section.
    private static func setInterfaceField(_ configText: String, key: String, value: String) -> String {
        var lines = configText.components(separatedBy: .newlines)
        guard let interfaceIndex = lines.firstIndex(where: {
            $0.trimmingCharacters(in: .whitespaces).caseInsensitiveCompare("[Interface]") == .orderedSame
        }) else {
            return configText
        }

        var fieldLineIndex: Int?
        var i = interfaceIndex + 1
        while i < lines.count, !lines[i].trimmingCharacters(in: .whitespaces).hasPrefix("[") {
            let lineKey = lines[i].split(separator: "=", maxSplits: 1).first?.trimmingCharacters(in: .whitespaces) ?? ""
            if lineKey.caseInsensitiveCompare(key) == .orderedSame {
                fieldLineIndex = i
                break
            }
            i += 1
        }

        let fieldLine = "\(key) = \(value)"
        if let fieldLineIndex {
            lines[fieldLineIndex] = fieldLine
        } else {
            lines.insert(fieldLine, at: interfaceIndex + 1)
        }
        return lines.joined(separator: "\n")
    }
}
