import Testing
import Foundation
@testable import nike_swiftui

@Suite("AlbumDataProvider")
struct AlbumDataProviderTests {
    let expected = Data("albums".utf8)
    private let apiService: MockApiService
    private let albumDataProvider: AlbumDataProviderProtocol

    init() {
        apiService = MockApiService()
        albumDataProvider = AlbumDataProvider(apiService: apiService)
    }

    @Test("fetch returns data from apiService")
    func fetchReturnsData() async throws {
        await apiService.configure(stub: .init(result: .success(expected)))

        let result = try await albumDataProvider.fetch()
        #expect(result == expected)
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
        await apiService.configure(stub: .init(result: .success(expected)))

        let results = try await withThrowingTaskGroup(of: Data.self) { group in
            for _ in 0..<3 {
                group.addTask { try await albumDataProvider.fetch() }
            }
            var collected: [Data] = []
            for try await r in group { collected.append(r) }
            return collected
        }

        #expect(results.count == 3)
        #expect(results.allSatisfy { $0 == expected })
        let spy = await apiService.spy
        #expect(spy.callCount == 1)
    }

    @Test("second fetch after first completes creates a new apiService call")
    func sequentialFetchesEachCallApiService() async throws {
        await apiService.configure(stub: .init(result: .success(expected)))

        _ = try await albumDataProvider.fetch()
        _ = try await albumDataProvider.fetch()

        let spy = await apiService.spy
        #expect(spy.callCount == 2)
    }
}
