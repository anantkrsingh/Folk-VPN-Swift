//
//  PrivacyView.swift
//  Folk VPN
//
//  Created by Anant Kumar on 14/09/26.
//

import SwiftUI

struct PrivacyView: View {
    var onAccept: () -> Void

    @State private var showRejectSheet = false

    private static let privacyURL = URL(string: "https://anantkrsingh.github.io/react-native-openvpn/public/privacy-policy.html")!

    var body: some View {
        ZStack {
            GlowingMoonBackground()

            VStack(spacing: 32) {
                Spacer()

                VStack(spacing: 16) {
                    Text("We value your privacy")
                        .font(.geist(28, weight: .bold))
                        .foregroundStyle(.primary)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)

                    Text("Folk VPN keeps your browsing activity private and only collects the bare minimum of information required to offer a smooth, stable, and secure connection. By tapping Accept, you allow limited app performance data to be used for analytics and diagnostics, as explained in our Privacy Policy.")
                        .font(.geist(.callout))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Link(destination: Self.privacyURL) {
                    HStack(spacing: 4) {
                        Text("Read Privacy Policy")
                        Image(systemName: "arrow.up.right")
                            .font(.system(size: 11, weight: .semibold))
                    }
                    .font(.geist(.footnote, weight: .medium))
                    .foregroundStyle(Color.accentColor)
                }

                Spacer()

                VStack(spacing: 14) {
                    Button(action: onAccept) {
                        Text("Accept")
                            .font(.geist(.headline, weight: .semibold))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity, minHeight: 56)
                    }
                    .buttonStyle(.plain)
                    .glassEffect(
                        .regular.tint(.accentColor).interactive(),
                        in: .rect(cornerRadius: 22)
                    )

                    Button {
                        showRejectSheet = true
                    } label: {
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
                }
                .padding(.bottom, 12)
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 24)
        }
        .sheet(isPresented: $showRejectSheet) {
            RejectSheet(
                onDismiss: { showRejectSheet = false },
                onLeave: { exit(0) }
            )
            .presentationDetents([.height(320)])
            .presentationDragIndicator(.visible)
            .presentationBackground(.thinMaterial)
            .presentationCornerRadius(28)
        }
    }
}

private struct RejectSheet: View {
    var onDismiss: () -> Void
    var onLeave: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 10) {
                Text("Are you sure you want to exit?")
                    .font(.geist(.title3, weight: .semibold))
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)

                Text("In accordance with user data protection, we can’t provide our services without your consent.")
                    .font(.geist(.callout))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer(minLength: 0)

            VStack(spacing: 12) {
                Button(action: onDismiss) {
                    Text("Dismiss")
                        .font(.geist(.headline, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity, minHeight: 52)
                }
                .buttonStyle(.plain)
                .glassEffect(
                    .regular.tint(.accentColor).interactive(),
                    in: .rect(cornerRadius: 20)
                )

                Button(action: onLeave) {
                    Text("Leave anyway")
                        .font(.geist(.headline, weight: .medium))
                        .foregroundStyle(.red)
                        .frame(maxWidth: .infinity, minHeight: 52)
                }
                .buttonStyle(.plain)
                .glassEffect(
                    .regular.interactive(),
                    in: .rect(cornerRadius: 20)
                )
            }
        }
        .padding(.horizontal, 24)
        .padding(.top, 28)
        .padding(.bottom, 24)
    }
}

#Preview {
    PrivacyView(onAccept: {})
}
