//
//  CharacterEntity.swift
//  RickAndMorty-App
//
//

import Foundation
import SwiftData

// MARK: - Character Entity (SwiftData)
@Model
final class CharacterEntity {
    @Attribute(.unique) var id: Int
    var name: String
    var status: String
    var species: String
    var type: String
    var gender: String
    var originName: String
    var locationName: String
    var imageURL: String
    var episodeCount: Int
    var created: Date
    var lastUpdated: Date

    init(
        id: Int,
        name: String,
        status: String,
        species: String,
        type: String,
        gender: String,
        originName: String,
        locationName: String,
        imageURL: String,
        episodeCount: Int,
        created: Date,
        lastUpdated: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.status = status
        self.species = species
        self.type = type
        self.gender = gender
        self.originName = originName
        self.locationName = locationName
        self.imageURL = imageURL
        self.episodeCount = episodeCount
        self.created = created
        self.lastUpdated = lastUpdated
    }
}

// MARK: - Character Entity Mapper
extension CharacterEntity {

    // Convert Domain Model to Entity
    static func from(character: Character) -> CharacterEntity {
        CharacterEntity(
            id: character.id,
            name: character.name,
            status: character.status.rawValue,
            species: character.species,
            type: character.type,
            gender: character.gender,
            originName: character.originName,
            locationName: character.locationName,
            imageURL: character.imageURL,
            episodeCount: character.episodeCount,
            created: character.created
        )
    }

    // Convert Entity to Domain Model
    func toDomain() -> Character {
        let status = CharacterStatus(rawValue: self.status) ?? .unknown

        return Character(
            id: self.id,
            name: self.name,
            status: status,
            species: self.species,
            type: self.type,
            gender: self.gender,
            originName: self.originName,
            locationName: self.locationName,
            imageURL: self.imageURL,
            episodeCount: self.episodeCount,
            created: self.created
        )
    }
}
