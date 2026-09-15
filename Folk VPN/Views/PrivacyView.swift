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
            AppBackground()

            VStack(spacing: 32) {
                Spacer()

                VStack(spacing: 16) {
                    Text("We value your privacy")
                        .font(.geist(28, weight: .bold))
                        .foregroundStyle(.black)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)

                    Text("Folk VPN keeps your browsing activity private and only collects the bare minimum of information required to offer a smooth, stable, and secure connection. By tapping Accept, you allow limited app performance data to be used for analytics and diagnostics, as explained in our Privacy Policy.")
                        .font(.geist(.callout))
                        .foregroundStyle(.black.opacity(0.7))
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

                VStack(spacing: 12) {
                    Button(action: onAccept) {
                        Text("Accept")
                            .font(.geist(.headline, weight: .semibold))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity, minHeight: 52)
                            .background(
                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                    .fill(Color.black)
                            )
                            .shadowXS()
                    }
                    .buttonStyle(.plain)

                    Button {
                        showRejectSheet = true
                    } label: {
                        Text("Reject")
                            .font(.geist(.headline, weight: .medium))
                            .foregroundStyle(.black)
                            .frame(maxWidth: .infinity, minHeight: 52)
                            .background(
                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                    .fill(Color.appSurfaceElevated)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                    .stroke(Color.appBorder, lineWidth: 1)
                            )
                            .shadowXS()
                    }
                    .buttonStyle(.plain)
                }
                .padding(.bottom, 12)
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 24)
        }
        .sheet(isPresented: $showRejectSheet) {
            RejectSheet(onDismiss: { showRejectSheet = false })
                .presentationDetents([.height(360)])
                .presentationDragIndicator(.visible)
                .presentationBackground(Color.appSurface)
                .presentationCornerRadius(28)
        }
    }
}

private struct RejectSheet: View {
    var onDismiss: () -> Void

    @State private var showingExitGuidance = false

    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 10) {
                Text(showingExitGuidance ? "Close Folk VPN to exit" : "Are you sure you want to exit?")
                    .font(.geist(.title3, weight: .semibold))
                    .foregroundStyle(.black)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)

                Text(showingExitGuidance
                     ? "Swipe up from the bottom of the screen to close Folk VPN. Reopen the app and tap Accept whenever you’re ready to continue."
                     : "In accordance with user data protection, we can’t provide our services without your consent.")
                    .font(.geist(.callout))
                    .foregroundStyle(.black.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer(minLength: 0)

            VStack(spacing: 12) {
                Button(action: onDismiss) {
                    Text(showingExitGuidance ? "Go back" : "Dismiss")
                        .font(.geist(.headline, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity, minHeight: 48)
                        .background(
                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                                .fill(Color.black)
                        )
                        .shadowXS()
                }
                .buttonStyle(.plain)

                if !showingExitGuidance {
                    Button {
                        showingExitGuidance = true
                    } label: {
                        Text("Leave anyway")
                            .font(.geist(.headline, weight: .medium))
                            .foregroundStyle(.red)
                            .frame(maxWidth: .infinity, minHeight: 48)
                            .background(
                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                    .fill(Color.appSurfaceElevated)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                    .stroke(Color.appBorder, lineWidth: 1)
                            )
                            .shadowXS()
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(.horizontal, 24)
        .padding(.top, 28)
        .padding(.bottom, 24)
        .animation(.easeInOut(duration: 0.25), value: showingExitGuidance)
    }
}

#Preview {
    PrivacyView(onAccept: {})
}
