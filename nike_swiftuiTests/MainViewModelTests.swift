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

    @Test("fetchAlbums sets state to finished with albums on success")
    func fetchAlbumsSuccess() async throws {
        await dataProvider.configure(stub: .init(result: .success([SampleAlbums.folklore])))

        await viewModel.fetchAlbums()

        guard case .finished(let albums) = viewModel.albums else {
            Issue.record("Expected .finished, got \(viewModel.albums)")
            return
        }
        #expect(albums.count == 1)
        #expect(albums[0].name == SampleAlbums.folklore.name)
        #expect(albums[0].artistName == SampleAlbums.folklore.artistName)
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

    @Test("filteredAlbums returns empty when albums are not loaded")
    func filteredAlbumsNotLoaded() {
        #expect(viewModel.filteredAlbums(matching: "").isEmpty)
    }

    @Test("filteredAlbums returns all albums when search text is empty")
    func filteredAlbumsEmptySearch() async throws {
        await dataProvider.configure(stub: .init(result: .success([SampleAlbums.folklore, SampleAlbums.midnights])))
        await viewModel.fetchAlbums()

        #expect(viewModel.filteredAlbums(matching: "").count == 2)
    }

    @Test("filteredAlbums filters by album name case-insensitively")
    func filteredAlbumsByName() async throws {
        await dataProvider.configure(stub: .init(result: .success([SampleAlbums.folklore, SampleAlbums.midnights])))
        await viewModel.fetchAlbums()

        let results = viewModel.filteredAlbums(matching: "FOLK")
        #expect(results.count == 1)
        #expect(results[0].name == SampleAlbums.folklore.name)
    }

    @Test("filteredAlbums filters by artist name case-insensitively")
    func filteredAlbumsByArtist() async throws {
        await dataProvider.configure(stub: .init(result: .success([SampleAlbums.folklore, SampleAlbums.certifiedLoverBoy])))
        await viewModel.fetchAlbums()

        let results = viewModel.filteredAlbums(matching: "drake")
        #expect(results.count == 1)
        #expect(results[0].artistName == SampleAlbums.certifiedLoverBoy.artistName)
    }

    @Test("filteredAlbums returns empty when no albums match search text")
    func filteredAlbumsNoMatch() async throws {
        await dataProvider.configure(stub: .init(result: .success([SampleAlbums.folklore])))
        await viewModel.fetchAlbums()

        #expect(viewModel.filteredAlbums(matching: "zzz").isEmpty)
    }
}
