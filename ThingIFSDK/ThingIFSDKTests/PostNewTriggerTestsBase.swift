//
//  PostNewTriggerTestsBase.swift
//  ThingIFSDK
//
//  Created on 2016/05/10.
//  Copyright 2016 Kii. All rights reserved.
//

import XCTest

@testable import ThingIFSDK

class PostNewTriggerTestsBase: SmallTestBase {
    override func setUp() {
        super.setUp()
    }
    override func tearDown() {
        super.tearDown()
    }

    struct TestCase {
        let clause: Clause
        let expectedClauseDict: Dictionary<String, AnyObject>?
        let triggersWhen: TriggersWhen
        let expectedTriggersWhenString: String
        let expectedEventSource: String
    }

    func postNewTriggerSuccess(tag: String, testcase: TestCase, setting:TestSetting) {
        weak var expectation : XCTestExpectation!
        defer {
            expectation = nil
        }
        func execPostNewTriggerSuccess(tag: String, testcase: TestCase, setting:TestSetting) {
            expectation = self.expectationWithDescription(tag)

            do{
                let expectedTriggerID = "0267251d9d60-1858-5e11-3dc3-00f3f0b5"
                let actions: [Dictionary<String, AnyObject>] = [["turnPower":["power":true]],["setBrightness":["bribhtness":90]]]
                let condition = Condition(clause: testcase.clause)
                let predicate = StatePredicate(condition: condition, triggersWhen: testcase.triggersWhen)

                let expectedActions = [["turnPower":["power":true]],["setBrightness":["bribhtness":90]]]
                let expectedClause = testcase.expectedClauseDict
                let expectedEventSource = testcase.expectedEventSource
                let expectedTriggerWhen = testcase.expectedTriggersWhenString
                let expectedPredicateDict: Dictionary<String, AnyObject>
                if expectedClause != nil {
                    expectedPredicateDict = ["eventSource":expectedEventSource, "triggersWhen":expectedTriggerWhen, "condition":expectedClause!]
                } else {
                    expectedPredicateDict = ["eventSource":expectedEventSource, "triggersWhen":expectedTriggerWhen]
                }

                // mock response
                let dict = ["triggerID": expectedTriggerID]
                let jsonData = try NSJSONSerialization.dataWithJSONObject(dict, options: .PrettyPrinted)
                let urlResponse = NSHTTPURLResponse(URL: NSURL(string:setting.app.baseURL)!, statusCode: 201, HTTPVersion: nil, headerFields: nil)

                // verify request
                let requestVerifier: ((NSURLRequest) -> Void) = {(request) in
                    XCTAssertEqual(request.HTTPMethod, "POST")
                    //verify header
                    let expectedHeader = ["authorization": "Bearer \(setting.owner.accessToken)", "Content-type":"application/json"]
                    for (key, value) in expectedHeader {
                        XCTAssertEqual(value, request.valueForHTTPHeaderField(key), tag)
                    }
                    //verify body

                    let expectedBody = ["predicate": expectedPredicateDict, "command":["issuer":setting.owner.typedID.toString(), "target": setting.target.typedID.toString(), "schema": setting.schema, "schemaVersion": setting.schemaVersion,"actions":expectedActions, "triggersWhat":"COMMAND"]]
                    do {
                        let expectedBodyData = try NSJSONSerialization.dataWithJSONObject(expectedBody, options: NSJSONWritingOptions(rawValue: 0))
                        let actualBodyData = request.HTTPBody
                        XCTAssertTrue(expectedBodyData.length == actualBodyData!.length, tag)
                    }catch(_){
                        XCTFail(tag)
                    }

                    XCTAssertEqual(request.URL?.absoluteString, setting.app.baseURL + "/thing-if/apps/\(setting.app.appID)/targets/\(setting.target.typedID.toString())/triggers")
                }
                MockSession.mockResponse = (jsonData, urlResponse: urlResponse, error: nil)
                MockSession.requestVerifier = requestVerifier
                iotSession = MockSession.self

                setting.api.postNewTrigger(setting.schema, schemaVersion: setting.schemaVersion, actions: actions, predicate: predicate, completionHandler: { (trigger, error) -> Void in
                    if error == nil{
                        XCTAssertEqual(trigger!.triggerID, expectedTriggerID, tag)
                        XCTAssertEqual(trigger!.enabled, true, tag)
                        XCTAssertNotNil(trigger!.predicate, tag)
                        XCTAssertEqual(trigger!.command!.commandID, "", tag)
                    }else {
                        XCTFail("should success for \(tag)")
                    }
                    expectation.fulfill()
                })
            }catch(let e){
                print(e)
            }
            self.waitForExpectationsWithTimeout(TEST_TIMEOUT) { (error) -> Void in
                if error != nil {
                    XCTFail("execution timeout for \(tag)")
                }
            }
        }
        execPostNewTriggerSuccess(tag, testcase: testcase, setting: setting)
    }

}
