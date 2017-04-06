//
//  ThingIFAPIGetFirmwareVersionTests.swift
//  ThingIFSDK
//
//  Copyright (c) 2017 Kii. All rights reserved.
//

import XCTest
@testable import ThingIFSDK

class ThingIFAPIGetFirmwareVersionTests: NotOnboardedYetTestsBase
{
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testSuccess() {
        let vendorThingID = "vid-" + String(Date().timeIntervalSince1970)
        let password = "password-1"

        self.executeAsynchronous { expectation in
            let vendorThingIdOptions = OnboardWithVendorThingIDOptions(
                self.DEFAULT_THING_TYPE,
                firmwareVersion: self.DEFAULT_FIRMWAREVERSION,
                position: .standalone)
            self.api?.onboardWith(
                vendorThingID: vendorThingID,
                thingPassword: password,
                options: vendorThingIdOptions) { target, error in
                    defer {
                        expectation.fulfill()
                    }
                    XCTAssertNil(error)
                    XCTAssertNotNil(target)
                    XCTAssertEqual(.thing, target!.typedID.type)
                    XCTAssertNotEqual(target!.accessToken, nil)
            }
        }

        self.executeAsynchronous { expectation in
            self.api.getFirmwareVersion { version, error in
                defer {
                    expectation.fulfill()
                }
                XCTAssertNil(error)
                XCTAssertEqual(self.DEFAULT_FIRMWAREVERSION, version)
            }
        }
    }

    func testSuccessGotNil() {
        let vendorThingID = "vid-" + String(Date().timeIntervalSince1970)
        let password = "password-1"

        self.executeAsynchronous { expectation in
            let vendorThingIdOptions = OnboardWithVendorThingIDOptions(
                self.DEFAULT_THING_TYPE,
                position: .standalone)
            self.api?.onboardWith(
                vendorThingID: vendorThingID,
                thingPassword: password,
                options: vendorThingIdOptions) { target, error in
                    defer {
                        expectation.fulfill()
                    }
                    XCTAssertNil(error)
                    XCTAssertNotNil(target)
                    XCTAssertEqual(.thing, target!.typedID.type)
                    XCTAssertNotEqual(target!.accessToken, nil)
            }
        }

        self.executeAsynchronous { expectation in
            self.api.getFirmwareVersion { version, error in
                defer {
                    expectation.fulfill()
                }
                XCTAssertNil(error)
                XCTAssertNil(version)
            }
        }
    }
}
