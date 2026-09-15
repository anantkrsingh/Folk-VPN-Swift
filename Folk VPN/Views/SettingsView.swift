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
                    VStack(spacing: 16) {
                        GroupedCard {
                            SettingsRow(title: "Split Tunneling") {
                                // TODO
                            }
                            SettingsRowDivider()
                            SettingsRow(title: "Protocol") {
                                // TODO
                            }
                            SettingsRowDivider()
                            SettingsRow(title: "DNS") {
                                // TODO
                            }
                        }

                        GroupedCard {
                            SettingsRow(title: "Contact") {
                                // TODO
                            }
                        }

                        GroupedCard {
                            SettingsRow(title: "Privacy Policy", isExternal: true) {
                                UIApplication.shared.open(privacyURL)
                            }
                            SettingsRowDivider()
                            SettingsRow(title: "Terms", isExternal: true) {
                                UIApplication.shared.open(termsURL)
                            }
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

private struct GroupedCard<Content: View>: View {
    @ViewBuilder var content: Content

    var body: some View {
        VStack(spacing: 0) {
            content
        }
        .glassEffect(.regular, in: .rect(cornerRadius: 14))
    }
}

private struct SettingsRow: View {
    let title: String
    var value: String? = nil
    var isExternal: Bool = false
    var onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
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
            .padding(.vertical, 15)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

private struct SettingsRowDivider: View {
    var body: some View {
        Rectangle()
            .fill(Color.black.opacity(0.08))
            .frame(height: 1)
            .padding(.leading, 16)
    }
}

#Preview {
    SettingsView(onDismiss: {})
}
