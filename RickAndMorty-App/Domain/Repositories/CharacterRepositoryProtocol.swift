//
//  CharacterRepositoryProtocol.swift
//  RickAndMorty-App
//
//  Repository protocol for Domain layer
//

import Foundation

// MARK: - Character Repository Protocol
protocol CharacterRepositoryProtocol: Sendable {
    func getCharacters(page: Int, searchQuery: String?) async throws -> (characters: [Character], paginationInfo: PaginationInfo)
    func getCharactersByURL(_ url: String) async throws -> (characters: [Character], paginationInfo: PaginationInfo)
    func getCachedCharacters() async throws -> [Character]
    func clearCache() async throws
}
