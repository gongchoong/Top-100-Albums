import Foundation
@testable import nike_swiftui

actor MockAlbumDataProvider: AlbumDataProviderProtocol {
    var stub = Stub<[Album]>(result: .success([]))

    func configure(stub: Stub<[Album]>) {
        self.stub = stub
    }

    func fetch() async throws -> [Album] {
        return try stub.result.get()
    }
}
