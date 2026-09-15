//
//  Font+Geist.swift
//  Folk VPN
//
//  Created by Anant Kumar on 14/09/26.
//

import SwiftUI

extension Font {
    enum GeistWeight {
        case regular, medium, semibold, bold

        var postScriptName: String {
            switch self {
            case .regular: return "Geist-Regular"
            case .medium: return "Geist-Medium"
            case .semibold: return "Geist-SemiBold"
            case .bold: return "Geist-Bold"
            }
        }
    }

    static func geist(_ size: CGFloat, weight: GeistWeight = .regular) -> Font {
        .custom(weight.postScriptName, size: size)
    }

    static func geist(_ textStyle: Font.TextStyle, weight: GeistWeight = .regular) -> Font {
        .custom(weight.postScriptName, size: pointSize(for: textStyle), relativeTo: textStyle)
    }

    private static func pointSize(for textStyle: Font.TextStyle) -> CGFloat {
        switch textStyle {
        case .largeTitle: return 34
        case .title: return 28
        case .title2: return 22
        case .title3: return 20
        case .headline: return 17
        case .subheadline: return 15
        case .body: return 17
        case .callout: return 16
        case .footnote: return 13
        case .caption: return 12
        case .caption2: return 11
        @unknown default: return 17
        }
    }
}
