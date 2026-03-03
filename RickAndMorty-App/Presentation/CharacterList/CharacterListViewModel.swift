//
//  CharacterListViewModel.swift
//  RickAndMorty-App
//
//  ViewModel for Character List with UDF pattern
//

import Foundation
import Observation

// MARK: - UI State
enum CharacterListUIState: Equatable {
    case idle
    case loading
    case loaded
    case loadingMore
    case error(String)
    case empty

    static func == (lhs: CharacterListUIState, rhs: CharacterListUIState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle),
             (.loading, .loading),
             (.loaded, .loaded),
             (.loadingMore, .loadingMore),
             (.empty, .empty):
            return true
        case (.error(let lhsMsg), .error(let rhsMsg)):
            return lhsMsg == rhsMsg
        default:
            return false
        }
    }
}

// MARK: - Character List ViewModel
@Observable
@MainActor
final class CharacterListViewModel {

    // MARK: - Published State
    private(set) var uiState: CharacterListUIState = .idle
    private(set) var characters: [Character] = []
    private(set) var filteredCharacters: [Character] = []

    var searchQuery: String = "" {
        didSet {
            handleSearchQueryChange()
        }
    }

    // MARK: - Private Properties
    private let getCharactersUseCase: GetCharactersUseCase
    private var paginationInfo: PaginationInfo?
    private var searchTask: Task<Void, Never>?
    private var currentPage = 1
    private var isLoadingMore = false

    // MARK: - Initialization
    init(getCharactersUseCase: GetCharactersUseCase) {
        self.getCharactersUseCase = getCharactersUseCase
    }

    // MARK: - Public Actions
    func loadInitialCharacters() {
        guard uiState == .idle else { return }

        Task {
            await loadCharacters(isRefreshing: false)
        }
    }

    func refresh() async {
        currentPage = 1
        characters = []
        filteredCharacters = []
        paginationInfo = nil
        await loadCharacters(isRefreshing: true)
    }

    func loadMoreCharactersIfNeeded(currentCharacter: Character) {
        // Check if we're near the end of the list (5 items from the end)
        guard !isLoadingMore else { return }

        let displayedCharacters = searchQuery.isEmpty ? characters : filteredCharacters
        guard let index = displayedCharacters.firstIndex(where: { $0.id == currentCharacter.id }) else {
            return
        }

        let thresholdIndex = displayedCharacters.count - 5
        if index >= thresholdIndex && paginationInfo?.hasNextPage == true {
            Task {
                await loadMoreCharacters()
            }
        }
    }

    func retryLoad() {
        Task {
            await loadCharacters(isRefreshing: false)
        }
    }

    // MARK: - Private Methods
    private func handleSearchQueryChange() {
        // Cancel previous search task
        searchTask?.cancel()

        // If search query is empty, show all characters
        if searchQuery.isEmpty {
            filteredCharacters = characters
        }

        // Apply debounce of 400ms
        searchTask = Task {
            try? await Task.sleep(for: .milliseconds(400))

            // Check if task was cancelled
            guard !Task.isCancelled else { return }

            await performSearch()
        }
    }

    private func performSearch() async {
        // Reset state for new search
        currentPage = 1
        characters = []
        filteredCharacters = []
        paginationInfo = nil
        uiState = .loading

        do {
            let result = try await getCharactersUseCase.execute(
                page: currentPage,
                searchQuery: searchQuery.isEmpty ? nil : searchQuery
            )

            characters = result.characters
            filteredCharacters = result.characters
            paginationInfo = result.paginationInfo

            if characters.isEmpty {
                uiState = .empty
            } else {
                uiState = .loaded
            }

        } catch {
            handleError(error)
        }
    }

    private func loadCharacters(isRefreshing: Bool) async {
        if !isRefreshing {
            uiState = .loading
        }

        do {
            let result = try await getCharactersUseCase.execute(
                page: currentPage,
                searchQuery: nil
            )

            characters = result.characters
            filteredCharacters = result.characters
            paginationInfo = result.paginationInfo

            if characters.isEmpty {
                uiState = .empty
            } else {
                uiState = .loaded
            }

        } catch {
            handleError(error)
        }
    }

    private func loadMoreCharacters() async {
        guard let nextPageURL = paginationInfo?.nextPageURL,
              !isLoadingMore,
              uiState != .loadingMore else {
            return
        }

        isLoadingMore = true
        uiState = .loadingMore

        do {
            let result = try await getCharactersUseCase.executeByURL(nextPageURL)

            characters.append(contentsOf: result.characters)

            if searchQuery.isEmpty {
                filteredCharacters = characters
            }

            paginationInfo = result.paginationInfo
            currentPage += 1
            uiState = .loaded

        } catch {
            // Don't show error for pagination failures, just stop loading
            uiState = .loaded
        }

        isLoadingMore = false
    }

    private func handleError(_ error: Error) {
        let errorMessage: String

        if let networkError = error as? NetworkError {
            errorMessage = networkError.localizedDescription
        } else {
            errorMessage = "Error inesperado: \(error.localizedDescription)"
        }

        // If we have cached data, show it instead of error
        if !characters.isEmpty {
            uiState = .loaded
        } else {
            uiState = .error(errorMessage)
        }
    }
}
