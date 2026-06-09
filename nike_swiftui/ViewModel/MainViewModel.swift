//
//  MainViewModel.swift
//  nike_swiftui
//
//  Created by davidlee on 6/6/26.
//

import SwiftUI

/// Manages the state of the top albums list and exposes filtered results for the main view.
@Observable
@MainActor
class MainViewModel {
    private let albumDataProvider: AlbumDataProviderProtocol
    var albums: LoadingState<[Album]> = .idle

    init(albumDataProvider: AlbumDataProviderProtocol) {
        self.albumDataProvider = albumDataProvider
    }

    /// Fetches the top albums from the data provider and updates `albums` state.
    /// Sets state to `.loading` before the request and `.finished` or `.error` on completion.
    func fetchAlbums() async {
        albums = .loading
        do {
            let result = try await albumDataProvider.fetch()
            albums = .finished(result)
        } catch {
            albums = .error(error)
        }
    }

    /// Returns albums whose name or artist name contains the search text (case-insensitive).
    /// - Parameter searchText: The string to filter albums by. Pass an empty string to return all albums.
    /// - Returns: A filtered array of `Album`, or an empty array if albums have not finished loading.
    func filteredAlbums(matching searchText: String) -> [Album] {
        guard case .finished(let albums) = albums else { return [] }
        if searchText.isEmpty { return albums }
        return albums.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.artistName.localizedCaseInsensitiveContains(searchText)
        }
    }
}
