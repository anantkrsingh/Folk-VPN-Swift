//
//  GlowingMoonBackground.swift
//  Folk VPN
//
//  Created by Anant Kumar on 14/09/26.
//

import SwiftUI

struct GlowingMoonBackground: View {
    enum Mood {
        case standard
        case connected
    }

    var mood: Mood = .standard

    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        LinearGradient(
            colors: baseColors,
            startPoint: .top,
            endPoint: .bottom
        )
        .overlay(alignment: .top) {
            Circle()
                .fill(
                    RadialGradient(
                        colors: primaryGlowColors,
                        center: .center,
                        startRadius: 10,
                        endRadius: 300
                    )
                )
                .frame(width: 560, height: 560)
                .blur(radius: 70)
                .offset(x: -30, y: -260)
                .allowsHitTesting(false)
        }
        .overlay(alignment: .top) {
            Circle()
                .fill(accentGlowColor)
                .frame(width: 320, height: 320)
                .blur(radius: 110)
                .offset(x: 140, y: -80)
                .allowsHitTesting(false)
        }
        .animation(.easeInOut(duration: 0.6), value: mood)
        .clipped()
        .ignoresSafeArea()
    }

    private var baseColors: [Color] {
        switch (mood, colorScheme) {
        case (.connected, .dark):
            return [
                Color(red: 0.02, green: 0.10, blue: 0.08),
                Color(red: 0.03, green: 0.14, blue: 0.10),
                Color(red: 0.02, green: 0.06, blue: 0.04)
            ]
        case (.connected, _):
            return [
                Color(red: 0.92, green: 1.00, blue: 0.95),
                Color(red: 0.94, green: 1.00, blue: 0.94),
                Color(red: 0.98, green: 1.00, blue: 0.98)
            ]
        case (_, .dark):
            return [
                Color(red: 0.03, green: 0.04, blue: 0.10),
                Color(red: 0.06, green: 0.03, blue: 0.14),
                Color(red: 0.02, green: 0.02, blue: 0.06)
            ]
        default:
            return [
                Color(red: 0.92, green: 0.94, blue: 1.00),
                Color(red: 0.96, green: 0.94, blue: 1.00),
                Color(red: 0.99, green: 0.98, blue: 1.00)
            ]
        }
    }

    private var primaryGlowColors: [Color] {
        switch (mood, colorScheme) {
        case (.connected, .dark):
            return [
                Color(red: 0.40, green: 1.00, blue: 0.55).opacity(0.70),
                Color(red: 0.20, green: 0.85, blue: 0.55).opacity(0.35),
                .clear
            ]
        case (.connected, _):
            return [
                Color(red: 0.40, green: 0.95, blue: 0.55).opacity(0.55),
                Color(red: 0.55, green: 0.85, blue: 0.65).opacity(0.25),
                .clear
            ]
        case (_, .dark):
            return [
                Color(red: 0.55, green: 0.70, blue: 1.0).opacity(0.65),
                Color(red: 0.35, green: 0.45, blue: 0.95).opacity(0.30),
                .clear
            ]
        default:
            return [
                Color(red: 0.55, green: 0.65, blue: 1.0).opacity(0.45),
                Color(red: 0.70, green: 0.60, blue: 1.0).opacity(0.20),
                .clear
            ]
        }
    }

    private var accentGlowColor: Color {
        switch (mood, colorScheme) {
        case (.connected, .dark):
            return Color(red: 0.30, green: 0.85, blue: 0.45).opacity(0.40)
        case (.connected, _):
            return Color(red: 0.45, green: 0.85, blue: 0.55).opacity(0.30)
        case (_, .dark):
            return Color(red: 0.65, green: 0.35, blue: 0.95).opacity(0.35)
        default:
            return Color(red: 0.75, green: 0.55, blue: 1.0).opacity(0.22)
        }
    }
}

#Preview("Standard Dark") {
    ZStack {
        GlowingMoonBackground()
        Text("Content").foregroundStyle(.primary)
    }
    .preferredColorScheme(.dark)
}

#Preview("Connected Dark") {
    ZStack {
        GlowingMoonBackground(mood: .connected)
        Text("Connected").foregroundStyle(.primary)
    }
    .preferredColorScheme(.dark)
}
