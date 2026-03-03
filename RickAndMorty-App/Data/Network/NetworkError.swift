//
//  NetworkError.swift
//  RickAndMorty-App
//
//

import Foundation

// MARK: - Network Error
enum NetworkError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case httpError(statusCode: Int)
    case decodingError
    case noData
    case networkFailure(Error)
    case serverError

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "La URL proporcionada no es válida"
        case .invalidResponse:
            return "La respuesta del servidor no es válida"
        case .httpError(let statusCode):
            return "Error HTTP: \(statusCode)"
        case .decodingError:
            return "Error al decodificar los datos"
        case .noData:
            return "No se recibieron datos del servidor"
        case .networkFailure(let error):
            return "Error de red: \(error.localizedDescription)"
        case .serverError:
            return "Error del servidor"
        }
    }
}
