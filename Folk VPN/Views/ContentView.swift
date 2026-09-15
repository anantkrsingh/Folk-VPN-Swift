//
//  ContentView.swift
//  Folk VPN
//
//  Created by Anant Kumar on 14/09/26.
//

import SwiftUI

struct ContentView: View {
    @State private var controller = VPNController()
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        ZStack {
            GlowingMoonBackground()

            VStack(spacing: 32) {
                header

                Spacer()

                connectButton

                Text(statusText)
                    .font(.geist(.title3, weight: .semibold))
                    .foregroundStyle(.primary)

                Spacer()

                serverChip
                    .padding(.bottom, 24)
            }
            .padding(.horizontal, 24)
            .padding(.top, 24)
        }
    }

    private var header: some View {
        HStack {
            Text("Folk VPN")
                .font(.geist(.title2, weight: .semibold))
                .foregroundStyle(.primary)

            Spacer()

            Button {
                // TODO: present settings
            } label: {
                Image(systemName: "gearshape.fill")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(.primary)
                    .frame(width: 42, height: 42)
            }
            .buttonStyle(.plain)
            .glassEffect(.regular.interactive(), in: .circle)
        }
    }

    private var connectButton: some View {
        Button(action: toggleConnection) {
            ZStack {
                Circle()
                    .fill(centerFill)
                    .frame(width: 220, height: 220)
                    .shadow(color: shadowColor, radius: 30, y: 8)

                if isConnected {
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    Color(red: 0.55, green: 1.00, blue: 0.65),
                                    Color(red: 0.25, green: 0.85, blue: 0.45),
                                    Color(red: 0.10, green: 0.55, blue: 0.25)
                                ],
                                center: .center,
                                startRadius: 0,
                                endRadius: 110
                            )
                        )
                        .frame(width: 220, height: 220)
                        .transition(.opacity)
                }

                Circle()
                    .stroke(Color.white, lineWidth: 8)
                    .frame(width: 220, height: 220)

                if isTransitioning {
                    TimelineView(.animation) { context in
                        let angle = context.date.timeIntervalSinceReferenceDate.remainder(dividingBy: 1.4) / 1.4 * 360
                        Circle()
                            .trim(from: 0, to: 0.5)
                            .stroke(
                                Color.accentColor,
                                style: StrokeStyle(lineWidth: 8, lineCap: .round)
                            )
                            .frame(width: 220, height: 220)
                            .rotationEffect(.degrees(angle))
                            .shadow(color: Color.accentColor.opacity(0.9), radius: 8)
                            .shadow(color: Color.accentColor.opacity(0.55), radius: 20)
                    }
                    .transition(.opacity)
                }

                Image(systemName: isConnected ? "lock.fill" : "lock.open.fill")
                    .font(.system(size: 68, weight: .medium))
                    .foregroundStyle(isConnected ? .white : iconColor)
                    .shadow(color: isConnected ? Color.black.opacity(0.35) : .clear, radius: 10, y: 2)
            }
        }
        .buttonStyle(.plain)
        .disabled(isTransitioning)
        .animation(.easeInOut(duration: 0.35), value: isTransitioning)
        .animation(.easeInOut(duration: 0.35), value: isConnected)
    }

    private var serverChip: some View {
        Menu {
            ForEach(controller.servers) { server in
                Button {
                    controller.selectedServer = server
                } label: {
                    Text("\(server.name) (\(server.countryCode))")
                }
            }
        } label: {
            HStack(spacing: 10) {
                Image(systemName: "globe")
                    .font(.system(size: 14, weight: .medium))
                VStack(alignment: .leading, spacing: 1) {
                    Text("Selected server")
                        .font(.geist(.caption))
                        .foregroundStyle(.secondary)
                    Text(controller.selectedServer.map { "\($0.name) (\($0.countryCode))" } ?? "None")
                        .font(.geist(.subheadline, weight: .semibold))
                        .foregroundStyle(.primary)
                }
                Spacer()
                Image(systemName: "chevron.up.chevron.down")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
        .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 18))
    }

    private var centerFill: Color {
        switch colorScheme {
        case .dark: return Color(red: 0.14, green: 0.14, blue: 0.18)
        default: return Color(red: 0.90, green: 0.90, blue: 0.93)
        }
    }

    private var iconColor: Color {
        switch colorScheme {
        case .dark: return .white.opacity(0.9)
        default: return Color(red: 0.20, green: 0.22, blue: 0.28)
        }
    }

    private var shadowColor: Color {
        switch colorScheme {
        case .dark: return Color.black.opacity(0.5)
        default: return Color.black.opacity(0.18)
        }
    }

    private var statusText: String {
        switch controller.state {
        case .disconnected: return "Disconnected"
        case .connecting: return "Connecting…"
        case .connected: return "Connected"
        case .disconnecting: return "Disconnecting…"
        case .failed(let message): return "Failed: \(message)"
        }
    }

    private var isConnected: Bool {
        if case .connected = controller.state { return true }
        return false
    }

    private var isTransitioning: Bool {
        switch controller.state {
        case .connecting, .disconnecting: return true
        default: return false
        }
    }

    private func toggleConnection() {
        Task {
            switch controller.state {
            case .connected, .connecting:
                await controller.disconnect()
            default:
                await controller.connect()
            }
        }
    }
}

#Preview {
    ContentView()
}
