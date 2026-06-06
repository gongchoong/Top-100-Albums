//
//  AlbumDetailView.swift
//  nike_swiftui
//
//  Created by davidlee on 6/6/26.
//

import SwiftUI

struct AlbumDetailView: View {
    let album: Album

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                AsyncImage(url: URL(string: album.artworkUrl100)) { image in
                    image.resizable().scaledToFit()
                } placeholder: {
                    Color.secondary.opacity(0.2)
                }
                .frame(width: 250, height: 250)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(radius: 8)

                VStack(spacing: 8) {
                    Text(album.name)
                        .font(.title2)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)

                    Text(album.artistName)
                        .font(.title3)
                        .foregroundStyle(.secondary)
                    
                    if let genres = album.genres {
                        HStack {
                            ForEach(genres) { genre in
                                Text(genre.name)
                                    .font(.subheadline)
                                    .foregroundStyle(.tertiary)
                            }
                        }
                    }

                    Text(album.releaseDate)
                        .font(.subheadline)
                        .foregroundStyle(.tertiary)

                    if let url = URL(string: album.url) {
                        Link(destination: url) {
                            Text("View on Apple Music")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .foregroundStyle(.link)
                        }
                    }
                }
                .padding(.horizontal)
            }
            .padding()
        }
        .navigationTitle(album.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}
