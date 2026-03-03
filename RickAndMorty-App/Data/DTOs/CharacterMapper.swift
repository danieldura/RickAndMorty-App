//
//  CharacterMapper.swift
//  RickAndMorty-App
//
//

import Foundation

// MARK: - Character Mapper
struct CharacterMapper {

    // Convert DTO to Domain Model
    static func toDomain(from dto: CharacterDTO) -> Character {
        let status = CharacterStatus(rawValue: dto.status) ?? .unknown

        // Parse created date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        let createdDate = dateFormatter.date(from: dto.created) ?? Date()

        return Character(
            id: dto.id,
            name: dto.name,
            status: status,
            species: dto.species,
            type: dto.type,
            gender: dto.gender,
            originName: dto.origin.name,
            locationName: dto.location.name,
            imageURL: dto.image,
            episodeCount: dto.episode.count,
            created: createdDate
        )
    }

    // Convert array of DTOs to Domain Models
    static func toDomain(from dtos: [CharacterDTO]) -> [Character] {
        dtos.map { toDomain(from: $0) }
    }

    // Convert Info DTO to PaginationInfo
    static func toDomain(from dto: InfoDTO) -> PaginationInfo {
        PaginationInfo(
            totalCount: dto.count,
            totalPages: dto.pages,
            nextPageURL: dto.next,
            previousPageURL: dto.prev
        )
    }
}
