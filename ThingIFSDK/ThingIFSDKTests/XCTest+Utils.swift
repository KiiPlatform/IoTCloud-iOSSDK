//
//  XCTest+Utils.swift
//  ThingIFSDK
//
//  Created by Syah Riza on 8/14/15.
//  Copyright © 2015 Kii. All rights reserved.
//

import Foundation
import XCTest
@testable import ThingIFSDK

extension XCTestCase {

    func verifyAnyObject(
      _ expected: AnyObject?,
      _ actual: AnyObject?,
      _ message: String = "no message")
    {
        if expected === actual {
            return
        }

        guard let expected2 = expected else {
            XCTFail("\(message): expected is nil but actual is not nil.")
            return
        }
        guard let actual2 = actual else {
            XCTFail("\(message): expected is not nil but actual is nil.")
            return
        }

        if expected2 is String && actual2 is String {
            XCTAssertEqual(
              expected2 as! String,
              actual2 as! String,
              message)
            return
        } else if expected2 is NSNumber && actual2 is NSNumber {
            XCTAssertEqual(
              expected2 as! NSNumber,
              actual2 as! NSNumber,
              message)
            return
        }

        XCTFail("\(message): expected class=\(NSStringFromClass(type(of: expected!))), actual class\(NSStringFromClass(type(of: actual!)))")
    }

    func verifyArray(_ expected: [Any]?,
                     actual: [Any]?,
                     message: String? = nil)
    {
        if expected == nil && actual == nil {
            return
        }
        guard let expected2 = expected, let actual2 = actual else {
            XCTFail("one of expected or actual is nil")
            return
        }

        let error_message: String
        if let message2 = message {
            error_message = message2 + ", expected=" + expected2.description +
              "actual=" + actual2.description
        } else {
            error_message = "expected=" + expected2.description +
              "actual=" + actual2.description
        }
        XCTAssertEqual(NSArray(array: expected2), NSArray(array: actual2),
                      error_message)
    }
    
    func verifyDict2(_ expectedDict:Dictionary<String, Any>?, _ actualDict: Dictionary<String, Any>?, _ errorMessage: String? = nil){
        if expectedDict == nil && actualDict == nil {
            return
        }
        verifyDict(expectedDict!,
                   actualDict: actualDict,
                   errorMessage: errorMessage)
    }

    func verifyDict(_ expectedDict:Dictionary<String, Any>, actualDict: Dictionary<String, Any>?, errorMessage: String? = nil){
        guard let actualDict2 = actualDict else {
            XCTFail("actualDict must not be nil")
            return
        }

        let s: String
        if let message = errorMessage {
            s = message + ", expected=" +
              expectedDict.description + "actual" + actualDict2.description
        } else {
            s = "expected=" + expectedDict.description +
              "actual" + actualDict2.description
        }
        XCTAssertTrue(NSDictionary(dictionary: expectedDict).isEqual(to: actualDict2), s)
    }
    func verifyNsDict(_ expectedDict:NSDictionary, actualDict:NSDictionary){
        let s = "expected=" + expectedDict.description + "actual" + actualDict.description
        XCTAssertTrue(expectedDict.isEqual(to: actualDict as! [AnyHashable: Any]), s)
    }
    
    func verifyDict(_ expectedDict:Dictionary<String, Any>, actualData: Data){
        
        do{
            let actualDict: NSDictionary = try JSONSerialization.jsonObject(with: actualData, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
            let s = "\nexpected=" + expectedDict.description + "\nactual" + actualDict.description
            XCTAssertTrue(NSDictionary(dictionary: expectedDict).isEqual(to: actualDict as! [AnyHashable: Any]), s)
        }catch(_){
            XCTFail()
        }
    }

    func XCTAssertEqualDictionaries<S, T: Equatable>(_ first: [S:T], _ second: [S:T]) {
        XCTAssert(first == second)
    }

    func XCTAssertEqualIoTAPIWithoutTarget(_ first: ThingIFAPI, _ second: ThingIFAPI) {
        XCTAssertEqual(first.appID, second.appID)
        XCTAssertEqual(first.appKey, second.appKey)
        XCTAssertEqual(first.baseURL, second.baseURL)
        XCTAssertEqual(first.installationID, second.installationID)
    }
}
