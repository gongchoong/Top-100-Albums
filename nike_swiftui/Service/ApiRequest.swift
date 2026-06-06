//
//  ApiRequest.swift
//  nike_swiftui
//
//  Created by davidlee on 6/6/26.
//

import Foundation

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}

struct ApiRequest {
    let path: Endpoint
    var method: HttpMethod = .get
    var headers: [String: String] = [:]
    var body: Data? = nil
}
