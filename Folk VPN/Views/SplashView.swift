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
                    .foregroundStyle(.white)
                    .shadow(color: Color.white.opacity(0.35), radius: 24)

                Text("Folk VPN")
                    .font(.system(size: 28, weight: .semibold, design: .rounded))
                    .foregroundStyle(.white)

                ProgressView()
                    .tint(.white)
                    .padding(.top, 8)

                Text("Initializing…")
                    .font(.footnote)
                    .foregroundStyle(.white.opacity(0.7))
            }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    SplashView()
}
