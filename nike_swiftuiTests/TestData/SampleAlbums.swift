import Foundation
@testable import nike_swiftui

enum SampleAlbums {
    static let folklore = Album(
        id: "1495181700",
        artistName: "Taylor Swift",
        name: "folklore",
        artworkUrl100: "https://example.com/folklore.jpg",
        artistId: "159260351",
        releaseDate: "2020-07-24",
        genres: [],
        url: "https://music.apple.com/us/album/folklore/1495181700"
    )

    static let midnights = Album(
        id: "1649434004",
        artistName: "Taylor Swift",
        name: "Midnights",
        artworkUrl100: "https://example.com/midnights.jpg",
        artistId: "159260351",
        releaseDate: "2022-10-21",
        genres: [],
        url: "https://music.apple.com/us/album/midnights/1649434004"
    )

    static let certifiedLoverBoy = Album(
        id: "1574004398",
        artistName: "Drake",
        name: "Certified Lover Boy",
        artworkUrl100: "https://example.com/clb.jpg",
        artistId: "271256",
        releaseDate: "2021-09-03",
        genres: [],
        url: "https://music.apple.com/us/album/certified-lover-boy/1574004398"
    )
}
