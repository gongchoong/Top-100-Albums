import Foundation
@testable import nike_swiftui

actor MockAlbumDataProvider: AlbumDataProviderProtocol {
    var stub = Stub()

    func configure(stub: Stub) {
        self.stub = stub
    }

    func fetch() async throws -> Data {
        return try stub.result.get()
    }
}
