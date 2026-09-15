//
//  VPNConnectionState.swift
//  Folk VPN
//
//  Created by Anant Kumar on 14/09/26.
//

import Foundation

enum VPNConnectionState: Equatable {
    case disconnected
    case connecting
    case connected(since: Date)
    case disconnecting
    case failed(message: String)
}
