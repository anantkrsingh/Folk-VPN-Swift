//
//  AppController.swift
//  Folk VPN
//
//  Created by Anant Kumar on 14/09/26.
//

import Foundation
import Observation

@Observable
final class AppController {
    enum Phase: Equatable {
        case launching
        case privacy
        case ready
    }

    private(set) var phase: Phase = .launching
    private(set) var publicKeyBase64: String?

    let vpnController = VPNController()

    private let privacyAcceptedKey = "folkvpn.hasAcceptedPrivacy"

    func start() async {
        let keys = await Task.detached(priority: .userInitiated) {
            KeyManager.ensureKeys()
        }.value
        publicKeyBase64 = keys.publicKeyBase64

        async let servers: Void = vpnController.loadServers()
        async let minimum: Void = minimumSplashDelay()
        _ = await (servers, minimum)

        let accepted = UserDefaults.standard.bool(forKey: privacyAcceptedKey)
        phase = accepted ? .ready : .privacy
    }

    func acceptPrivacy() {
        UserDefaults.standard.set(true, forKey: privacyAcceptedKey)
        phase = .ready
    }

    private func minimumSplashDelay() async {
        try? await Task.sleep(nanoseconds: 1_400_000_000)
    }
}
