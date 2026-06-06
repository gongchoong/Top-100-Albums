//
//  APIService.swift
//  nike_swiftui
//
//  Created by davidlee on 6/6/26.
//

import Foundation

protocol ApiServiceProtocol: Sendable {
    func response(request: ApiRequest) async throws -> Data
}

class ApiService: ApiServiceProtocol {
    func response(request: ApiRequest) async throws -> Data {
        guard let url = URL(string: request.path.rawValue) else {
            throw ApiError.invalidURL
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.httpBody = request.body
        request.headers.forEach { urlRequest.setValue($1, forHTTPHeaderField: $0) }

        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw ApiError.missingResponse
        }

        guard httpResponse.statusCode == 200 else {
            throw ApiError.error(code: httpResponse.statusCode)
        }

        return data
    }
}
