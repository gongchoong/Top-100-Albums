import Testing
import Foundation
@testable import nike_swiftui

@Suite("MainViewModel")
@MainActor
struct MainViewModelTests {
    private let dataProvider: MockAlbumDataProvider
    private let viewModel: MainViewModel

    init() {
        dataProvider = MockAlbumDataProvider()
        viewModel = MainViewModel(albumDataProvider: dataProvider)
    }

    @Test("initial state is idle")
    func initialStateIsIdle() {
        guard case .idle = viewModel.albums else {
            Issue.record("Expected .idle, got \(viewModel.albums)")
            return
        }
    }

    @Test("fetchAlbums sets state to finished with decoded albums on success")
    func fetchAlbumsSuccess() async throws {
        let album = makeAlbum(name: "folklore", artistName: "Taylor Swift")
        let data = try encode(albums: [album])
        await dataProvider.configure(stub: .init(result: .success(data)))

        await viewModel.fetchAlbums()

        guard case .finished(let albums) = viewModel.albums else {
            Issue.record("Expected .finished, got \(viewModel.albums)")
            return
        }
        #expect(albums.count == 1)
        #expect(albums[0].name == "folklore")
        #expect(albums[0].artistName == "Taylor Swift")
    }

    @Test("fetchAlbums sets state to error when data provider throws")
    func fetchAlbumsDataProviderError() async {
        await dataProvider.configure(stub: .init(result: .failure(ApiError.missingData)))

        await viewModel.fetchAlbums()

        guard case .error = viewModel.albums else {
            Issue.record("Expected .error, got \(viewModel.albums)")
            return
        }
    }

    @Test("fetchAlbums sets state to error when response is not decodable")
    func fetchAlbumsDecodingError() async {
        await dataProvider.configure(stub: .init(result: .success(Data("invalid json".utf8))))

        await viewModel.fetchAlbums()

        guard case .error = viewModel.albums else {
            Issue.record("Expected .error, got \(viewModel.albums)")
            return
        }
    }

    // MARK: - Helpers

    private func makeAlbum(name: String, artistName: String) -> Album {
        Album(
            artistName: artistName,
            name: name,
            artworkUrl100: "https://example.com/art.jpg",
            artistId: "1",
            releaseDate: "2024-01-01",
            genres: [],
            url: "https://example.com"
        )
    }

    private func encode(albums: [Album]) throws -> Data {
        let payload = TopHundredAlbums(feed: Feed(title: "Top 100", albums: albums))
        return try JSONEncoder().encode(payload)
    }
}
