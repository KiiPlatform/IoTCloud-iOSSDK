//
//  PostNewTriggerTests.swift
//  ThingIFSDK
//
//  Created by Yongping on 8/14/15.
//  Copyright © 2015 Kii. All rights reserved.
//

import XCTest
@testable import ThingIFSDK

class PostNewTriggerTests: PostNewTriggerTestsBase {

    override func setUp() {
        super.setUp()
    }
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    struct StateTestCase: TestCase{
        let clause: Clause
        let expectedClauseDict: Dictionary<String, AnyObject>
        let triggersWhen: TriggersWhen
        let expectedTriggersWhenString: String
        let expectedEventSource: String
    }

    override func createPredicate(testcase: TestCase) -> Predicate? {
        let stateTestCase = testcase as! StateTestCase
        let condition = Condition(clause: stateTestCase.clause)
        return StatePredicate(condition: condition, triggersWhen: stateTestCase.triggersWhen)
    }

    override func createExpectedPredicate(testcase: TestCase) -> Dictionary<String, AnyObject>? {
        let stateTestCase = testcase as! StateTestCase
        let expectedClause = stateTestCase.expectedClauseDict
        let expectedEventSource = stateTestCase.expectedEventSource
        let expectedTriggerWhen = stateTestCase.expectedTriggersWhenString
        let expectedPredicateDict: Dictionary<String, AnyObject> =
            ["eventSource":expectedEventSource, "triggersWhen":expectedTriggerWhen, "condition":expectedClause]
        return expectedPredicateDict
    }


    func testPostNewTrigger_success() {
        let setting = TestSetting()
        let api = setting.api
        let target = setting.target
        // perform onboarding
        api._target = target

        let orClauseClause = ["type": "or", "clauses": [["type":"eq","field":"color", "value": 0], ["type": "not", "clause": ["type":"eq","field":"power", "value": true]] ]]
        let andClauseClause = ["type": "and", "clauses": [["type":"eq","field":"color", "value": 0], ["type": "not", "clause": ["type":"eq","field":"power", "value": true]] ]]
        let complexExpectedClauses:[Dictionary<String, AnyObject>] = [
            ["type": "and", "clauses": [["type":"eq","field":"brightness", "value": 50], orClauseClause]],
            ["type": "or", "clauses": [["type":"eq","field":"brightness", "value": 50], andClauseClause]]
        ]

        let testsCases: [TestCase] = [
            // simple clause
            StateTestCase(clause: EqualsClause(field: "color", intValue: 0), expectedClauseDict: ["type":"eq","field":"color", "value": 0], triggersWhen: TriggersWhen.CONDITION_FALSE_TO_TRUE, expectedTriggersWhenString: "CONDITION_FALSE_TO_TRUE", expectedEventSource: "STATES"),
            StateTestCase(clause: EqualsClause(field: "power", boolValue: true), expectedClauseDict: ["type":"eq","field":"power", "value": true], triggersWhen: TriggersWhen.CONDITION_FALSE_TO_TRUE, expectedTriggersWhenString: "CONDITION_FALSE_TO_TRUE", expectedEventSource: "STATES"),
            StateTestCase(clause: NotEqualsClause(field: "power", boolValue: true), expectedClauseDict: ["type": "not", "clause": ["type":"eq","field":"power", "value": true]], triggersWhen: TriggersWhen.CONDITION_FALSE_TO_TRUE, expectedTriggersWhenString: "CONDITION_FALSE_TO_TRUE", expectedEventSource: "STATES"),
            StateTestCase(clause: RangeClause(field: "color", upperLimitInt: 255, upperIncluded:true), expectedClauseDict: ["type": "range", "field": "color", "upperLimit": 255, "upperIncluded": true], triggersWhen: TriggersWhen.CONDITION_FALSE_TO_TRUE, expectedTriggersWhenString: "CONDITION_FALSE_TO_TRUE", expectedEventSource: "STATES"),
            StateTestCase(clause: RangeClause(field: "color", upperLimitInt: 200, upperIncluded: false), expectedClauseDict: ["type": "range", "field": "color", "upperLimit": 200, "upperIncluded": false], triggersWhen: TriggersWhen.CONDITION_FALSE_TO_TRUE, expectedTriggersWhenString: "CONDITION_FALSE_TO_TRUE", expectedEventSource: "STATES"),
            StateTestCase(clause: RangeClause(field: "color", upperLimitDouble: 200.345, upperIncluded: false), expectedClauseDict: ["type": "range", "field": "color", "upperLimit": 200.345, "upperIncluded": false], triggersWhen: TriggersWhen.CONDITION_FALSE_TO_TRUE, expectedTriggersWhenString: "CONDITION_FALSE_TO_TRUE", expectedEventSource: "STATES"),
            StateTestCase(clause: RangeClause(field: "color", lowerLimitInt: 1, lowerIncluded: true), expectedClauseDict: ["type": "range", "field": "color", "lowerLimit": 1, "lowerIncluded": true], triggersWhen: TriggersWhen.CONDITION_FALSE_TO_TRUE, expectedTriggersWhenString: "CONDITION_FALSE_TO_TRUE", expectedEventSource: "STATES"),
            StateTestCase(clause: RangeClause(field: "color", lowerLimitInt: 1, lowerIncluded: false), expectedClauseDict: ["type": "range", "field": "color", "lowerLimit": 1, "lowerIncluded": false], triggersWhen: TriggersWhen.CONDITION_FALSE_TO_TRUE, expectedTriggersWhenString: "CONDITION_FALSE_TO_TRUE", expectedEventSource: "STATES"),
            StateTestCase(clause: RangeClause(field: "color", lowerLimitDouble: 1.345, lowerIncluded: false), expectedClauseDict: ["type": "range", "field": "color", "lowerLimit": 1.345, "lowerIncluded": false], triggersWhen: TriggersWhen.CONDITION_FALSE_TO_TRUE, expectedTriggersWhenString: "CONDITION_FALSE_TO_TRUE", expectedEventSource: "STATES"),
            StateTestCase(clause: RangeClause(field: "color", lowerLimitInt: 1, lowerIncluded: true, upperLimit: 345, upperIncluded: true), expectedClauseDict: ["type": "range", "field": "color", "lowerLimit": 1, "lowerIncluded": true, "upperLimit": 345, "upperIncluded": true], triggersWhen: TriggersWhen.CONDITION_FALSE_TO_TRUE, expectedTriggersWhenString: "CONDITION_FALSE_TO_TRUE", expectedEventSource: "STATES"),
            StateTestCase(clause: RangeClause(field: "color", lowerLimitDouble: 1.1, lowerIncluded: true, upperLimit: 345.3, upperIncluded: true), expectedClauseDict: ["type": "range", "field": "color", "lowerLimit": 1.1, "lowerIncluded": true, "upperLimit": 345.3, "upperIncluded": true], triggersWhen: TriggersWhen.CONDITION_FALSE_TO_TRUE, expectedTriggersWhenString: "CONDITION_FALSE_TO_TRUE", expectedEventSource: "STATES"),
            StateTestCase(clause: AndClause(clauses: EqualsClause(field: "color", intValue: 0), NotEqualsClause(field: "power", boolValue: true)), expectedClauseDict: ["type": "and", "clauses": [["type":"eq","field":"color", "value": 0], ["type": "not", "clause": ["type":"eq","field":"power", "value": true]] ]], triggersWhen: TriggersWhen.CONDITION_FALSE_TO_TRUE, expectedTriggersWhenString: "CONDITION_FALSE_TO_TRUE", expectedEventSource: "STATES"),
            StateTestCase(clause: OrClause(clauses: EqualsClause(field: "color", intValue: 0), NotEqualsClause(field: "color", boolValue: true)), expectedClauseDict: ["type": "or", "clauses": [["type":"eq","field":"color", "value": 0], ["type": "not", "clause": ["type":"eq","field":"power", "value": true]] ]], triggersWhen: TriggersWhen.CONDITION_FALSE_TO_TRUE, expectedTriggersWhenString: "CONDITION_FALSE_TO_TRUE", expectedEventSource: "STATES"),
            // complex clauses
            StateTestCase(clause: AndClause(clauses: EqualsClause(field: "brightness", intValue: 50), OrClause(clauses: EqualsClause(field: "color", intValue:  0), NotEqualsClause(field: "power", boolValue: true))), expectedClauseDict: complexExpectedClauses[0], triggersWhen: TriggersWhen.CONDITION_FALSE_TO_TRUE, expectedTriggersWhenString: "CONDITION_FALSE_TO_TRUE", expectedEventSource: "STATES"),
            StateTestCase(clause: OrClause(clauses: EqualsClause(field: "brightness", intValue: 50),AndClause(clauses: EqualsClause(field: "color", intValue: 0), NotEqualsClause(field: "power", boolValue: true))), expectedClauseDict: complexExpectedClauses[1], triggersWhen: TriggersWhen.CONDITION_FALSE_TO_TRUE, expectedTriggersWhenString: "CONDITION_FALSE_TO_TRUE", expectedEventSource: "STATES"),
            // test triggersWhen
            StateTestCase(clause: EqualsClause(field: "color", intValue: 0), expectedClauseDict: ["type":"eq","field":"color", "value": 0], triggersWhen: TriggersWhen.CONDITION_CHANGED, expectedTriggersWhenString: "CONDITION_CHANGED", expectedEventSource: "STATES"),
            StateTestCase(clause: EqualsClause(field: "color", intValue: 0), expectedClauseDict: ["type":"eq","field":"color", "value": 0], triggersWhen: TriggersWhen.CONDITION_TRUE, expectedTriggersWhenString: "CONDITION_TRUE", expectedEventSource: "STATES")

        ]
        for (index,testCase) in testsCases.enumerate() {
            postNewTriggerSuccess("testPostNewTrigger_success_\(index)", testcase: testCase, setting: setting)
        }

    }


    func testPostNewTrigger_http_404() {
        let expectation = self.expectationWithDescription("postNewTrigger404Error")
        let setting = TestSetting()
        let api = setting.api
        let target = setting.target
        let owner = setting.owner
        let schema = setting.schema
        let schemaVersion = setting.schemaVersion

        // perform onboarding
        api._target = target

        do{
            let actions: [Dictionary<String, AnyObject>] = [["turnPower":["power":true]],["setBrightness":["bribhtness":90]]]
            let clause = EqualsClause(field: "color", intValue: 0)
            let condition = Condition(clause: clause)
            let predicate = StatePredicate(condition: condition, triggersWhen: TriggersWhen.CONDITION_FALSE_TO_TRUE)

            let expectedClause = ["type":"eq","filed":"color", "value": 0]
            let expectedEventSource = "STATES"
            let expectedTriggerWhen = "CONDITION_FALSE_TO_TRUE"
            let expectedPredicateDict = ["eventSource":expectedEventSource, "triggersWhen":expectedTriggerWhen, "condition":expectedClause]

            // mock response
            let responsedDict = ["errorCode" : "TARGET_NOT_FOUND",
                "message" : "Target \(target.typedID.toString()) not found"]
            let jsonData = try NSJSONSerialization.dataWithJSONObject(responsedDict, options: .PrettyPrinted)
            let urlResponse = NSHTTPURLResponse(URL: NSURL(string:setting.app.baseURL)!, statusCode: 404, HTTPVersion: nil, headerFields: nil)

            // verify request
            let requestVerifier: ((NSURLRequest) -> Void) = {(request) in
                XCTAssertEqual(request.HTTPMethod, "POST")
                //verify header
                let expectedHeader = ["authorization": "Bearer \(owner.accessToken)", "Content-type":"application/json"]
                for (key, value) in expectedHeader {
                    XCTAssertEqual(value, request.valueForHTTPHeaderField(key))
                }
                //verify body

                let expectedBody = ["predicate": expectedPredicateDict, "command":["issuer":owner.typedID.toString(), "target": target.typedID.toString(), "schema": schema, "schemaVersion": schemaVersion,"actions":actions, "triggersWhat":"COMMAND"]]
                do {
                    let expectedBodyData = try NSJSONSerialization.dataWithJSONObject(expectedBody, options: NSJSONWritingOptions(rawValue: 0))
                    let actualBodyData = request.HTTPBody
                    XCTAssertTrue(expectedBodyData.length == actualBodyData!.length)
                }catch(_){
                    XCTFail()
                }
            }
            MockSession.mockResponse = (jsonData, urlResponse: urlResponse, error: nil)
            MockSession.requestVerifier = requestVerifier
            iotSession = MockSession.self

            api.postNewTrigger(schema, schemaVersion: schemaVersion, actions: actions, predicate: predicate, completionHandler: { (trigger, error) -> Void in
                if error == nil{
                    XCTFail("should fail")
                }else {
                    switch error! {
                    case .CONNECTION:
                        XCTFail("should not be connection error")
                    case .ERROR_RESPONSE(let actualErrorResponse):
                        XCTAssertEqual(404, actualErrorResponse.httpStatusCode)
                        XCTAssertEqual(responsedDict["errorCode"]!, actualErrorResponse.errorCode)
                        XCTAssertEqual(responsedDict["message"]!, actualErrorResponse.errorMessage)
                    default:
                        break
                    }
                }
                expectation.fulfill()
            })
        }catch(let e){
            print(e)
        }
        self.waitForExpectationsWithTimeout(TEST_TIMEOUT) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
    }

    func testPostNewTrigger_UnsupportError() {
        let expectation = self.expectationWithDescription("postNewTriggerUnsupportError")
        let setting = TestSetting()
        let api = setting.api
        let schema = setting.schema
        let schemaVersion = setting.schemaVersion

        let actions: [Dictionary<String, AnyObject>] = [["turnPower":["power":true]],["setBrightness":["bribhtness":90]]]
        let predicate = SchedulePredicate(schedule: "'*/15 * * * *")

        api.postNewTrigger(schema, schemaVersion: schemaVersion, actions: actions, predicate: predicate, completionHandler: { (trigger, error) -> Void in
            if error == nil{
                XCTFail("should fail")
            }else {
                switch error! {
                case .UNSUPPORTED_ERROR:
                    break
                default:
                    XCTFail("should be unsupport error")
                }
            }
            expectation.fulfill()
        })

        self.waitForExpectationsWithTimeout(TEST_TIMEOUT) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
    }
    
    func testPostTrigger_target_not_available_error() {
        let expectation = self.expectationWithDescription("testPostTrigger_target_not_available_error")
        let setting = TestSetting()
        let api = setting.api
        let schema = setting.schema
        let schemaVersion = setting.schemaVersion

        let actions: [Dictionary<String, AnyObject>] = [["turnPower":["power":true]],["setBrightness":["bribhtness":90]]]
        let predicate = StatePredicate(condition: Condition(clause: EqualsClause(field: "color", intValue: 0)), triggersWhen: TriggersWhen.CONDITION_FALSE_TO_TRUE)

        api.postNewTrigger(schema, schemaVersion: schemaVersion, actions: actions, predicate: predicate, completionHandler: { (trigger, error) -> Void in
            if error == nil{
                XCTFail("should fail")
            }else {
                switch error! {
                case .TARGET_NOT_AVAILABLE:
                    break
                default:
                    XCTFail("should be TARGET_NOT_AVAILABLE")
                }
            }
            expectation.fulfill()
        })

        self.waitForExpectationsWithTimeout(TEST_TIMEOUT) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
    }
}
