import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(echo_server_structTests.allTests),
    ]
}
#endif
