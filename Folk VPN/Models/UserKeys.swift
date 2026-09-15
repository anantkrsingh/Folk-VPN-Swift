//
//  UserKeys.swift
//  Folk VPN
//
//  Created by Anant Kumar on 14/09/26.
//

import Foundation
import CryptoKit

struct UserKeys {
    let privateKey: Curve25519.KeyAgreement.PrivateKey

    var publicKey: Curve25519.KeyAgreement.PublicKey {
        privateKey.publicKey
    }

    var privateKeyBase64: String {
        privateKey.rawRepresentation.base64EncodedString()
    }

    var publicKeyBase64: String {
        publicKey.rawRepresentation.base64EncodedString()
    }
}
