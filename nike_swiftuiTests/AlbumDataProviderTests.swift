import Testing
import Foundation
@testable import nike_swiftui

@Suite("AlbumDataProvider")
struct AlbumDataProviderTests {
    private let apiService: MockApiService
    private let albumDataProvider: AlbumDataProviderProtocol

    init() {
        apiService = MockApiService()
        albumDataProvider = AlbumDataProvider(apiService: apiService)
    }

    @Test("fetch returns albums decoded from apiService response")
    func fetchReturnsAlbums() async throws {
        await apiService.configure(stub: .init(result: .success(try makeData(albums: [SampleAlbums.folklore]))))

        let result = try await albumDataProvider.fetch()
        #expect(result.count == 1)
        #expect(result[0].name == SampleAlbums.folklore.name)
        #expect(result[0].artistName == SampleAlbums.folklore.artistName)
    }

    @Test("fetch propagates apiService errors")
    func fetchPropagatesError() async throws {
        await apiService.configure(stub: .init(result: .failure(ApiError.missingData)))

        await #expect(throws: ApiError.self) {
            try await albumDataProvider.fetch()
        }
    }

    @Test("concurrent fetches deduplicate to a single apiService call")
    func concurrentFetchesDeduplicate() async throws {
        await apiService.configure(stub: .init(result: .success(try makeData(albums: [SampleAlbums.folklore]))))

        let results = try await withThrowingTaskGroup(of: [Album].self) { group in
            for _ in 0..<3 {
                group.addTask { try await albumDataProvider.fetch() }
            }
            var collected: [[Album]] = []
            for try await r in group { collected.append(r) }
            return collected
        }

        #expect(results.count == 3)
        #expect(results.allSatisfy { $0.count == 1 && $0[0].name == SampleAlbums.folklore.name })
        let spy = await apiService.spy
        #expect(spy.callCount == 1)
    }

    @Test("second fetch after first completes creates a new apiService call")
    func sequentialFetchesEachCallApiService() async throws {
        await apiService.configure(stub: .init(result: .success(try makeData(albums: [SampleAlbums.folklore]))))

        _ = try await albumDataProvider.fetch()
        _ = try await albumDataProvider.fetch()

        let spy = await apiService.spy
        #expect(spy.callCount == 2)
    }

    // MARK: - Helpers

    private func makeData(albums: [Album]) throws -> Data {
        try JSONEncoder().encode(TopHundredAlbums(feed: Feed(title: "Top 100", albums: albums)))
    }
}
