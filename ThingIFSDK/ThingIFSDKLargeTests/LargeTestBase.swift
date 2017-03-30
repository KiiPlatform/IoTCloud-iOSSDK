//
//  LargeTestBase.swift
//  ThingIFSDK
//
//  Created on 2016/05/27.
//  Copyright 2016 Kii. All rights reserved.
//

import XCTest
@testable import ThingIFSDK

class TestSetting: NSObject {
    let appID: String
    let appKey: String
    let hostName: String
    let tag: String?

    override init() {
        let path = Bundle(
                for:TestSetting.self).path(
                       forResource: "TestSetting",
                       ofType:"plist")

        let dict: Dictionary = NSDictionary(
                contentsOfFile: path!) as! Dictionary<String, AnyObject>

        self.appID = dict["appID"] as! String
        self.appKey = dict["appKey"] as! String
        self.hostName = dict["hostName"] as! String
        self.tag = nil
    }
}

class LargeTestBase: XCTestCase {

    internal let TEST_TIMEOUT = 5.0
    internal let DEMO_THING_TYPE = "LED"
    internal let DEMO_SCHEMA_NAME = "SmartLightDemo"
    internal let DEMO_SCHEMA_VERSION = 1

    internal var onboardedApi: ThingIFAPI?
    internal var userInfo: Dictionary<String, AnyObject>?
    internal let setting = TestSetting();

    override func setUp() {
        super.setUp()

        let setting = self.setting
        self.userInfo = createPseudoUser(
                setting.appID,
                appKey: setting.appKey,
                hostName: setting.hostName)
        let userInfo: Dictionary<String, AnyObject> = self.userInfo!
        let owner = Owner(
                TypedID(
                           TypedID.Types(rawValue: "user")!,
                           id: userInfo["userID"]! as! String),
                accessToken: userInfo["_accessToken"]! as! String)
        let app = KiiApp(
          setting.appID,
          appKey: setting.appKey,
          hostName: setting.hostName)
        let api = ThingIFAPI(
          app,
          owner: owner,
          tag: setting.tag)

        let expectation = self.expectation(description: "onboard")

        let vendorThingID = "vid-" + String(Date.init().timeIntervalSince1970)
        api.onboardWith(
          vendorThingID: vendorThingID,
          thingPassword: "password",
          options: OnboardWithVendorThingIDOptions(DEMO_THING_TYPE)) {
            target, error in
            XCTAssertNil(error)
            XCTAssertEqual(.thing, target!.typedID.type)
            XCTAssertNotNil(target!.accessToken)
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: TEST_TIMEOUT) { error in
            XCTAssertNil(error)
        }

        self.onboardedApi = api
    }

    override func tearDown() {
        var triggerIDs: [String] = []
        let api = self.onboardedApi!
        let setting = self.setting
        let userInfo = self.userInfo!

        var expectation = self.expectation(description: "list")

        api.listTriggers(
            100,
            paginationKey: nil,
            completionHandler: {
                triggers, paginationKey, error in
                    if triggers != nil {
                        for trigger in triggers! {
                            triggerIDs.append(trigger.triggerID)
                        }
                    }
                    expectation.fulfill()
            })
        self.waitForExpectations(timeout: TEST_TIMEOUT) { error in
            if error != nil {
                XCTFail("error")
            }
        }

        for triggerID in triggerIDs {
            expectation = self.expectation(description: "delete")
            api.deleteTrigger(triggerID) { deleted, error in
                expectation.fulfill()
            }
            self.waitForExpectations(timeout: TEST_TIMEOUT) { error in
                XCTAssertNil(error)
            }
        }

        deletePseudoUser(
            setting.appID,
            appKey: setting.appKey,
            userID: userInfo["userID"] as! String,
            accessToken: userInfo["_accessToken"] as! String,
            hostName: setting.hostName)

        super.tearDown()
    }

    func createPseudoUser(
            _ appID: String,
            appKey: String,
            hostName: String) -> Dictionary<String, AnyObject>
    {
        var request = URLRequest(
          url: URL(string: "https://\(hostName)/api/apps/\(appID)/users")!)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = [
          "X-Kii-AppID" : appID,
          "X-Kii-AppKey" : appKey,
          "Content-Type" :
            "application/vnd.kii.RegistrationAndAuthorizationRequest+json",
        ]
        request.httpBody =
            ("{}" as NSString).data(using: String.Encoding.utf8.rawValue)

        let expectation = self.expectation(description: "Create user")

        let session =
            URLSession(configuration: URLSessionConfiguration.default)
        var data: Data?
        let dataTask = session.dataTask(with: request) {
            receivedData, response, error in

            data = receivedData
            expectation.fulfill()
        }
        dataTask.resume()
        self.waitForExpectations(timeout: TEST_TIMEOUT) { error in
            XCTAssertNil(error)
        }

        return try! JSONSerialization.jsonObject(
                   with: data!,
                   options:.allowFragments) as! Dictionary<String, AnyObject>
    }

    func deletePseudoUser(
            _ appID: String,
            appKey: String,
            userID: String,
            accessToken: String,
            hostName: String) -> Void
    {
        var request = URLRequest(
          url: URL(string: "https://\(hostName)/api/apps/\(appID)/users/\(userID)")!)
        request.httpMethod = "DELETE"
        request.allHTTPHeaderFields = [
          "X-Kii-AppID" : appID,
          "X-Kii-AppKey" : appKey,
          "Authorization" : "Bearer \(accessToken)"
        ]
        let expectation = self.expectation(description: "Delete user")

        let session =
            URLSession(configuration: URLSessionConfiguration.default)
        let dataTask = session.dataTask(with: request) {
            receivedData, response, error in
            XCTAssertEqual(204, (response as! HTTPURLResponse).statusCode)
            expectation.fulfill()
        }
        dataTask.resume()
        self.waitForExpectations(timeout: TEST_TIMEOUT) { error in
            XCTAssertNil(error)
        }
    }

}
