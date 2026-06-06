//
//  ApiError.swift
//  nike_swiftui
//
//  Created by davidlee on 6/6/26.
//

import Foundation

enum ApiError: LocalizedError {
    case invalidURL
    
    case missingResponse
    case missingData
    case error(code: Int)

    var errorDescription: String? {
        switch self {
        case .invalidURL:       return "Invalid URL"
        case .missingResponse:  return "No response from server"
        case .missingData:      return "No data received"
        case .error(let code):  return "Request failed with status code \(code)"
        }
    }
}
