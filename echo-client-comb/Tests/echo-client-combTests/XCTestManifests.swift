import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(echo_client_combTests.allTests),
    ]
}
#endif
