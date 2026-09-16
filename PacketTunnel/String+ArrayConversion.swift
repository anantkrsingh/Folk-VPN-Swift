// SPDX-License-Identifier: MIT
// Copyright © 2018-2023 WireGuard LLC. All Rights Reserved.
//
// Vendored from amneziawg-apple's Sources/Shared/Model — that target isn't part of the
// WireGuardKit SPM product, so TunnelConfiguration+WgQuickConfig.swift's dependency on
// this helper needs its own copy here.

import Foundation

extension String {

    func splitToArray(separator: Character = ",", trimmingCharacters: CharacterSet? = nil) -> [String] {
        return split(separator: separator)
            .map {
                if let charSet = trimmingCharacters {
                    return $0.trimmingCharacters(in: charSet)
                } else {
                    return String($0)
                }
        }
    }

}

extension Optional where Wrapped == String {

    func splitToArray(separator: Character = ",", trimmingCharacters: CharacterSet? = nil) -> [String] {
        switch self {
        case .none:
            return []
        case .some(let wrapped):
            return wrapped.splitToArray(separator: separator, trimmingCharacters: trimmingCharacters)
        }
    }

}
