//
//  AlbumView.swift
//  nike_swiftui
//
//  Created by davidlee on 6/6/26.
//

import SwiftUI

struct AlbumView: View {
    let album: Album

    var body: some View {
        HStack(spacing: 10) {
            AsyncImage(url: URL(string: album.artworkUrl100)) { image in
                image.resizable().scaledToFill()
            } placeholder: {
                EmptyView()
            }
            .frame(width: 50, height: 50)
            .clipped()
            
            VStack(alignment: .leading) {
                Text(album.name)
                    .font(.headline)
                    .foregroundStyle(.primary)

                Text(album.artistName)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                Text(album.releaseDate)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}
