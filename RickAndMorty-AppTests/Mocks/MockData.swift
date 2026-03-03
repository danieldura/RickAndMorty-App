//
//  MockData.swift
//  RickAndMorty-AppTests
//
//  Mock data for testing
//

import Foundation
@testable import RickAndMorty_App

enum MockData {

    static let rickSanchez = Character(
        id: 1,
        name: "Rick Sanchez",
        status: .alive,
        species: "Human",
        type: "",
        gender: "Male",
        originName: "Earth (C-137)",
        locationName: "Citadel of Ricks",
        imageURL: "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
        episodeCount: 51,
        created: Date()
    )

    static let mortySmith = Character(
        id: 2,
        name: "Morty Smith",
        status: .alive,
        species: "Human",
        type: "",
        gender: "Male",
        originName: "Earth (C-137)",
        locationName: "Earth",
        imageURL: "https://rickandmortyapi.com/api/character/avatar/2.jpeg",
        episodeCount: 51,
        created: Date()
    )

    static let summerSmith = Character(
        id: 3,
        name: "Summer Smith",
        status: .alive,
        species: "Human",
        type: "",
        gender: "Female",
        originName: "Earth (C-137)",
        locationName: "Earth",
        imageURL: "https://rickandmortyapi.com/api/character/avatar/3.jpeg",
        episodeCount: 42,
        created: Date()
    )

    static let deadCharacter = Character(
        id: 4,
        name: "Dead Character",
        status: .dead,
        species: "Human",
        type: "",
        gender: "Male",
        originName: "Earth",
        locationName: "Earth",
        imageURL: "https://rickandmortyapi.com/api/character/avatar/4.jpeg",
        episodeCount: 5,
        created: Date()
    )

    static let allCharacters = [rickSanchez, mortySmith, summerSmith, deadCharacter]

    static let paginationInfoWithNextPage = PaginationInfo(
        totalCount: 826,
        totalPages: 42,
        nextPageURL: "https://rickandmortyapi.com/api/character?page=2",
        previousPageURL: nil
    )

    static let paginationInfoLastPage = PaginationInfo(
        totalCount: 826,
        totalPages: 42,
        nextPageURL: nil,
        previousPageURL: "https://rickandmortyapi.com/api/character?page=41"
    )
}
