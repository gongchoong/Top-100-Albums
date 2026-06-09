//
//  Album.swift
//  nike_swiftui
//
//  Created by davidlee on 6/6/26.
//

import Foundation

nonisolated struct TopHundredAlbums: Codable, Sendable {
    let feed: Feed
}

nonisolated struct Feed: Codable, Sendable {
    let title: String
    let albums: [Album]

    enum CodingKeys: String, CodingKey {
        case title
        case albums = "results"
    }
}

nonisolated struct Album: Codable, Identifiable, Sendable {
    let id: String
    let artistName: String
    let name: String
    let artworkUrl100: String
    let artistId: String?
    let releaseDate: String
    let genres: [Genre]?
    let url: String
}

nonisolated struct Genre: Codable, Sendable, Identifiable {
    var id: String { genreId }
    let genreId: String
    let name: String
    let url: String
}

extension Album {
    enum CodingKeys: String, CodingKey {
        case id, artistName, name, artworkUrl100, artistId, releaseDate, genres, url
    }

    nonisolated init(from decoder: any Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = (try? c.decode(String.self, forKey: .id)) ?? UUID().uuidString
        artistName = try c.decode(String.self, forKey: .artistName)
        name = try c.decode(String.self, forKey: .name)
        artworkUrl100 = try c.decode(String.self, forKey: .artworkUrl100)
        artistId = try? c.decode(String.self, forKey: .artistId)
        releaseDate = try c.decode(String.self, forKey: .releaseDate)
        genres = try? c.decode([Genre].self, forKey: .genres)
        url = try c.decode(String.self, forKey: .url)
    }

    var genreNames: String? {
        guard let genres, !genres.isEmpty else { return nil }
        return genres.map(\.name).joined(separator: " ")
    }
}
