//
//  ContentView.swift
//  Folk VPN
//
//  Created by Anant Kumar on 14/09/26.
//

import SwiftUI

struct ContentView: View {
    @State private var controller = VPNController()

    var body: some View {
        ZStack {
            GlowingMoonBackground()

            VStack(spacing: 24) {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.white)
                    .font(.system(size: 44))

                Text(statusText)
                    .font(.headline)
                    .foregroundStyle(.white)

                Picker("Server", selection: $controller.selectedServer) {
                    ForEach(controller.servers) { server in
                        Text("\(server.name) (\(server.countryCode))")
                            .tag(Optional(server))
                    }
                }
                .pickerStyle(.menu)
                .tint(.white)

                Button(action: toggleConnection) {
                    Text(buttonTitle)
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 6)
                }
                .buttonStyle(.glassProminent)
                .tint(Color(red: 0.35, green: 0.45, blue: 0.95))
                .disabled(isTransitioning)
                .padding(.horizontal, 24)
            }
            .padding()
        }
        .preferredColorScheme(.dark)
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

    private var buttonTitle: String {
        switch controller.state {
        case .connected, .disconnecting: return "Disconnect"
        default: return "Connect"
        }
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
