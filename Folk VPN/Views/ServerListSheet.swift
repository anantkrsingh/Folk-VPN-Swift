//
//  ServerListSheet.swift
//  Folk VPN
//
//  Created by Anant Kumar on 14/09/26.
//

import SwiftUI

struct ServerListSheet: View {
    let servers: [VPNServer]
    let selectedID: Int?
    let isLoading: Bool
    let errorMessage: String?
    var onSelect: (VPNServer) -> Void
    var onRetry: () async -> Void

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Select server")
                    .font(.geist(.title3, weight: .semibold))
                    .foregroundStyle(.primary)
                Spacer()
            }
            .padding(.horizontal, 24)
            .padding(.top, 20)
            .padding(.bottom, 12)

            content
        }
    }

    @ViewBuilder
    private var content: some View {
        if isLoading && servers.isEmpty {
            VStack(spacing: 12) {
                ProgressView()
                Text("Loading servers…")
                    .font(.geist(.footnote))
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.vertical, 40)
        } else if let errorMessage, servers.isEmpty {
            VStack(spacing: 12) {
                Image(systemName: "wifi.exclamationmark")
                    .font(.system(size: 32))
                    .foregroundStyle(.secondary)
                Text(errorMessage)
                    .font(.geist(.footnote))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                Button {
                    Task { await onRetry() }
                } label: {
                    Text("Retry")
                        .font(.geist(.headline, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(minWidth: 140, minHeight: 44)
                        .background(
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .fill(Color.accentColor)
                        )
                }
                .buttonStyle(.plain)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.vertical, 40)
        } else {
            ScrollView {
                LazyVStack(spacing: 8) {
                    ForEach(servers) { server in
                        ServerRow(
                            server: server,
                            isSelected: server.id == selectedID
                        ) {
                            onSelect(server)
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 24)
            }
        }
    }
}

private struct ServerRow: View {
    let server: VPNServer
    let isSelected: Bool
    var onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 14) {
                AsyncImage(url: server.country.flagUrl) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    case .empty:
                        Color.gray.opacity(0.15)
                    case .failure:
                        Image(systemName: "flag.slash")
                            .foregroundStyle(.secondary)
                    @unknown default:
                        Color.gray.opacity(0.15)
                    }
                }
                .frame(width: 40, height: 28)
                .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))

                VStack(alignment: .leading, spacing: 2) {
                    Text(server.country.name)
                        .font(.geist(.body, weight: .semibold))
                        .foregroundStyle(.primary)
                    Text(server.region)
                        .font(.geist(.caption))
                        .foregroundStyle(.secondary)
                }

                Spacer()

                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(.green)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(isSelected ? Color.accentColor.opacity(0.10) : Color.primary.opacity(0.03))
            )
            .contentShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        }
        .buttonStyle(.plain)
    }
}
