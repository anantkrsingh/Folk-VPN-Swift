//
//  DeviceIdentifier.swift
//  Folk VPN
//
//  Created by Anant Kumar on 16/09/26.
//

import Foundation

/// A stable per-install identifier sent to the backend as client_name/device_id/
/// user_id/app_user_id (mirrors the Android app's use of ANDROID_ID), until a real
/// purchase identity — e.g. RevenueCat's appUserID, as the Android app uses — is
/// wired up on iOS.
enum DeviceIdentifier {
    private static let storageKey = "folkvpn.deviceIdentifier"

    static var current: String {
        if let existing = UserDefaults.standard.string(forKey: storageKey) {
            return existing
        }
        let generated = UUID().uuidString
        UserDefaults.standard.set(generated, forKey: storageKey)
        return generated
    }
}
