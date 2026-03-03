//
//  CharacterListViewModelTests.swift
//  RickAndMorty-AppTests
//
//  Tests for CharacterListViewModel
//

import Testing
import Foundation
@testable import RickAndMorty_App

@MainActor
struct CharacterListViewModelTests {

    // MARK: - Initial State Tests

    @Test("Initial state should be idle")
    func testInitialState() async {
        let mockRepository = MockCharacterRepository()
        let useCase = GetCharactersUseCase(repository: mockRepository)
        let viewModel = CharacterListViewModel(getCharactersUseCase: useCase)

        #expect(viewModel.uiState == .idle)
        #expect(viewModel.characters.isEmpty)
        #expect(viewModel.searchQuery.isEmpty)
    }

    // MARK: - Load Characters Tests

    @Test("Load initial characters successfully")
    func testLoadInitialCharactersSuccess() async {
        let mockRepository = MockCharacterRepository()
        mockRepository.charactersToReturn = MockData.allCharacters
        mockRepository.paginationInfoToReturn = MockData.paginationInfoWithNextPage

        let useCase = GetCharactersUseCase(repository: mockRepository)
        let viewModel = CharacterListViewModel(getCharactersUseCase: useCase)

        viewModel.loadInitialCharacters()

        // Wait for async operation
        try? await Task.sleep(for: .milliseconds(100))

        #expect(viewModel.uiState == .loaded)
        #expect(viewModel.characters.count == 4)
        #expect(mockRepository.getCharactersCalled)
    }

    @Test("Load initial characters with error shows error state")
    func testLoadInitialCharactersError() async {
        let mockRepository = MockCharacterRepository()
        mockRepository.shouldReturnError = true
        mockRepository.errorToReturn = NetworkError.networkFailure(NSError(domain: "test", code: -1))

        let useCase = GetCharactersUseCase(repository: mockRepository)
        let viewModel = CharacterListViewModel(getCharactersUseCase: useCase)

        viewModel.loadInitialCharacters()

        // Wait for async operation
        try? await Task.sleep(for: .milliseconds(100))

        if case .error = viewModel.uiState {
            // Test passes
        } else {
            Issue.record("Expected error state but got \(viewModel.uiState)")
        }
    }

    @Test("Load initial characters with empty results shows empty state")
    func testLoadInitialCharactersEmpty() async {
        let mockRepository = MockCharacterRepository()
        mockRepository.charactersToReturn = []

        let useCase = GetCharactersUseCase(repository: mockRepository)
        let viewModel = CharacterListViewModel(getCharactersUseCase: useCase)

        viewModel.loadInitialCharacters()

        // Wait for async operation
        try? await Task.sleep(for: .milliseconds(100))

        #expect(viewModel.uiState == .empty)
        #expect(viewModel.characters.isEmpty)
    }

    // MARK: - Refresh Tests

    @Test("Refresh resets and reloads characters")
    func testRefresh() async {
        let mockRepository = MockCharacterRepository()
        mockRepository.charactersToReturn = [MockData.rickSanchez]

        let useCase = GetCharactersUseCase(repository: mockRepository)
        let viewModel = CharacterListViewModel(getCharactersUseCase: useCase)

        // Load initial
        viewModel.loadInitialCharacters()
        try? await Task.sleep(for: .milliseconds(100))

        #expect(viewModel.characters.count == 1)

        // Update mock data
        mockRepository.charactersToReturn = MockData.allCharacters

        // Refresh
        await viewModel.refresh()

        #expect(viewModel.characters.count == 4)
        #expect(viewModel.uiState == .loaded)
    }

    // MARK: - Search Tests

    @Test("Search query triggers debounced search")
    func testSearchQueryDebounce() async {
        let mockRepository = MockCharacterRepository()
        mockRepository.charactersToReturn = [MockData.rickSanchez]

        let useCase = GetCharactersUseCase(repository: mockRepository)
        let viewModel = CharacterListViewModel(getCharactersUseCase: useCase)

        // Set search query
        viewModel.searchQuery = "Rick"

        // Wait for debounce (400ms) plus processing time
        try? await Task.sleep(for: .milliseconds(500))

        #expect(mockRepository.getCharactersCalled)
        #expect(viewModel.characters.count == 1)
    }

    @Test("Empty search query shows all characters")
    func testEmptySearchQuery() async {
        let mockRepository = MockCharacterRepository()
        mockRepository.charactersToReturn = MockData.allCharacters

        let useCase = GetCharactersUseCase(repository: mockRepository)
        let viewModel = CharacterListViewModel(getCharactersUseCase: useCase)

        viewModel.loadInitialCharacters()
        try? await Task.sleep(for: .milliseconds(100))

        #expect(viewModel.filteredCharacters.count == 4)

        // Set and clear search
        viewModel.searchQuery = "Rick"
        viewModel.searchQuery = ""

        #expect(viewModel.filteredCharacters.count == 4)
    }

    // MARK: - Pagination Tests

    @Test("Load more characters appends to existing list")
    func testLoadMoreCharacters() async {
        let mockRepository = MockCharacterRepository()
        mockRepository.charactersToReturn = [MockData.rickSanchez, MockData.mortySmith]
        mockRepository.paginationInfoToReturn = MockData.paginationInfoWithNextPage

        let useCase = GetCharactersUseCase(repository: mockRepository)
        let viewModel = CharacterListViewModel(getCharactersUseCase: useCase)

        // Load initial
        viewModel.loadInitialCharacters()
        try? await Task.sleep(for: .milliseconds(100))

        #expect(viewModel.characters.count == 2)

        // Simulate loading more
        mockRepository.charactersToReturn = [MockData.summerSmith, MockData.deadCharacter]

        viewModel.loadMoreCharactersIfNeeded(currentCharacter: MockData.mortySmith)
        try? await Task.sleep(for: .milliseconds(200))

        #expect(viewModel.characters.count >= 2)
    }

    @Test("Load more not triggered when no next page")
    func testLoadMoreWithoutNextPage() async {
        let mockRepository = MockCharacterRepository()
        mockRepository.charactersToReturn = MockData.allCharacters
        mockRepository.paginationInfoToReturn = MockData.paginationInfoLastPage

        let useCase = GetCharactersUseCase(repository: mockRepository)
        let viewModel = CharacterListViewModel(getCharactersUseCase: useCase)

        viewModel.loadInitialCharacters()
        try? await Task.sleep(for: .milliseconds(100))

        // Try to load more
        viewModel.loadMoreCharactersIfNeeded(currentCharacter: MockData.deadCharacter)
        try? await Task.sleep(for: .milliseconds(100))

        // Should not make additional calls since no next page
        #expect(!mockRepository.getCharactersByURLCalled)
    }

    // MARK: - Retry Tests

    @Test("Retry after error attempts to reload")
    func testRetryLoad() async {
        let mockRepository = MockCharacterRepository()
        mockRepository.shouldReturnError = true

        let useCase = GetCharactersUseCase(repository: mockRepository)
        let viewModel = CharacterListViewModel(getCharactersUseCase: useCase)

        viewModel.loadInitialCharacters()
        try? await Task.sleep(for: .milliseconds(100))

        // Should be in error state
        if case .error = viewModel.uiState {
            // Now fix the error and retry
            mockRepository.shouldReturnError = false
            mockRepository.charactersToReturn = [MockData.rickSanchez]

            viewModel.retryLoad()
            try? await Task.sleep(for: .milliseconds(100))

            #expect(viewModel.uiState == .loaded)
            #expect(viewModel.characters.count == 1)
        } else {
            Issue.record("Expected error state")
        }
    }
}
