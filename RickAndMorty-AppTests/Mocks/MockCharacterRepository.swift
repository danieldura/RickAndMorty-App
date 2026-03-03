//
//  MockCharacterRepository.swift
//  RickAndMorty-AppTests
//
//  Mock repository for testing
//

import Foundation
@testable import RickAndMorty_App

final class MockCharacterRepository: CharacterRepositoryProtocol, @unchecked Sendable {

    // Test configuration
    var shouldReturnError = false
    var errorToReturn: Error = NetworkError.networkFailure(NSError(domain: "test", code: -1))
    var charactersToReturn: [Character] = []
    var paginationInfoToReturn: PaginationInfo?
    var getCharactersCalled = false
    var getCharactersByURLCalled = false
    var getCachedCharactersCalled = false
    var clearCacheCalled = false

    func getCharacters(page: Int, searchQuery: String?) async throws -> (characters: [Character], paginationInfo: PaginationInfo) {
        getCharactersCalled = true

        if shouldReturnError {
            throw errorToReturn
        }

        let pagination = paginationInfoToReturn ?? PaginationInfo(
            totalCount: charactersToReturn.count,
            totalPages: 1,
            nextPageURL: nil,
            previousPageURL: nil
        )

        return (charactersToReturn, pagination)
    }

    func getCharactersByURL(_ url: String) async throws -> (characters: [Character], paginationInfo: PaginationInfo) {
        getCharactersByURLCalled = true

        if shouldReturnError {
            throw errorToReturn
        }

        let pagination = paginationInfoToReturn ?? PaginationInfo(
            totalCount: charactersToReturn.count,
            totalPages: 1,
            nextPageURL: nil,
            previousPageURL: nil
        )

        return (charactersToReturn, pagination)
    }

    func getCachedCharacters() async throws -> [Character] {
        getCachedCharactersCalled = true

        if shouldReturnError {
            throw errorToReturn
        }

        return charactersToReturn
    }

    func clearCache() async throws {
        clearCacheCalled = true

        if shouldReturnError {
            throw errorToReturn
        }
    }
}
