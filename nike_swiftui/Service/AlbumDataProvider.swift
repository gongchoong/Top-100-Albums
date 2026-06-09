//
//  AlbumDataProvider.swift
//  nike_swiftui
//
//  Created by davidlee on 6/6/26.
//

import Foundation

/// Defines the interface for fetching raw album data.
protocol AlbumDataProviderProtocol: Sendable {
    /// Fetches raw album data from the underlying source.
    /// - Returns: Raw `Data` representing the album feed response.
    /// - Throws: An error if the network request fails or no data is returned.
    func fetch() async throws -> Data
}

/// Fetches album data from the API, coalescing concurrent requests into a single in-flight task.
final actor AlbumDataProvider: AlbumDataProviderProtocol {
    private let apiService: ApiServiceProtocol
    private var currentTask: Task<Data, Error>?

    /// - Parameter apiService: The service used to perform the underlying network request.
    init(apiService: ApiServiceProtocol) {
        self.apiService = apiService
    }

    /// Fetches raw album data, reusing an existing in-flight request if one is already running.
    /// - Returns: Raw `Data` representing the album feed response.
    /// - Throws: An error if the network request fails or no data is returned.
    func fetch() async throws -> Data {
        if let task = currentTask {
            return try await task.value
        }

        let request = ApiRequest(path: .mostPlayedAlbums)
        let task = Task {
            defer { currentTask = nil }
            return try await self.apiService.response(request: request)
        }

        currentTask = task
        return try await task.value
    }
}
