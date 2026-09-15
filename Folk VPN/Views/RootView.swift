//
//  RootView.swift
//  Folk VPN
//
//  Created by Anant Kumar on 14/09/26.
//

import SwiftUI

struct RootView: View {
    @State private var appController = AppController()

    var body: some View {
        ZStack {
            switch appController.phase {
            case .launching:
                SplashView()
                    .transition(.opacity)
            case .privacy:
                PrivacyView(onAccept: appController.acceptPrivacy)
                    .transition(.opacity)
            case .ready:
                ContentView(controller: appController.vpnController)
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.35), value: appController.phase)
        .task { await appController.start() }
    }
}

#Preview {
    RootView()
}
