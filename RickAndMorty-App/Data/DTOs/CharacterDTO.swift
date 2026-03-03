//
//  CharacterDTO.swift
//  RickAndMorty-App
//
//

import Foundation

// MARK: - Character Response DTO
struct CharacterResponseDTO: Codable {
    let info: InfoDTO
    let results: [CharacterDTO]
}

// MARK: - Info DTO
struct InfoDTO: Codable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
}

// MARK: - Character DTO
struct CharacterDTO: Codable, Identifiable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let type: String
    let gender: String
    let origin: LocationDTO
    let location: LocationDTO
    let image: String
    let episode: [String]
    let url: String
    let created: String
}

// MARK: - Location DTO
struct LocationDTO: Codable {
    let name: String
    let url: String
}
