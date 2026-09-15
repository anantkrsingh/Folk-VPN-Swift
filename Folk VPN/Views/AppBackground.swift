//
//  AppBackground.swift
//  Folk VPN
//
//  Created by Anant Kumar on 14/09/26.
//

import SwiftUI

struct AppBackground: View {
    var body: some View {
        Color.appSurface
            .ignoresSafeArea()
    }
}

extension Color {
    static let appSurface = Color(red: 0xE3 / 255.0, green: 0xD9 / 255.0, blue: 0xCA / 255.0)
    static let appSurfaceElevated = Color(red: 0xF3 / 255.0, green: 0xEC / 255.0, blue: 0xE0 / 255.0)
    static let appBorder = Color.black.opacity(0.10)
}

extension View {
    func shadowXS() -> some View {
        self.shadow(color: Color.black.opacity(0.05), radius: 1, x: 0, y: 1)
    }
}

#Preview {
    AppBackground()
}
