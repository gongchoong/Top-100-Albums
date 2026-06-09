import Testing
@testable import nike_swiftui

@Suite("ApiError")
struct ApiErrorTests {

    @Test("invalidURL has correct description")
    func invalidURLDescription() {
        #expect(ApiError.invalidURL.errorDescription == "Invalid URL")
    }

    @Test("missingResponse has correct description")
    func missingResponseDescription() {
        #expect(ApiError.missingResponse.errorDescription == "No response from server")
    }

    @Test("missingData has correct description")
    func missingDataDescription() {
        #expect(ApiError.missingData.errorDescription == "No data received")
    }

    @Test("error(code:) includes status code in description", arguments: [400, 401, 404, 500])
    func errorCodeDescription(code: Int) {
        #expect(ApiError.error(code: code).errorDescription == "Request failed with status code \(code)")
    }
}
