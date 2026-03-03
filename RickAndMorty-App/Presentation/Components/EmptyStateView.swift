//
//  EmptyStateView.swift
//  RickAndMorty-App
//
//  Empty state component for no results
//

import SwiftUI

struct EmptyStateView: View {
    let searchQuery: String

    var body: some View {
        ContentUnavailableView {
            Label("No hay resultados", systemImage: "magnifyingglass")
        } description: {
            if !searchQuery.isEmpty {
                Text("No se encontraron personajes que coincidan con '\(searchQuery)'")
                    .multilineTextAlignment(.center)
            } else {
                Text("No hay personajes disponibles")
                    .multilineTextAlignment(.center)
            }
        }
        .accessibilityLabel(searchQuery.isEmpty ? "No hay personajes disponibles" : "No se encontraron resultados para \(searchQuery)")
    }
}

#Preview("With Search") {
    EmptyStateView(searchQuery: "Zzzzzz")
}

#Preview("Without Search") {
    EmptyStateView(searchQuery: "")
}
