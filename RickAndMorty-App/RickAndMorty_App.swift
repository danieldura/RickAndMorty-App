//
//  RickAndMorty_App.swift
//  RickAndMorty-App
//
//  Created by Daniel Dura on 2/3/26.
//

import SwiftUI
import SwiftData
import Kingfisher

@main
struct RickAndMortyApp: App {

    // SwiftData model container
    let modelContainer: ModelContainer

    init() {
        Self.configureKingfisher()
        do {
            // Configure SwiftData with CharacterEntity
            let schema = Schema([CharacterEntity.self])
            let modelConfiguration = ModelConfiguration(
                schema: schema,
                isStoredInMemoryOnly: false
            )
            modelContainer = try ModelContainer(
                for: schema,
                configurations: [modelConfiguration]
            )
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(modelContainer)
        }
    }

    private static func configureKingfisher() {
        let config = URLSessionConfiguration.default
        config.httpMaximumConnectionsPerHost = 2
        KingfisherManager.shared.downloader.sessionConfiguration = config
        KingfisherManager.shared.downloader.downloadTimeout = 15
    }
}

// MARK: - Content View
struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var dependencies: DependencyContainer?

    var body: some View {
        Group {
            if let dependencies {
                CharacterListView(
                    viewModel: CharacterListViewModel(
                        getCharactersUseCase: dependencies.getCharactersUseCase
                    )
                )
            } else {
                ProgressView("Inicializando...")
            }
        }
        .onAppear {
            if dependencies == nil {
                dependencies = DependencyContainer.make(modelContext: modelContext)
            }
        }
    }
}
