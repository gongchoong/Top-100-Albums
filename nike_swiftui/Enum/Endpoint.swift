//
//  Endpoint.swift
//  nike_swiftui
//
//  Created by davidlee on 6/6/26.
//

import Foundation

enum Endpoint: Sendable {
    static var mostPlayedAlbums: String {
        "https://rss.applemarketingtools.com/api/v2/us/music/most-played/100/albums.json"
    }
}
