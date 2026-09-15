//
//  SplashView.swift
//  Folk VPN
//
//  Created by Anant Kumar on 14/09/26.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        ZStack {
            GlowingMoonBackground()

            VStack(spacing: 20) {
                Image(systemName: "shield.lefthalf.filled")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 96, height: 96)
                    .foregroundStyle(.primary)
                    .shadow(color: Color.accentColor.opacity(0.35), radius: 24)

                Text("Folk VPN")
                    .font(.system(size: 28, weight: .semibold, design: .rounded))
                    .foregroundStyle(.primary)

                ProgressView()
                    .padding(.top, 8)

                Text("Initializing…")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    SplashView()
}
