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
        VStack(spacing: 24) {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)

            Text(statusText)
                .font(.headline)

            Picker("Server", selection: $controller.selectedServer) {
                ForEach(controller.servers) { server in
                    Text("\(server.name) (\(server.countryCode))")
                        .tag(Optional(server))
                }
            }
            .pickerStyle(.menu)

            Button(action: toggleConnection) {
                Text(buttonTitle)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .disabled(isTransitioning)
        }
        .padding()
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
