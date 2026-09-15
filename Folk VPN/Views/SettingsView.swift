//
//  SettingsView.swift
//  Folk VPN
//
//  Created by Anant Kumar on 14/09/26.
//

import SwiftUI

struct SettingsView: View {
    var onDismiss: () -> Void

    // TODO: replace with the real Terms URL when available.
    private let privacyURL = URL(string: "https://anantkrsingh.github.io/react-native-openvpn/public/privacy-policy.html")!
    private let termsURL = URL(string: "https://anantkrsingh.github.io/react-native-openvpn/public/terms.html")!

    var body: some View {
        ZStack {
            AppBackground()

            VStack(spacing: 0) {
                header
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 16)

                ScrollView {
                    VStack(spacing: 10) {
                        SettingsRow(icon: "arrow.triangle.branch", title: "Split Tunneling") {
                            // TODO: present split tunneling
                        }
                        SettingsRow(icon: "lock.shield", title: "Protocol") {
                            // TODO: present protocol picker
                        }
                        SettingsRow(icon: "envelope", title: "Contact") {
                            // TODO: present contact
                        }
                        SettingsRow(icon: "network", title: "DNS") {
                            // TODO: present DNS
                        }

                        Rectangle()
                            .fill(Color.appBorder)
                            .frame(height: 1)
                            .padding(.vertical, 6)

                        SettingsRow(icon: "hand.raised", title: "Privacy Policy", isExternal: true) {
                            UIApplication.shared.open(privacyURL)
                        }
                        SettingsRow(icon: "doc.text", title: "Terms", isExternal: true) {
                            UIApplication.shared.open(termsURL)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 16)
                }

                Text("Version \(appVersion)")
                    .font(.geist(.footnote))
                    .foregroundStyle(.black.opacity(0.5))
                    .padding(.bottom, 24)
            }
        }
    }

    private var header: some View {
        HStack {
            Text("Settings")
                .font(.geist(.title2, weight: .bold))
                .foregroundStyle(.black)

            Spacer()

            Button(action: onDismiss) {
                Image(systemName: "xmark")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(.black)
                    .frame(width: 36, height: 36)
                    .contentShape(Circle())
            }
            .buttonStyle(.plain)
            .glassEffect(.regular, in: .circle)
        }
    }

    private var appVersion: String {
        let short = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0"
        let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "1"
        return "\(short) (\(build))"
    }
}

private struct SettingsRow: View {
    let icon: String
    let title: String
    var value: String? = nil
    var isExternal: Bool = false
    var onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 14) {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(.black)
                    .frame(width: 24, height: 24)

                Text(title)
                    .font(.geist(.body, weight: .medium))
                    .foregroundStyle(.black)

                Spacer()

                if let value {
                    Text(value)
                        .font(.geist(.footnote))
                        .foregroundStyle(.black.opacity(0.55))
                }

                Image(systemName: isExternal ? "arrow.up.right" : "chevron.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(.black.opacity(0.4))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color.white)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(Color.appBorder, lineWidth: 1)
            )
            .shadowXS()
            .contentShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    SettingsView(onDismiss: {})
}
