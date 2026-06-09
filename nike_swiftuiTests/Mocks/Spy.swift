@testable import nike_swiftui

struct Spy {
    var callCount = 0
    var lastRequest: ApiRequest?

    mutating func record(_ request: ApiRequest) {
        callCount += 1
        lastRequest = request
    }
}
