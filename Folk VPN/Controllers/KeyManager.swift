//
//  KeyManager.swift
//  Folk VPN
//
//  Created by Anant Kumar on 14/09/26.
//

import Foundation
import CryptoKit
import Security

enum KeyManager {
    private static let service = "com.anant.Folk-VPN.keys"
    private static let account = "wireguard.privateKey"
    private static let publicKeyDefault = "folkvpn.publicKeyBase64"

    @discardableResult
    static func ensureKeys() -> UserKeys {
        if let existing = loadKeys() { return existing }
        let keys = UserKeys(privateKey: Curve25519.KeyAgreement.PrivateKey())
        save(keys)
        return keys
    }

    static func loadKeys() -> UserKeys? {
        guard let data = loadPrivateKeyData(),
              let key = try? Curve25519.KeyAgreement.PrivateKey(rawRepresentation: data)
        else { return nil }
        return UserKeys(privateKey: key)
    }

    static var publicKeyBase64: String? {
        UserDefaults.standard.string(forKey: publicKeyDefault)
    }

    static func resetKeys() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
        SecItemDelete(query as CFDictionary)
        UserDefaults.standard.removeObject(forKey: publicKeyDefault)
    }

    private static func save(_ keys: UserKeys) {
        savePrivateKeyData(keys.privateKey.rawRepresentation)
        UserDefaults.standard.set(keys.publicKeyBase64, forKey: publicKeyDefault)
    }

    private static func savePrivateKeyData(_ data: Data) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
        SecItemDelete(query as CFDictionary)

        var attributes = query
        attributes[kSecValueData as String] = data
        attributes[kSecAttrAccessible as String] = kSecAttrAccessibleAfterFirstUnlock
        SecItemAdd(attributes as CFDictionary, nil)
    }

    private static func loadPrivateKeyData() -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        guard status == errSecSuccess else { return nil }
        return result as? Data
    }
}
