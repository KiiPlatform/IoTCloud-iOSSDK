//
//  MockServerTests.swift
//  ThingIFSDK
//
//  Created on 2017/06/14.
//  Copyright (c) 2017 Kii. All rights reserved.
//

import XCTest
@testable import ThingIF

class PathGetter: NSObject {

    fileprivate var path: String? {
        get {
            return Bundle(for: PathGetter.self).path(
              forResource: "ipaddr",
              ofType:"plist")
        }
    }

}
class MockServerTests: XCTestCase {

    var api: ThingIFAPI!

    override func setUp() {
        let dict =
          NSDictionary(contentsOfFile: PathGetter().path!) as! [String : String]

        api = ThingIFAPI(
          KiiApp("wire_mock_app_id",
                 appKey: "wire_mock_app_key",
                 hostName: dict["IP"]!,
                 urlSchema: "http",
                 port: 1080),
          owner: Owner(TypedID(
                         TypedID.Types.user,
                         id: "my-owner-id"),
                       accessToken: "owner-access-token-1234"),
          target: StandaloneThing("thing-id",
                                  vendorThingID: "vendor-thing-id",
                                  accessToken: "access-token"));
        super.setUp();
    }

    func testGetCommand() throws {
        self.executeAsynchronous { expectation in
            self.api.getCommand("XXXXXXXX") { command, error in
                XCTAssertNil(error)
                XCTAssertNotNil(command);
                let cmd = command!
                XCTAssertEqual("XXXXXXXX", cmd.commandID);
                XCTAssertEqual(CommandState.done, cmd.commandState)
                // TODO: check more.
                expectation.fulfill()
            }
        }
    }

    func testPostNewCommand() throws {
        self.executeAsynchronous { expectation in
            self.api.postNewCommand(
              CommandForm(
                [
                  AliasAction("AirConditionerAlias",
                              actions: Action("turnPower", value: true))
                ])) { command, error in
                  XCTAssertNil(error)
                  XCTAssertNotNil(command);
                  let cmd = command!
                  XCTAssertEqual("YYYYYYYY", cmd.commandID);
                  XCTAssertEqual(CommandState.sending, cmd.commandState)
                  // TODO: check more.
                  expectation.fulfill()
            }
        }
    }
}
