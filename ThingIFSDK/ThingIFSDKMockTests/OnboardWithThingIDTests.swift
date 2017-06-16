//
//  OnboardWithThingIDTests.swift
//  ThingIFSDK
//
//  Created on 2017/06/16.
//  Copyright (c) 2017 Kii. All rights reserved.
//

import XCTest
@testable import ThingIF

class OnboardWithThingIDTests: ThingIFHTTPMockTestBase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testOnboardWithThingIDByOwner() throws {
        let api = createThingIFAPI("test-onboard-with-id-success")
        XCTAssertFalse(api.onboarded)
        executeAsynchronous { expectation in
            api.onboardWith(
              thingID: "thing-id",
              thingPassword: "thing-password") { target, error in
                XCTAssertNil(error)
                XCTAssertNotNil(target)
                if let target = target {
                    XCTAssertEqual(
                      StandaloneThingWrapper(target as? StandaloneThing),
                      StandaloneThingWrapper(StandaloneThing(
                                               "thing-id",
                                               vendorThingID: "",
                                               accessToken: "accesstoken")))
                }
                expectation.fulfill()
            }
        }
        XCTAssertTrue(api.onboarded)
    }
}
