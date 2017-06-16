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

    func testOnboardWithThingIDByOwner403Error() throws {
        let api = createThingIFAPI("test-onboard-with-id-403")
        executeAsynchronous { expectation in
            api.onboardWith(
              thingID: "thing-id",
              thingPassword: "thing-password") { target, error in
                XCTAssertNil(target)
                XCTAssertEqual(
                  error,
                  ThingIFError.errorResponse(
                    required: ErrorResponse(403,
                                            errorCode: "",
                                            errorMessage: "")))
                expectation.fulfill()
            }
        }
    }

    func testOnboardWithThingIDByOwner404Error() throws {
        let api = createThingIFAPI("test-onboard-with-id-404")
        executeAsynchronous { expectation in
            api.onboardWith(
              thingID: "thing-id",
              thingPassword: "thing-password") { target, error in
                XCTAssertNil(target)
                XCTAssertEqual(
                  error,
                  ThingIFError.errorResponse(
                    required: ErrorResponse(404,
                                            errorCode: "",
                                            errorMessage: "")))
                expectation.fulfill()
            }
        }
    }

    func testOnboardWithThingIDByOwner500Error() throws {
        let api = createThingIFAPI("test-onboard-with-id-500")
        executeAsynchronous { expectation in
            api.onboardWith(
              thingID: "thing-id",
              thingPassword: "thing-password") { target, error in
                XCTAssertNil(target)
                XCTAssertEqual(
                  error,
                  ThingIFError.errorResponse(
                    required: ErrorResponse(500,
                                            errorCode: "",
                                            errorMessage: "")))
                expectation.fulfill()
            }
        }
    }

    func testOnboardWithThingIDAndOptions() throws {
        let api = createThingIFAPI("test-onboard-with-id-option-success")
        XCTAssertFalse(api.onboarded)
        executeAsynchronous { expectation in
            api.onboardWith(
              thingID: "thing-id",
              thingPassword: "thing-password",
              options: OnboardWithThingIDOptions(.standalone)) {
                target, error in

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

    func testOnboardWithThingIDAndOptions403Error() throws {
        let api = createThingIFAPI("test-onboard-with-id-option-403")
        executeAsynchronous { expectation in
            api.onboardWith(
              thingID: "thing-id",
              thingPassword: "thing-password",
              options: OnboardWithThingIDOptions(.standalone)) {
                target, error in

                XCTAssertNil(target)
                XCTAssertEqual(
                  error,
                  ThingIFError.errorResponse(
                    required: ErrorResponse(403,
                                            errorCode: "",
                                            errorMessage: "")))
                expectation.fulfill()
            }
        }
    }

    func testOnboardWithThingIDAndOptions404Error() throws {
        let api = createThingIFAPI("test-onboard-with-id-option-404")
        executeAsynchronous { expectation in
            api.onboardWith(
              thingID: "thing-id",
              thingPassword: "thing-password",
              options: OnboardWithThingIDOptions(.standalone)) {
                target, error in

                XCTAssertNil(target)
                XCTAssertEqual(
                  error,
                  ThingIFError.errorResponse(
                    required: ErrorResponse(404,
                                            errorCode: "",
                                            errorMessage: "")))
                expectation.fulfill()
            }
        }
    }

    func testOnboardWithThingIDAndOptions500Error() throws {
        let api = createThingIFAPI("test-onboard-with-id-option-500")
        executeAsynchronous { expectation in
            api.onboardWith(
              thingID: "thing-id",
              thingPassword: "thing-password",
              options: OnboardWithThingIDOptions(.standalone)) {
                target, error in

                XCTAssertNil(target)
                XCTAssertEqual(
                  error,
                  ThingIFError.errorResponse(
                    required: ErrorResponse(500,
                                            errorCode: "",
                                            errorMessage: "")))
                expectation.fulfill()
            }
        }
    }

}
