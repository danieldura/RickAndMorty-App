//
//  CachedAsyncImage.swift
//  RickAndMorty-App
//
//  Reusable component for loading and caching images with Kingfisher
//

import SwiftUI
import Kingfisher

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
            .onFailure { _ in
                Image(systemName: "person.fill")
                    .resizable()
                    .foregroundStyle(.secondary)
                    .padding(60)
            }
            .resizable()
            .aspectRatio(contentMode: .fill)
    }
}

// MARK: - Kingfisher Cache Manager Extension
extension KingfisherManager {
    static func clearCache() {
        KingfisherManager.shared.cache.clearMemoryCache()
        KingfisherManager.shared.cache.clearDiskCache()
    }

    static func clearMemoryCache() {
        KingfisherManager.shared.cache.clearMemoryCache()
    }
    
    static func configureKingfisher() {
        KingfisherManager.shared.downloader.downloadTimeout = 15
        KingfisherManager.shared.downloader.sessionConfiguration = {
            let config = URLSessionConfiguration.default
            config.httpMaximumConnectionsPerHost = 2 // Máximo 2 descargas simultáneas por host
            return config
        }()
    }
}
