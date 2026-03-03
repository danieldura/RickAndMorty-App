//
//  CharacterListView.swift
//  RickAndMorty-App
//
//  Main view for character list with search and pagination
//

import SwiftUI

struct CharacterListView: View {
    @State private var viewModel: CharacterListViewModel
    @State private var selectedCharacter: Character?

    init(viewModel: CharacterListViewModel) {
        self._viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            Group {
                switch viewModel.uiState {
                case .idle, .loading:
                    LoadingView()

                case .loaded, .loadingMore:
                    characterListContent

                case .error(let message):
                    ErrorView(message: message) {
                        viewModel.retryLoad()
                    }

                case .empty:
                    EmptyStateView(searchQuery: viewModel.searchQuery)
                }
            }
            .navigationTitle("Rick & Morty")
            .searchable(
                text: $viewModel.searchQuery,
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: "Buscar personajes..."
            )
            .refreshable {
                await viewModel.refresh()
            }
            .onAppear {
                viewModel.loadInitialCharacters()
            }
        }
    }

    // MARK: - Character List Content
    @ViewBuilder
    private var characterListContent: some View {
        List {
            ForEach(displayedCharacters) { character in
                Button {
                    selectedCharacter = character
                } label: {
                    CharacterRowView(
                        character: character
                    )
                }
                .buttonStyle(.plain)
                .onAppear {
                    // Load more when approaching the end
                    viewModel.loadMoreCharactersIfNeeded(currentCharacter: character)
                }
            }

            // Loading more indicator at the bottom
            if viewModel.uiState == .loadingMore {
                HStack {
                    Spacer()
                    ProgressView()
                        .tint(.green)
                    Text("Cargando más...")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Spacer()
                }
                .padding(.vertical, 8)
                .listRowSeparator(.hidden)
                .accessibilityLabel("Cargando más personajes")
            }
        }
        .listStyle(.plain)
        .sheet(item: $selectedCharacter) { character in
            CharacterDetailView(
                character: character
            )
        }
    }

    // MARK: - Computed Properties
    private var displayedCharacters: [Character] {
        viewModel.searchQuery.isEmpty ? viewModel.characters : viewModel.filteredCharacters
    }
}

#Preview("Loaded State") {
    let mockRepository = MockCharacterRepository()
    let mockUseCase = GetCharactersUseCase(repository: mockRepository)
    let viewModel = CharacterListViewModel(getCharactersUseCase: mockUseCase)

    CharacterListView(viewModel: viewModel)
}

private final class MockCharacterRepository: CharacterRepositoryProtocol {
    func getCharacters(page: Int, searchQuery: String?) async throws -> (characters: [Character], paginationInfo: PaginationInfo) {
        let mockCharacters = [
            Character(
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
            ),
            Character(
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
        ]

        let paginationInfo = PaginationInfo(
            totalCount: 2,
            totalPages: 1,
            nextPageURL: nil,
            previousPageURL: nil
        )

        return (mockCharacters, paginationInfo)
    }

    func getCharactersByURL(_ url: String) async throws -> (characters: [Character], paginationInfo: PaginationInfo) {
        try await getCharacters(page: 1, searchQuery: nil)
    }

    func getCachedCharacters() async throws -> [Character] {
        []
    }

    func clearCache() async throws {
        // No-op for mock
    }
}
