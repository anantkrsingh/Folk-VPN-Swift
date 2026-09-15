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
    var onCustomize: () -> Void = {}

    private static let privacyURL = "https://anantkrsingh.github.io/react-native-openvpn/public/privacy-policy.html"

    var body: some View {
        ZStack {
            GlowingMoonBackground()

            VStack(spacing: 24) {
                Spacer(minLength: 40)

                Text("We value your privacy")
                    .font(.title2.weight(.semibold))
                    .foregroundStyle(.white)

                VStack(spacing: 14) {
                    Text("That’s why we want to be transparent about what data you agree to give us. Folk VPN only collects the bare minimum of information required to offer a smooth and stable VPN experience.")

                    Text("Your browsing activities remain private, regardless of your choice.")

                    Text("By selecting **“Accept,”** you allow us to collect and use limited app performance data for analytics and diagnostics, as explained in our [Privacy Policy](\(Self.privacyURL)).")

                    Text("Select **“Customize”** to manage your privacy choices or learn more about each option.")
                }
                .font(.callout)
                .foregroundStyle(.white.opacity(0.85))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
                .tint(Color(red: 0.65, green: 0.75, blue: 1.0))

                Spacer()

                VStack(spacing: 12) {
                    Button(action: onAccept) {
                        Text("Accept")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 6)
                    }
                    .buttonStyle(.glassProminent)
                    .tint(Color(red: 0.35, green: 0.45, blue: 0.95))

                    Button(action: onReject) {
                        Text("Reject")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 6)
                    }
                    .buttonStyle(.glass)

                    Button(action: onCustomize) {
                        Text("Customize")
                            .font(.subheadline.weight(.medium))
                            .foregroundStyle(Color(red: 0.75, green: 0.80, blue: 1.0))
                            .padding(.top, 4)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
            }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    PrivacyView(onAccept: {}, onReject: {})
}
