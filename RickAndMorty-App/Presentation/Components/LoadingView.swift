//
//  LoadingView.swift
//  RickAndMorty-App
//
//  Loading indicator component
//

import SwiftUI

struct LoadingView: View {
    let message: String

    init(message: String = "Cargando personajes...") {
        self.message = message
    }

    var body: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.5)
                .tint(.green)

            Text(message)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .accessibilityLabel(message)
    }
}

#Preview {
    LoadingView()
}
