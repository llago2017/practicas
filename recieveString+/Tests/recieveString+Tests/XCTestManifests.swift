import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(recieveString_Tests.allTests),
    ]
}
#endif
