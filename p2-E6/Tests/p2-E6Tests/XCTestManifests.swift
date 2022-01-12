import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(p2_E6Tests.allTests),
    ]
}
#endif
