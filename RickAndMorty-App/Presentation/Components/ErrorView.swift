//
//  ErrorView.swift
//  RickAndMorty-App
//
//  Error state component with retry
//

import SwiftUI

struct ErrorView: View {
    let message: String
    let onRetry: () -> Void

    var body: some View {
        ContentUnavailableView {
            Label("Error", systemImage: "exclamationmark.triangle.fill")
                .foregroundStyle(.red)
        } description: {
            Text(message)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
        } actions: {
            Button {
                onRetry()
            } label: {
                Label("Reintentar", systemImage: "arrow.clockwise")
            }
            .buttonStyle(.borderedProminent)
            .tint(.green)
        }
        .accessibilityLabel("Error: \(message)")
        .accessibilityAddTraits(.isButton)
        .accessibilityHint("Toca reintentar para cargar de nuevo")
    }
}

#Preview {
    ErrorView(
        message: "No se pudieron cargar los personajes. Verifica tu conexión a internet.",
        onRetry: {}
    )
}
