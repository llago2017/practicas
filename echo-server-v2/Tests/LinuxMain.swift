import XCTest

import echo_serverTests

var tests = [XCTestCaseEntry]()
tests += echo_serverTests.allTests()
XCTMain(tests)
