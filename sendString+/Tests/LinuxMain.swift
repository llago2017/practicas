import XCTest

import server_string_Tests

var tests = [XCTestCaseEntry]()
tests += server_string_Tests.allTests()
XCTMain(tests)
