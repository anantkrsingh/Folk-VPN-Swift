//
//  APIClient.swift
//  Folk VPN
//
//  Created by Anant Kumar on 14/09/26.
//

import Foundation

enum APIError: Error, LocalizedError {
    case transport(Error)
    case decoding(Error)
    case invalidResponse(status: Int)

    var errorDescription: String? {
        switch self {
        case .transport(let error): return error.localizedDescription
        case .decoding(let error): return "Decoding failed: \(error.localizedDescription)"
        case .invalidResponse(let status): return "Unexpected server response (\(status))"
        }
    }
}

final class APIClient {
    static let shared = APIClient()

    private let baseURL = URL(string: "https://api-folk.anantkr.com/api")!
    private let session: URLSession
    private let decoder: JSONDecoder

    init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 20
        config.waitsForConnectivity = true
        self.session = URLSession(configuration: config)

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        self.decoder = decoder
    }

    func get<T: Decodable>(_ path: String, as type: T.Type = T.self) async throws -> T {
        let url = baseURL.appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await session.data(for: request)
        } catch {
            throw APIError.transport(error)
        }

        if let http = response as? HTTPURLResponse, !(200..<300).contains(http.statusCode) {
            throw APIError.invalidResponse(status: http.statusCode)
        }

        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw APIError.decoding(error)
        }
    }
}
