//
//  FontRegistrar.swift
//  Folk VPN
//
//  Created by Anant Kumar on 14/09/26.
//

import Foundation
import CoreText

enum FontRegistrar {
    static func registerGeist() {
        let names = ["Geist-Regular", "Geist-Medium", "Geist-SemiBold", "Geist-Bold"]
        for name in names {
            guard let url = Bundle.main.url(forResource: name, withExtension: "ttf") else { continue }
            CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
        }
    }
}
