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

    func testEqualClauses() {
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
          ),
          (
            EqualsClauseInQuery("f", boolValue: true),
            ("f", true as AnyObject),
            "test 1"
          ),
          (
            EqualsClauseInQuery("f", stringValue: "1"),
            ("f", "1" as AnyObject),
            "test 1"
          )
        ]

        for (clause, expected, message) in testCases {
            XCTAssertEqual(
              expected.field,
              clause.field,
              message)

            verifyAnyObject(
              expected.value,
              clause.value,
              message)

            verifyDict2(
              [
                "type": "eq",
                "field": expected.field,
                "value": expected.value
              ],
              clause.makeDictionary(),
              message)

            let data = NSMutableData(capacity: 1024)!;
            let coder = NSKeyedArchiver(forWritingWith: data);
            clause.encode(with: coder);
            coder.finishEncoding();

            let decoder = NSKeyedUnarchiver(forReadingWith: data as Data);
            let deserialized = EqualsClauseInQuery(coder: decoder)!;
            decoder.finishDecoding();

            XCTAssertEqual(
              expected.field,
              deserialized.field,
              message)

            verifyAnyObject(
              expected.value,
              deserialized.value,
              message)
        }
    }

}
