//
//  Album.swift
//  nike_swiftui
//
//  Created by davidlee on 6/6/26.
//

import Foundation

struct TopHundredAlbums: Codable, Sendable {
    let feed: Feed
}

struct Feed: Codable, Sendable {
    let title: String
    let albums: [Album]

    enum CodingKeys: String, CodingKey {
        case title
        case albums = "results"
    }
}

struct Album: Codable, Identifiable, Sendable {
    var id: String = UUID().uuidString
    let artistName: String
    let name: String
    let artworkUrl100: String
    let artistId: String?
    let releaseDate: String
    let genres: [Genre]?
    let url: String
}

struct Genre: Codable, Sendable, Identifiable {
    var id: String { genreId }
    let genreId: String
    let name: String
    let url: String
}
