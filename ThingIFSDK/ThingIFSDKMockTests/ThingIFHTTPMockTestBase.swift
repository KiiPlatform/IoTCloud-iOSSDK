//
//  ThingIFHTTPMockTestBase.swift
//  ThingIFSDK
//
//  Created on 2017/06/16.
//  Copyright (c) 2017 Kii. All rights reserved.
//

import XCTest
@testable import ThingIF

class ThingIFHTTPMockTestBase: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    internal func createThingIFAPI(_ testID: String) -> ThingIFAPI {
        let setting = getSetting()
        return ThingIFAPI(
          KiiApp(testID,
                 appKey: "http_mock_key",
                 hostName: setting["address"] as! String,
                 urlSchema: "http",
                 port: setting["port"] as! Int32),
          owner: Owner(TypedID(
                         TypedID.Types.user,
                         id: "owner-id"),
                       accessToken: "accesstoken"))
    }

    private func getSetting() -> [String : Any] {
        return NSDictionary(
          contentsOfFile: Bundle(
            for: ThingIFHTTPMockTestBase.self).path(forResource: "setting",
                                                    ofType: "plist")!)
          as! [String : Any]
    }

}
