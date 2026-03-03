//
//  CharacterRepository.swift
//  RickAndMorty-App
//
//  Repository implementation with offline-first strategy
//

import Foundation
import SwiftData

// MARK: - Character Repository
final class CharacterRepository: CharacterRepositoryProtocol {
    private let apiClient: APIClientProtocol
    private let modelContext: ModelContext

    init(apiClient: APIClientProtocol, modelContext: ModelContext) {
        self.apiClient = apiClient
        self.modelContext = modelContext
    }

    // MARK: - Get Characters with Cache Strategy
    // Strategy: Return cached data first, then fetch from API and update cache
    func getCharacters(page: Int, searchQuery: String?) async throws -> (characters: [Character], paginationInfo: PaginationInfo) {
        do {

            var response: CharacterResponseDTO
            if let searchQuery {
                response = try await apiClient.request(.character(name: searchQuery))
            } else {
                response = try await apiClient.request(.characters(page: page))
            }

            let characters = CharacterMapper.toDomain(from: response.results)
            let paginationInfo = CharacterMapper.toDomain(from: response.info)

            // Cache the results only for first page without search
            if page == 1 && searchQuery == nil {
                await cacheCharacters(characters)
            }

            return (characters, paginationInfo)

        } catch {
            // If network fails and it's the first page without search, return cached data
            if page == 1 && searchQuery == nil {
                let cachedCharacters = try await getCachedCharacters()
                if !cachedCharacters.isEmpty {
                    let emptyPaginationInfo = PaginationInfo(
                        totalCount: cachedCharacters.count,
                        totalPages: 1,
                        nextPageURL: nil,
                        previousPageURL: nil
                    )
                    return (cachedCharacters, emptyPaginationInfo)
                }
            }
            throw error
        }
    }

    // MARK: - Get Characters by URL
    func getCharactersByURL(_ url: String) async throws -> (characters: [Character], paginationInfo: PaginationInfo) {
        let response: CharacterResponseDTO = try await apiClient.request(.charactersByURL(url))

        let characters = CharacterMapper.toDomain(from: response.results)
        let paginationInfo = CharacterMapper.toDomain(from: response.info)

        return (characters, paginationInfo)
    }

    // MARK: - Get Cached Characters
    func getCachedCharacters() async throws -> [Character] {
        let descriptor = FetchDescriptor<CharacterEntity>(
            sortBy: [SortDescriptor(\.lastUpdated, order: .reverse)]
        )

        let entities = try modelContext.fetch(descriptor)
        return entities.map { $0.toDomain() }
    }

    // MARK: - Cache Characters
    private func cacheCharacters(_ characters: [Character]) async {
        // Clear old cache first
        do {
            try await clearCache()
        } catch {
            print("Error clearing cache: \(error)")
        }

        // Insert new characters
        for character in characters {
            let entity = CharacterEntity.from(character: character)
            modelContext.insert(entity)
        }

        do {
            try modelContext.save()
        } catch {
            print("Error saving to cache: \(error)")
        }
    }

    // MARK: - Clear Cache
    func clearCache() async throws {
        try modelContext.delete(model: CharacterEntity.self)
        try modelContext.save()
    }
}
