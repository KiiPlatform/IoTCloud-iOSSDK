//
//  IoTCloudAPI+storedInstance.swift
//  IoTCloudSDK
//
//  Created by Yongping on 9/2/15.
//  Copyright © 2015 Kii. All rights reserved.
//

import Foundation

extension IoTCloudAPI {

    class func _getStoredInstance() throws -> IoTCloudAPI? {
        var iotAPI: IoTCloudAPI?

        if let iotAPIData = userDefaults.objectForKey("iotAPI") as? NSData {
            if let storedIoTAPI = NSKeyedUnarchiver.unarchiveObjectWithData(iotAPIData) as? IoTCloudAPI {
                iotAPI = storedIoTAPI
            }else {
                throw IoTCloudError.STORED_IOTAPI_INVALID
            }
        }else {
            throw IoTCloudError.STORED_IOTAPI_NOT_AVAILABLE
        }

        return iotAPI
    }

    func _storeSelf() {
        IoTCloudAPI.userDefaults.setObject(NSKeyedArchiver.archivedDataWithRootObject(self), forKey: "iotAPI")
    }


}
