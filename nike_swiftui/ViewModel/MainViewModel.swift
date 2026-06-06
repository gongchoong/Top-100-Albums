//
//  MainViewModel.swift
//  nike_swiftui
//
//  Created by davidlee on 6/6/26.
//

import SwiftUI

@Observable
class MainViewModel {
    private let albumService: AlbumServiceProtocol
    var albums: LoadingState<[Album]> = .idle

    init(albumService: AlbumServiceProtocol) {
        self.albumService = albumService
    }

    func fetchAlbums() async {
        albums = .loading
        do {
            let data = try await albumService.fetch()
            let result = try JSONDecoder().decode(TopHundredAlbums.self, from: data).feed.albums
            dump(result)
            albums = .finished(result)
        } catch {
            albums = .error(error)
        }
    }
}
