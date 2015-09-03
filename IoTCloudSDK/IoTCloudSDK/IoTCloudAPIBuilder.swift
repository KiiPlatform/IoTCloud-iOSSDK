//
//  IoTCloudAPIBuilder.swift
//  IoTCloudSDK
//

import Foundation

/** Builder class of IoTCloudAPI */
public class IoTCloudAPIBuilder {

    var iotCloudAPI: IoTCloudAPI!

    /** Initialize builder.
    - Parameter appID: ID of the application published by Kii Cloud.
    - Parameter appKey: Key of the application published by Kii Cloud.
    - Parameter baseURL: URL of the Site.
    - Parameter owner: Owner who consumes IoTCloudAPI.
     */
    public init(appID: String, appKey: String, baseURL: String, owner: Owner) {

        iotCloudAPI = IoTCloudAPI(baseURL: baseURL, appID: appID, appKey: appKey, owner: owner)
        iotCloudAPI._storeSelf()
    }

    /** Build IoTCloudAPI instance.
    - Returns: IoTCloudAPI instance.
     */
    public func build() -> IoTCloudAPI {
        return iotCloudAPI
    }
}