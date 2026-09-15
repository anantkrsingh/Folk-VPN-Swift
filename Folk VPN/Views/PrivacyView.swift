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
                    .padding(.top, 56)

                Spacer(minLength: 28)

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
                    .padding(.vertical, 4)
                }

                Spacer(minLength: 16)

                actionSection
                    .padding(.bottom, 28)
            }
            .padding(.horizontal, 24)
        }
    }

    private var headerSection: some View {
        VStack(spacing: 10) {
            Text("We value your privacy")
                .font(.geist(28, weight: .bold))
                .foregroundStyle(.primary)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)

            Text("Transparent about what data we collect, private about what you do online.")
                .font(.geist(.subheadline))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private var actionSection: some View {
        VStack(spacing: 14) {
            Link(destination: Self.privacyURL) {
                HStack(spacing: 4) {
                    Text("Read Privacy Policy")
                    Image(systemName: "arrow.up.right")
                        .font(.system(size: 11, weight: .semibold))
                }
                .font(.geist(.footnote, weight: .medium))
                .foregroundStyle(Color.accentColor)
            }

            Button(action: onAccept) {
                Text("Accept")
                    .font(.geist(.headline, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, minHeight: 56)
            }
            .buttonStyle(.plain)
            .background(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(Color.accentColor)
            )
            .glassEffect(
                .regular.tint(.accentColor).interactive(),
                in: .rect(cornerRadius: 22)
            )
            .contentShape(RoundedRectangle(cornerRadius: 22, style: .continuous))

            Button(action: onReject) {
                Text("Reject")
                    .font(.geist(.headline, weight: .medium))
                    .foregroundStyle(.primary)
                    .frame(maxWidth: .infinity, minHeight: 56)
            }
            .buttonStyle(.plain)
            .glassEffect(
                .regular.interactive(),
                in: .rect(cornerRadius: 22)
            )
            .contentShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
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
                    .fill(Color.accentColor.opacity(0.18))
                    .frame(width: 38, height: 38)
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(Color.accentColor)
            }

            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.geist(.subheadline, weight: .semibold))
                    .foregroundStyle(.primary)
                    .fixedSize(horizontal: false, vertical: true)
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
