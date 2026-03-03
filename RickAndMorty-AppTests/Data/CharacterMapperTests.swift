//
//  CharacterMapperTests.swift
//  RickAndMorty-AppTests
//
//  Tests for CharacterMapper
//

import Testing
import Foundation
@testable import RickAndMorty_App

struct CharacterMapperTests {

    @MainActor
    @Test("Maps CharacterDTO to Character domain model")
    func testMapDTOToDomain() {
        let dto = CharacterDTO(
            id: 1,
            name: "Rick Sanchez",
            status: "Alive",
            species: "Human",
            type: "",
            gender: "Male",
            origin: LocationDTO(name: "Earth (C-137)", url: ""),
            location: LocationDTO(name: "Citadel of Ricks", url: ""),
            image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
            episode: ["episode1", "episode2"],
            url: "",
            created: "2017-11-04T18:48:46.250Z"
        )

        let character = CharacterMapper.toDomain(from: dto)

        #expect(character.id == 1)
        #expect(character.name == "Rick Sanchez")
        #expect(character.status == .alive)
        #expect(character.species == "Human")
        #expect(character.gender == "Male")
        #expect(character.originName == "Earth (C-137)")
        #expect(character.locationName == "Citadel of Ricks")
        #expect(character.imageURL == "https://rickandmortyapi.com/api/character/avatar/1.jpeg")
        #expect(character.episodeCount == 2)
    }

    @MainActor
    @Test("Maps array of DTOs to domain models")
    func testMapDTOArrayToDomain() {
        let dtos = [
            CharacterDTO(
                id: 1,
                name: "Rick Sanchez",
                status: "Alive",
                species: "Human",
                type: "",
                gender: "Male",
                origin: LocationDTO(name: "Earth (C-137)", url: ""),
                location: LocationDTO(name: "Citadel of Ricks", url: ""),
                image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
                episode: [],
                url: "",
                created: "2017-11-04T18:48:46.250Z"
            ),
            CharacterDTO(
                id: 2,
                name: "Morty Smith",
                status: "Alive",
                species: "Human",
                type: "",
                gender: "Male",
                origin: LocationDTO(name: "Earth (C-137)", url: ""),
                location: LocationDTO(name: "Earth", url: ""),
                image: "https://rickandmortyapi.com/api/character/avatar/2.jpeg",
                episode: [],
                url: "",
                created: "2017-11-04T18:48:46.250Z"
            )
        ]

        let characters = CharacterMapper.toDomain(from: dtos)

        #expect(characters.count == 2)
        #expect(characters[0].name == "Rick Sanchez")
        #expect(characters[1].name == "Morty Smith")
    }

    @MainActor
    @Test("Maps unknown status to .unknown enum")
    func testMapUnknownStatus() {
        let dto = CharacterDTO(
            id: 1,
            name: "Unknown Character",
            status: "Something Weird",
            species: "Alien",
            type: "",
            gender: "Unknown",
            origin: LocationDTO(name: "Unknown", url: ""),
            location: LocationDTO(name: "Unknown", url: ""),
            image: "",
            episode: [],
            url: "",
            created: "2017-11-04T18:48:46.250Z"
        )

        let character = CharacterMapper.toDomain(from: dto)

        #expect(character.status == .unknown)
    }

    @MainActor
    @Test("Maps InfoDTO to PaginationInfo")
    func testMapInfoDTOToPaginationInfo() {
        let infoDTO = InfoDTO(
            count: 826,
            pages: 42,
            next: "https://rickandmortyapi.com/api/character?page=2",
            prev: nil
        )

        let paginationInfo = CharacterMapper.toDomain(from: infoDTO)

        #expect(paginationInfo.totalCount == 826)
        #expect(paginationInfo.totalPages == 42)
        #expect(paginationInfo.nextPageURL == "https://rickandmortyapi.com/api/character?page=2")
        #expect(paginationInfo.previousPageURL == nil)
        #expect(paginationInfo.hasNextPage)
    }

    @MainActor
    @Test("Maps InfoDTO without next page")
    func testMapInfoDTOWithoutNextPage() {
        let infoDTO = InfoDTO(
            count: 826,
            pages: 42,
            next: nil,
            prev: "https://rickandmortyapi.com/api/character?page=41"
        )

        let paginationInfo = CharacterMapper.toDomain(from: infoDTO)

        #expect(!paginationInfo.hasNextPage)
        #expect(paginationInfo.previousPageURL != nil)
    }
}
