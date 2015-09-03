//
//  AutoStoreTest.swift
//  IoTCloudSDK
//
//  Created by Yongping on 9/2/15.
//  Copyright © 2015 Kii. All rights reserved.
//

import XCTest
import IoTCloudSDK

class AutoStoreTests: XCTest {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testInitWithStoredInstance_success() {
        // stored an IoTCloudAPI instance firstly
        let iotAPIToStored = IoTCloudAPI()
        iotAPIToStored.baseURL = "dummy.kii.com"
        iotAPIToStored.appID = "dummyID"
        iotAPIToStored.appKey = "dummyAppKey"
        iotAPIToStored.target = Target(targetType: TypedID(type: "thing", id: "dummyThingID"))
        NSUserDefaults.standardUserDefaults().setObject(NSKeyedArchiver.archivedDataWithRootObject(iotAPIToStored), forKey: "iotAPI")

        // initWithStoredInstance
        do {
            let restoredIotapi = try IoTCloudAPI.initWithStoredInstance()
            XCTAssertEqual(iotAPIToStored.baseURL, restoredIotapi?.baseURL)
            XCTAssertEqual(iotAPIToStored.appID, restoredIotapi?.appID)

        } catch(_){
            XCTFail("should not throw error")
        }
    }
    
}
