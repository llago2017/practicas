import XCTest

import echo_clientTests

var tests = [XCTestCaseEntry]()
tests += echo_clientTests.allTests()
XCTMain(tests)
