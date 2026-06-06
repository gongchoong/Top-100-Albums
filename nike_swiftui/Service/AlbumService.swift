//
//  AlbumService.swift
//  nike_swiftui
//
//  Created by davidlee on 6/6/26.
//

import Foundation

protocol AlbumServiceProtocol: Sendable {
    func fetch() async throws -> Data
}

actor AlbumService: AlbumServiceProtocol {
    private let apiService: ApiServiceProtocol
    private var currentTask: Task<Data, Error>?

    init(apiService: ApiServiceProtocol) {
        self.apiService = apiService
    }

    func fetch() async throws -> Data {
        if let task = currentTask {
            return try await task.value
        }

        let request = ApiRequest(address: "https://rss.applemarketingtools.com/api/v2/us/music/most-played/100/albums.json")
        let task = Task {
            defer { currentTask = nil }
            return try await self.apiService.response(request: request)
        }

        currentTask = task
        return try await task.value
    }
}
