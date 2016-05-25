//
//  GatewayAPITestBase.swift
//  ThingIFSDK
//
//  Copyright (c) 2016 Kii. All rights reserved.
//

import XCTest
@testable import ThingIFSDK

class GatewayAPITestBase: SmallTestBase {
    let ACCESSTOKEN: String = "token-0000-1111-aaaa-bbbb"

    func getLoggedInGatewayAPI() -> GatewayAPI {
        self.continueAfterFailure = false
        let expectation = self.expectationWithDescription("getLoggedInGatewayAPI")
        let setting = TestSetting()

        do {
            let dict = ["accessToken": ACCESSTOKEN]
            let jsonData = try NSJSONSerialization.dataWithJSONObject(dict, options: .PrettyPrinted)
            let urlResponse = NSHTTPURLResponse(URL: NSURL(string:setting.app.baseURL)!,
                statusCode: 200, HTTPVersion: nil, headerFields: nil)
        
            MockSession.mockResponse = (jsonData, urlResponse: urlResponse, error: nil)
            iotSession = MockSession.self
        } catch(_) {
            XCTFail("should not throw error")
        }

        let gatewayAPI = GatewayAPI(app: setting.app, gatewayAddress: NSURL(string: setting.app.baseURL)!)
        gatewayAPI.login("dummy", password: "dummy", completionHandler: { (error:ThingIFError?) -> Void in
            XCTAssertNil(error)
            expectation.fulfill()
        })

        self.waitForExpectationsWithTimeout(TEST_TIMEOUT) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }

        return gatewayAPI
    }
}
