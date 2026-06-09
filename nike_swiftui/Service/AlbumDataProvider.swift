//
//  AlbumDataProvider.swift
//  nike_swiftui
//
//  Created by davidlee on 6/6/26.
//

import Foundation

/// Defines the interface for fetching decoded album data.
protocol AlbumDataProviderProtocol: Sendable {
    /// Fetches and decodes the top albums from the underlying source.
    /// - Returns: An array of `Album` from the feed response.
    /// - Throws: An error if the network request fails or decoding fails.
    func fetch() async throws -> [Album]
}

/// Fetches and decodes album data from the API, coalescing concurrent requests into a single in-flight task.
final actor AlbumDataProvider: AlbumDataProviderProtocol {
    private let apiService: ApiServiceProtocol
    private var currentTask: Task<[Album], Error>?

    /// - Parameter apiService: The service used to perform the underlying network request.
    init(apiService: ApiServiceProtocol) {
        self.apiService = apiService
    }

    /// Fetches and decodes albums, reusing an existing in-flight request if one is already running.
    /// - Returns: An array of `Album` from the feed response.
    /// - Throws: An error if the network request fails or decoding fails.
    func fetch() async throws -> [Album] {
        if let task = currentTask {
            return try await task.value
        }

        let request = ApiRequest(path: .mostPlayedAlbums)
        let task = Task<[Album], Error> { [apiService] in
            defer { currentTask = nil }
            let data = try await apiService.response(request: request)
            return try JSONDecoder().decode(TopHundredAlbums.self, from: data).feed.albums
        }

        currentTask = task
        return try await task.value
    }
}

