//
//  CharacterRowView.swift
//  RickAndMorty-App
//
//  Reusable row component for character list
//

import SwiftUI

struct CharacterRowView: View {
    let character: Character

    var body: some View {
        HStack(spacing: 16) {
            // Character Thumbnail with Kingfisher
            CharacterThumbnail(imageURL: character.imageURL, size: 80)
                .accessibilityLabel("Imagen de \(character.name)")

            // Character Info
            VStack(alignment: .leading, spacing: 6) {
                Text(character.name)
                    .font(.headline)
                    .foregroundStyle(.primary)
                    .accessibilityLabel("Nombre: \(character.name)")

                // Status Badge
                HStack(spacing: 6) {
                    Circle()
                        .fill(statusColor(for: character.status))
                        .frame(width: 8, height: 8)
                        .accessibilityHidden(true)

                    Text(character.status.displayText)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .accessibilityLabel("Estado: \(character.status.displayText)")

                Text(character.species)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .accessibilityLabel("Especie: \(character.species)")

                if !character.locationName.isEmpty {
                    HStack(spacing: 4) {
                        Image(systemName: "location.fill")
                            .font(.caption)
                            .foregroundStyle(.tertiary)
                            .accessibilityHidden(true)

                        Text(character.locationName)
                            .font(.caption)
                            .foregroundStyle(.tertiary)
                            .lineLimit(1)
                    }
                    .accessibilityLabel("Ubicación: \(character.locationName)")
                }
            }

            Spacer(minLength: 0)

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(.tertiary)
                .accessibilityHidden(true)
        }
        .padding(.vertical, 8)
        .contentShape(Rectangle())
        .accessibilityAddTraits(.isButton)
        .accessibilityHint("Toca para ver más detalles")
    }

    // MARK: - Helper Methods
    private func statusColor(for status: CharacterStatus) -> Color {
        switch status {
        case .alive:
            return .green
        case .dead:
            return .red
        case .unknown:
            return .gray
        }
    }
}

#Preview("Alive Character") {
    @Previewable @Namespace var namespace
    
    List {
        CharacterRowView(
            character: Character(
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
            )
        )
    }
}

#Preview("Dead Character") {
    @Previewable @Namespace var namespace
    
    List {
        CharacterRowView(
            character: Character(
                id: 2,
                name: "Morty Smith",
                status: .dead,
                species: "Human",
                type: "",
                gender: "Male",
                originName: "Earth (C-137)",
                locationName: "Earth",
                imageURL: "https://rickandmortyapi.com/api/character/avatar/2.jpeg",
                episodeCount: 51,
                created: Date()
            )
        )
    }
}
