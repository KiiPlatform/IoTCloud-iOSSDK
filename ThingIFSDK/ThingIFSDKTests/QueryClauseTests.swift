//
//  QueryClauseTests.swift
//  ThingIFSDK
//
//  Created on 2017/01/24.
//  Copyright (c) 2017 Kii. All rights reserved.
//

import XCTest

@testable import ThingIFSDK

class QueryClauseTests: SmallTestBase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func test() {
        let testCases: [
          (
            clause: EqualsClauseInQuery,
            expected: (field: String, value: AnyObject),
            message: String
          )
        ] = [
          (
            EqualsClauseInQuery("f", intValue: 1),
            ("f", 1 as AnyObject),
            "test 1"
          )
        ]

        for testCase in testCases {
            XCTAssertEqual(
              testCase.expected.field,
              testCase.clause.field,
              testCase.message)
            verifyAnyObject(
              testCase.expected.value,
              testCase.clause.value,
              testCase.message)

            verifyDict2(
              [
                "type": "eq",
                "field": testCase.expected.field,
                "value": testCase.expected.value
              ],
              testCase.clause.makeDictionary(),
              testCase.message)
        }
    }

}
