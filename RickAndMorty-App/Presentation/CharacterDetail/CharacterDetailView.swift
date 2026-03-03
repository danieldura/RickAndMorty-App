//
//  CharacterDetailView.swift
//  RickAndMorty-App
//
//  Detail view for a single character
//

import SwiftUI

struct CharacterDetailView: View {
    let character: Character
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    // Hero Image with Kingfisher
                    CharacterHeroImage(
                        imageURL: character.imageURL
                    )
                    .frame(height: 300)
                    .frame(maxWidth: .infinity)
                    .clipped()
                    .accessibilityLabel("Imagen de \(character.name)")

                    // Character Details
                    VStack(alignment: .leading, spacing: 24) {
                        // Name and Status
                        VStack(alignment: .leading, spacing: 8) {
                            Text(character.name)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .accessibilityAddTraits(.isHeader)

                            HStack(spacing: 8) {
                                Circle()
                                    .fill(statusColor(for: character.status))
                                    .frame(width: 12, height: 12)
                                    .accessibilityHidden(true)

                                Text(character.status.displayText)
                                    .font(.title3)
                                    .foregroundStyle(.secondary)
                            }
                            .accessibilityLabel("Estado: \(character.status.displayText)")
                        }

                        Divider()

                        // Info Grid
                        VStack(spacing: 20) {
                            DetailRow(
                                icon: "person.fill",
                                title: "Especie",
                                value: character.species
                            )

                            if !character.type.isEmpty {
                                DetailRow(
                                    icon: "tag.fill",
                                    title: "Tipo",
                                    value: character.type
                                )
                            }

                            DetailRow(
                                icon: "figure.stand",
                                title: "Género",
                                value: character.gender
                            )

                            DetailRow(
                                icon: "globe",
                                title: "Origen",
                                value: character.originName
                            )

                            DetailRow(
                                icon: "location.fill",
                                title: "Última ubicación conocida",
                                value: character.locationName
                            )

                            DetailRow(
                                icon: "tv.fill",
                                title: "Episodios",
                                value: "\(character.episodeCount)"
                            )
                        }

                        Divider()

                        // Created Date
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Fecha de creación")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .textCase(.uppercase)

                            Text(character.created, style: .date)
                                .font(.body)
                        }
                        .accessibilityLabel("Fecha de creación: \(character.created.formatted(date: .long, time: .omitted))")
                    }
                    .padding(24)
                }
            }
            .ignoresSafeArea(edges: .top)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .symbolRenderingMode(.hierarchical)
                            .foregroundStyle(.secondary)
                            .font(.title2)
                    }
                    .accessibilityLabel("Cerrar")
                }
            }
        }
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

// MARK: - Detail Row Component
private struct DetailRow: View {
    let icon: String
    let title: String
    let value: String

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(.green)
                .frame(width: 28)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .textCase(.uppercase)

                Text(value)
                    .font(.body)
            }

            Spacer()
        }
        .accessibilityLabel("\(title): \(value)")
    }
}

#Preview {
    @Previewable @Namespace var namespace

    CharacterDetailView(
        character: Character(
            id: 1,
            name: "Rick Sanchez",
            status: .alive,
            species: "Human",
            type: "Genius Scientist",
            gender: "Male",
            originName: "Earth (C-137)",
            locationName: "Citadel of Ricks",
            imageURL: "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
            episodeCount: 51,
            created: Date()
        )
    )
}
