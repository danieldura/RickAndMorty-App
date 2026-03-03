//
//  APIClient.swift
//  RickAndMorty-App
//
//

import Foundation

// MARK: - API Client Protocol
protocol APIClientProtocol: Sendable {
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T
}

// MARK: - Endpoint
enum Endpoint {
    case characters(page: Int)
    case character(name: String)
    case charactersByURL(String)

    var url: URL? {
        switch self {
        case .characters(let page):
            var components = URLComponents(string: "https://rickandmortyapi.com/api/character")
            let queryItems = [URLQueryItem(name: "page", value: "\(page)")]

            components?.queryItems = queryItems
            return components?.url

        case .character(name: let name):
            var components = URLComponents(string: "https://rickandmortyapi.com/api/character")
            let queryItems = [URLQueryItem(name: "name", value: name)]

            components?.queryItems = queryItems
            return components?.url
        case .charactersByURL(let urlString):
            return URL(string: urlString)
        }
    }
}

// MARK: - API Client Implementation
final class APIClient: APIClientProtocol {
    private let session: URLSession
    private let decoder: JSONDecoder

    init(session: URLSession = .shared) {
        self.session = session
        self.decoder = JSONDecoder()
    }

    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        guard let url = endpoint.url else {
            throw NetworkError.invalidURL
        }

        let request = URLRequest(url: url)

        do {
            let (data, response) = try await session.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                throw NetworkError.httpError(statusCode: httpResponse.statusCode)
            }

            do {
                let decodedData = try decoder.decode(T.self, from: data)
                return decodedData
            } catch {
                throw NetworkError.decodingError
            }

        } catch let error as NetworkError {
            throw error
        } catch {
            throw NetworkError.networkFailure(error)
        }
    }
}
