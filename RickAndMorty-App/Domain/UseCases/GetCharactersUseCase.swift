//
//  GetCharactersUseCase.swift
//  RickAndMorty-App
//
//  Use case for fetching characters
//

import Foundation

// MARK: - Get Characters Use Case
final class GetCharactersUseCase {
    private let repository: CharacterRepositoryProtocol

    init(repository: CharacterRepositoryProtocol) {
        self.repository = repository
    }

    func execute(page: Int = 1, searchQuery: String? = nil) async throws -> (characters: [Character], paginationInfo: PaginationInfo) {
        try await repository.getCharacters(page: page, searchQuery: searchQuery)
    }

    func executeByURL(_ url: String) async throws -> (characters: [Character], paginationInfo: PaginationInfo) {
        try await repository.getCharactersByURL(url)
    }
}
