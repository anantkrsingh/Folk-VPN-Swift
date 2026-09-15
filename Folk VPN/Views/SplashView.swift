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
            AppBackground()

            VStack(spacing: 20) {
                Image(systemName: "shield.lefthalf.filled")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 96, height: 96)
                    .foregroundStyle(.black)

                Text("Folk VPN")
                    .font(.geist(28, weight: .semibold))
                    .foregroundStyle(.black)

                ProgressView()
                    .tint(.black)
                    .padding(.top, 8)

                Text("Initializing…")
                    .font(.geist(.footnote))
                    .foregroundStyle(.black.opacity(0.6))
            }
        }
    }
}

#Preview {
    SplashView()
}
