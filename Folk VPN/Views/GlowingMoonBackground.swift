//
//  GlowingMoonBackground.swift
//  Folk VPN
//
//  Created by Anant Kumar on 14/09/26.
//

import SwiftUI

struct GlowingMoonBackground: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.03, green: 0.04, blue: 0.10),
                    Color(red: 0.06, green: 0.03, blue: 0.14),
                    Color(red: 0.02, green: 0.02, blue: 0.06)
                ],
                startPoint: .top,
                endPoint: .bottom
            )

            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color(red: 0.55, green: 0.70, blue: 1.0).opacity(0.65),
                            Color(red: 0.35, green: 0.45, blue: 0.95).opacity(0.30),
                            .clear
                        ],
                        center: .center,
                        startRadius: 10,
                        endRadius: 280
                    )
                )
                .frame(width: 520, height: 520)
                .blur(radius: 60)
                .offset(x: -40, y: -220)

            Circle()
                .fill(Color(red: 0.65, green: 0.35, blue: 0.95).opacity(0.35))
                .frame(width: 340, height: 340)
                .blur(radius: 110)
                .offset(x: 130, y: 260)

            Circle()
                .fill(Color(red: 0.30, green: 0.55, blue: 1.0).opacity(0.20))
                .frame(width: 260, height: 260)
                .blur(radius: 90)
                .offset(x: -140, y: 340)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    GlowingMoonBackground()
}
