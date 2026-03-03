//
//  Character.swift
//  RickAndMorty-App
//
//

import Foundation

// MARK: - Character Status Enum
enum CharacterStatus: String, Codable {
    case alive = "Alive"
    case dead = "Dead"
    case unknown = "unknown"

    var displayText: String {
        switch self {
        case .alive: return "Vivo"
        case .dead: return "Muerto"
        case .unknown: return "Desconocido"
        }
    }

    var color: String {
        switch self {
        case .alive: return "green"
        case .dead: return "red"
        case .unknown: return "gray"
        }
    }
}

// MARK: - Character Domain Model
struct Character: Identifiable, Hashable {
    let id: Int
    let name: String
    let status: CharacterStatus
    let species: String
    let type: String
    let gender: String
    let originName: String
    let locationName: String
    let imageURL: String
    let episodeCount: Int
    let created: Date

    // Hashable conformance
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Character, rhs: Character) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Pagination Info
struct PaginationInfo {
    let totalCount: Int
    let totalPages: Int
    let nextPageURL: String?
    let previousPageURL: String?

    var hasNextPage: Bool {
        nextPageURL != nil
    }
}
