//
//  MainViewModel.swift
//  nike_swiftui
//
//  Created by davidlee on 6/6/26.
//

import SwiftUI

@Observable
class MainViewModel {
    private let albumDataProvider: AlbumDataProviderProtocol
    var albums: LoadingState<[Album]> = .idle

    init(albumDataProvider: AlbumDataProviderProtocol) {
        self.albumDataProvider = albumDataProvider
    }

    func fetchAlbums() async {
        albums = .loading
        do {
            let data = try await albumDataProvider.fetch()
            let result = try JSONDecoder().decode(TopHundredAlbums.self, from: data).feed.albums
            dump(result)
            albums = .finished(result)
        } catch {
            albums = .error(error)
        }
    }
}
