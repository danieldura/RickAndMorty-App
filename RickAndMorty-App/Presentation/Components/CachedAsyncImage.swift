//
//  CachedAsyncImage.swift
//  RickAndMorty-App
//
//  Reusable component for loading and caching images with Kingfisher
//

import SwiftUI
import Kingfisher

// MARK: - Retry Strategy
private let kingfisherRetryStrategy = DelayRetryStrategy(
    maxRetryCount: 3,
    retryInterval: .seconds(4)
)

// MARK: - Character Thumbnail (Optimized for List)
struct CharacterThumbnail: View {
    let imageURL: String
    let size: CGFloat

    @Environment(\.displayScale) private var displayScale

    init(imageURL: String, size: CGFloat = 80) {
        self.imageURL = imageURL
        self.size = size
    }

    var body: some View {
        KFImage(URL(string: imageURL))
            .placeholder {
                Rectangle()
                    .fill(.gray.opacity(0.2))
                    .overlay {
                        ProgressView()
                            .tint(.green)
                    }
            }
            .setProcessor(
                DownsamplingImageProcessor(size: CGSize(width: size * 2, height: size * 2))
                |> RoundCornerImageProcessor(cornerRadius: 12)
            )
            .scaleFactor(displayScale)
            .cacheMemoryOnly()
            .fade(duration: 0.2)
            .retry(kingfisherRetryStrategy)
            .onFailure { error in
                print("Error downloading image: \(error)")
            }
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: size, height: size)
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Character Hero Image (Detail View)
struct CharacterHeroImage: View {
    let imageURL: String

    @Environment(\.displayScale) private var displayScale

    var body: some View {
        KFImage(URL(string: imageURL))
            .placeholder {
                Rectangle()
                    .fill(.gray.opacity(0.1))
                    .overlay {
                        ProgressView()
                            .controlSize(.large)
                            .tint(.green)
                    }
            }
            .setProcessor(
                DownsamplingImageProcessor(size: CGSize(width: 800, height: 800))
            )
            .scaleFactor(displayScale)
            .cacheOriginalImage()
            .fade(duration: 0.25)
            .retry(kingfisherRetryStrategy)
            .onFailure { error in
                print("Error downloading image: \(error)")
                Image(systemName: "person.fill")
                    .resizable()
                    .foregroundStyle(.secondary)
                    .padding(60)
            }
            .resizable()
            .aspectRatio(contentMode: .fill)
    }
}
