import XCTest

import asyncTests

var tests = [XCTestCaseEntry]()
tests += asyncTests.allTests()
XCTMain(tests)
