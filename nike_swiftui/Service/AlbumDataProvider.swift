//
//  AlbumDataProvider.swift
//  nike_swiftui
//
//  Created by davidlee on 6/6/26.
//

import Foundation

protocol AlbumDataProviderProtocol: Sendable {
    func fetch() async throws -> Data
}

actor AlbumDataProvider: AlbumDataProviderProtocol {
    private let apiService: ApiServiceProtocol
    private var currentTask: Task<Data, Error>?

    init(apiService: ApiServiceProtocol) {
        self.apiService = apiService
    }

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
