import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(ejemploEnlazadaTests.allTests),
    ]
}
#endif
