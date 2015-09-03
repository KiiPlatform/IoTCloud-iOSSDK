//
//  AutoStoreTest.swift
//  IoTCloudSDK
//
//  Created by Yongping on 9/2/15.
//  Copyright © 2015 Kii. All rights reserved.
//

import XCTest
@testable import IoTCloudSDK

class AutoStoreTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        IoTCloudAPI.userDefaults = NSUserDefaults.standardUserDefaults()
        super.tearDown()
    }

    func testInitWithStoredInstance_success() {
        // stored an IoTCloudAPI instance firstly
        let iotAPIToStored = IoTCloudAPI()
        iotAPIToStored.baseURL = "dummy.kii.com"
        iotAPIToStored.appID = "dummyID"
        iotAPIToStored.appKey = "dummyAppKey"
        iotAPIToStored.target = Target(targetType: TypedID(type: "thing", id: "dummyThingID"))
        iotAPIToStored.owner = Owner(ownerID: TypedID(type:"user", id:"53ae324be5a0-2b09-5e11-6cc3-0862359e"), accessToken: "BbBFQMkOlEI9G1RZrb2Elmsu5ux1h-TIm5CGgh9UBMc")
        let mockSuit = NSUserDefaults(suiteName: "testInitWithStoredInstance_success")!
        IoTCloudAPI.userDefaults = mockSuit
        mockSuit.setObject(NSKeyedArchiver.archivedDataWithRootObject(iotAPIToStored), forKey: "iotAPI")

        // initWithStoredInstance
        do {
            let restoredIotapi = try IoTCloudAPI.initWithStoredInstance()
            XCTAssertEqual(iotAPIToStored.baseURL, restoredIotapi?.baseURL)
            XCTAssertEqual(iotAPIToStored.appID, restoredIotapi?.appID)
            XCTAssertEqual(iotAPIToStored.target?.targetType.toString(), restoredIotapi?.target?.targetType.toString())
            XCTAssertEqual(iotAPIToStored.owner.ownerID.toString(), restoredIotapi?.owner.ownerID.toString())
            XCTAssertEqual(iotAPIToStored.owner.accessToken, restoredIotapi?.owner.accessToken)

        } catch(_){
            XCTFail("should not throw error")
        }
    }

    func testInitWithStoredInstance_stored_iotapi_instance_not_available() {
        // stored an IoTCloudAPI instance firstly
        let mockSuit = NSUserDefaults(suiteName: "testInitWithStoredInstance_stored_iotapi_instance_not_available")!
        IoTCloudAPI.userDefaults = mockSuit
        mockSuit.setObject("string", forKey: "iotAPI")
        // initWithStoredInstance
        do {

            try IoTCloudAPI.initWithStoredInstance()
            XCTFail("should throw error")

        } catch(let e){
            if let cloudError = e as? IoTCloudError {
                switch cloudError {
                    case .STORED_IOTAPI_NOT_AVAILABLE:
                        break
                default:
                    XCTFail("error should be STORED_IOTAPI_NOT_AVAILABLE")
                }
            }else{
                XCTFail("error should be IoTCloudError.STORED_IOTAPI_NOT_AVAILABLE")
            }
        }
    }

    func testInitWithStoredInstance_stored_iotapi_instance_invalid() {
        // stored an IoTCloudAPI instance firstly

        let mockSuit = NSUserDefaults(suiteName: "testInitWithStoredInstance_stored_iotapi_instance_not_available")!
        IoTCloudAPI.userDefaults = mockSuit

        mockSuit.setObject(NSKeyedArchiver.archivedDataWithRootObject(["key":"value"]), forKey: "iotAPI")

        // initWithStoredInstance
        do {

            try IoTCloudAPI.initWithStoredInstance()
            XCTFail("should throw error")

        } catch(let e){
            if let cloudError = e as? IoTCloudError {
                switch cloudError {
                case .STORED_IOTAPI_INVALID:
                    break
                default:
                    XCTFail("error should be STORED_IOTAPI_INVALID")
                }
            }else{
                XCTFail("error should be IoTCloudError.STORED_IOTAPI_INVALID")
            }
        }
    }

}
