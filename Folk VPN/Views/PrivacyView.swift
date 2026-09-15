//
//  PrivacyView.swift
//  Folk VPN
//
//  Created by Anant Kumar on 14/09/26.
//

import SwiftUI

struct PrivacyView: View {
    var onAccept: () -> Void
    var onReject: () -> Void

    private static let privacyURL = "https://anantkrsingh.github.io/react-native-openvpn/public/privacy-policy.html"

    var body: some View {
        ZStack {
            GlowingMoonBackground()

            VStack(spacing: 0) {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        Text("We value your privacy")
                            .font(.geist(.title2, weight: .semibold))
                            .foregroundStyle(.primary)
                            .padding(.top, 32)

                        VStack(spacing: 14) {
                            Text("That’s why we want to be transparent about what data you agree to give us. Folk VPN only collects the bare minimum of information required to offer a smooth and stable VPN experience.")

                            Text("Your browsing activities remain private, regardless of your choice.")

                            Text("By selecting **“Accept,”** you allow us to collect and use limited app performance data for analytics and diagnostics, as explained in our [Privacy Policy](\(Self.privacyURL)).")
                        }
                        .font(.geist(.callout))
                        .foregroundStyle(.primary.opacity(0.85))
                        .multilineTextAlignment(.center)
                        .lineSpacing(3)
                        .fixedSize(horizontal: false, vertical: true)
                        .tint(.accentColor)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)
                }

                VStack(spacing: 12) {
                    Button(action: onAccept) {
                        Text("Accept")
                            .font(.geist(.headline, weight: .semibold))
                            .frame(maxWidth: .infinity, minHeight: 30)
                    }
                    .buttonStyle(.glassProminent)
                    .buttonBorderShape(.roundedRectangle(radius: 18))
                    .controlSize(.large)
                    .tint(.accentColor)

                    Button(action: onReject) {
                        Text("Reject")
                            .font(.geist(.headline, weight: .medium))
                            .frame(maxWidth: .infinity, minHeight: 30)
                    }
                    .buttonStyle(.glass)
                    .buttonBorderShape(.roundedRectangle(radius: 18))
                    .controlSize(.large)
                }
                .padding(.horizontal, 24)
                .padding(.top, 12)
                .padding(.bottom, 24)
            }
        }
    }
}

#Preview {
    PrivacyView(onAccept: {}, onReject: {})
}
