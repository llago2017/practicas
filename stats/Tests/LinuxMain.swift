import XCTest

import statsTests

var tests = [XCTestCaseEntry]()
tests += statsTests.allTests()
XCTMain(tests)
