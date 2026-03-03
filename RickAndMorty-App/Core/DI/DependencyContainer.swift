//
//  DependencyContainer.swift
//  RickAndMorty-App
//
//

import Foundation
import SwiftUI
import SwiftData

// MARK: - Dependency Container
struct DependencyContainer {
    let getCharactersUseCase: GetCharactersUseCase

    static func make(modelContext: ModelContext) -> DependencyContainer {
        // Build dependency graph
        let apiClient: APIClientProtocol = APIClient()
        let repository: CharacterRepositoryProtocol = CharacterRepository(
            apiClient: apiClient,
            modelContext: modelContext
        )
        let getCharactersUseCase = GetCharactersUseCase(repository: repository)

        return DependencyContainer(getCharactersUseCase: getCharactersUseCase)
    }
}

// MARK: - Environment Key
private struct DependencyContainerKey: EnvironmentKey {
    static let defaultValue: DependencyContainer? = nil
}

extension EnvironmentValues {
    var dependencies: DependencyContainer? {
        get { self[DependencyContainerKey.self] }
        set { self[DependencyContainerKey.self] = newValue }
    }
}
