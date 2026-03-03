//
//  GetCharactersUseCaseTests.swift
//  RickAndMorty-AppTests
//
//  Tests for GetCharactersUseCase
//

import Testing
import Foundation
@testable import RickAndMorty_App

struct GetCharactersUseCaseTests {

    @MainActor
    @Test("Execute returns characters from repository")
    func testExecuteSuccess() async throws {
        let mockRepository = MockCharacterRepository()
        mockRepository.charactersToReturn = MockData.allCharacters
        mockRepository.paginationInfoToReturn = MockData.paginationInfoWithNextPage

        let useCase = GetCharactersUseCase(repository: mockRepository)

        let result = try await useCase.execute(page: 1, searchQuery: nil)

        #expect(result.characters.count == 4)
        #expect(result.paginationInfo.hasNextPage)
        #expect(mockRepository.getCharactersCalled)
    }

    @MainActor
    @Test("Execute with search query passes query to repository")
    func testExecuteWithSearchQuery() async throws {
        let mockRepository = MockCharacterRepository()
        mockRepository.charactersToReturn = [MockData.rickSanchez]

        let useCase = GetCharactersUseCase(repository: mockRepository)

        let result = try await useCase.execute(page: 1, searchQuery: "Rick")

        #expect(result.characters.count == 1)
        #expect(result.characters.first?.name == "Rick Sanchez")
    }

    @Test("Execute by URL returns characters")
    func testExecuteByURL() async throws {
        let mockRepository = MockCharacterRepository()
        mockRepository.charactersToReturn = [MockData.summerSmith]

        let useCase = await GetCharactersUseCase(repository: mockRepository)

        let result = try await useCase.executeByURL("https://rickandmortyapi.com/api/character?page=2")

        #expect(result.characters.count == 1)
        #expect(mockRepository.getCharactersByURLCalled)
    }

    @Test("Execute throws error when repository fails")
    func testExecuteThrowsError() async {
        let mockRepository = MockCharacterRepository()
        mockRepository.shouldReturnError = true
        mockRepository.errorToReturn = NetworkError.networkFailure(NSError(domain: "test", code: -1))

        let useCase = await GetCharactersUseCase(repository: mockRepository)

        do {
            _ = try await useCase.execute(page: 1, searchQuery: nil)
            Issue.record("Expected error to be thrown")
        } catch {
            // Expected error
            #expect(error is NetworkError)
        }
    }
}
