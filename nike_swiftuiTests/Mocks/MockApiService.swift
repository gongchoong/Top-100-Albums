import Foundation
@testable import nike_swiftui

actor MockApiService: ApiServiceProtocol {
    var stub = Stub(result: .success(Data()))
    private(set) var spy = Spy()

    func configure(stub: Stub<Data>) {
        self.stub = stub
    }

    func response(request: ApiRequest) async throws -> Data {
        spy.record(request)
        await Task.yield()
        return try stub.result.get()
    }
}
