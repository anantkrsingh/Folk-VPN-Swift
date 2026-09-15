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

    private static let privacyURL = URL(string: "https://anantkrsingh.github.io/react-native-openvpn/public/privacy-policy.html")!

    var body: some View {
        ZStack {
            GlowingMoonBackground()

            VStack(spacing: 0) {
                headerSection
                    .padding(.top, 32)

                Spacer(minLength: 24)

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 18) {
                        PrivacyBullet(
                            icon: "eye.slash.fill",
                            title: "Your browsing stays private",
                            detail: "We never log or share your activity, regardless of your choice."
                        )
                        PrivacyBullet(
                            icon: "chart.bar.fill",
                            title: "Minimal analytics",
                            detail: "Accepting lets us collect limited app performance data to keep Folk VPN fast and stable."
                        )
                        PrivacyBullet(
                            icon: "doc.text.fill",
                            title: "Full transparency",
                            detail: "Read our Privacy Policy for the complete picture of what we collect and why."
                        )
                    }
                    .padding(.horizontal, 24)
                }

                Spacer(minLength: 16)

                actionSection
                    .padding(.horizontal, 24)
                    .padding(.bottom, 28)
            }
        }
    }

    private var headerSection: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(Color.accentColor.opacity(0.18))
                    .frame(width: 86, height: 86)
                Image(systemName: "hand.raised.fill")
                    .font(.system(size: 36, weight: .semibold))
                    .foregroundStyle(Color.accentColor)
            }
            .shadow(color: Color.accentColor.opacity(0.35), radius: 24, y: 6)

            VStack(spacing: 8) {
                Text("We value your privacy")
                    .font(.geist(28, weight: .bold))
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.center)

                Text("Transparent about what data we collect, private about what you do online.")
                    .font(.geist(.subheadline))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }

    private var actionSection: some View {
        VStack(spacing: 12) {
            Link(destination: Self.privacyURL) {
                HStack(spacing: 4) {
                    Text("Read Privacy Policy")
                    Image(systemName: "arrow.up.right")
                        .font(.system(size: 11, weight: .semibold))
                }
                .font(.geist(.footnote, weight: .medium))
                .foregroundStyle(Color.accentColor)
            }
            .padding(.bottom, 4)

            Button(action: onAccept) {
                Text("Accept")
                    .font(.geist(.headline, weight: .semibold))
                    .frame(maxWidth: .infinity, minHeight: 36)
            }
            .buttonStyle(.glassProminent)
            .buttonBorderShape(.roundedRectangle(radius: 20))
            .controlSize(.extraLarge)
            .tint(.accentColor)

            Button(action: onReject) {
                Text("Reject")
                    .font(.geist(.headline, weight: .medium))
                    .frame(maxWidth: .infinity, minHeight: 36)
            }
            .buttonStyle(.glass)
            .buttonBorderShape(.roundedRectangle(radius: 20))
            .controlSize(.extraLarge)
        }
    }
}

private struct PrivacyBullet: View {
    let icon: String
    let title: String
    let detail: String

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 11, style: .continuous)
                    .fill(Color.accentColor.opacity(0.15))
                    .frame(width: 38, height: 38)
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(Color.accentColor)
            }

            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.geist(.subheadline, weight: .semibold))
                    .foregroundStyle(.primary)
                Text(detail)
                    .font(.geist(.footnote))
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    PrivacyView(onAccept: {}, onReject: {})
}
