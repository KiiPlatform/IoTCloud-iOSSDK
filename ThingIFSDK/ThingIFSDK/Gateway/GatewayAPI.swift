//
//  GatewayAPI.swift
//  ThingIFSDK
//
//  Copyright (c) 2016 Kii. All rights reserved.
//

import Foundation

open class GatewayAPI {

    open let tag: String?
    open let app: KiiApp
    open let gatewayAddress: URL
    private var gatewayAddressString: String {
        return self.gatewayAddress.absoluteString
    }

    /** Access token of this gate way */
    open internal(set) var accessToken: String?

    let operationQueue = OperationQueue()

    /** Initialize GatewayAPI.

     If you want to store GatewayAPI instance to storage, you need to
     set tag.

     tag is used to distinguish storage area of instance.  If the api
     instance is tagged with same string, It will be overwritten.  If
     the api instance is tagged with different string, Different key
     is used to store the instance.

     Please refer to `GatewayAPI.loadWithStoredInstance(_:)`

     - Parameter app: Kii Cloud Application.
     - Parameter gatewayAddress: address information for the gateway
     - Parameter tag: tag of the GatewayAPI instance. If null or empty
       String is passed, it will be ignored.
     */
    public init(_ app: KiiApp, gatewayAddress: URL, tag: String? = nil)
    {
        self.tag = tag
        self.app = app
        self.gatewayAddress = gatewayAddress
    }

    // MARK: API methods

    /** Login to the Gateway.
     Local authentication for the Gateway access.
     Required prior to call other APIs access to the gateway.

     - Parameter username: Username of the Gateway.
     - Parameter password: Password of the Gateway.
     - Parameter completionHandler: A closure to be executed once
       finished. The closure takes 1 argument: an instance of
       ThingIFError when failed.
     */
    open func login(
        _ username: String,
        password: String,
        completionHandler: @escaping (ThingIFError?)-> Void) -> Void
    {
        if username.isEmpty || password.isEmpty {
            completionHandler(ThingIFError.unsupportedError)
            return
        }

        let plainData = "\(self.app.appID):\(self.app.appKey)".data(
          using: String.Encoding.utf8)!
        let base64Str = plainData.base64EncodedString(
          options: NSData.Base64EncodingOptions.init(rawValue: 0))

        self.operationQueue.addHttpRequestOperation(
          .post,
          url: "\(self.gatewayAddressString)/\(self.app.siteName)/token",
          requestHeader:
            [
              "Authorization": "Basic " + base64Str,
              "Content-Type": "application/json"
            ],
          requestBody: ["username": username, "password": password],
          failureBeforeExecutionHandler: { completionHandler($0) }) {

            response, error -> Void in
            if error == nil {
                self.accessToken = response?["accessToken"] as? String
                self.saveInstance()
            }
            DispatchQueue.main.async { completionHandler(error) }
        }
    }

    /** Let the Gateway Onboard.

     - Parameter completionHandler: A closure to be executed once finished. The closure takes 2 arguments: 1st one is Gateway instance that has thingID asigned by Kii Cloud and 2nd one is an instance of ThingIFError when failed.
     */
    open func onboardGateway(
        _ completionHandler: @escaping (Gateway?, ThingIFError?)-> Void
        )
    {
        if !self.isLoggedIn() {
            completionHandler(nil, ThingIFError.userIsNotLoggedIn)
            return;
        }

        self.operationQueue.addHttpRequestOperation(
          .post,
          url: "\(self.gatewayAddressString)/\(self.app.siteName)/apps/\(self.app.appID)/gateway/onboarding",
          requestHeader: self.defaultHeader,
          requestBody: nil,
          failureBeforeExecutionHandler: { completionHandler(nil, $0) }) {
            response, error in
            let gateway = response == nil ? nil :
              Gateway(
                response!["thingID"] as! String,
                vendorThingID: response!["vendorThingID"] as! String)
            DispatchQueue.main.async { completionHandler(gateway, error) }
        }
    }

    /** Get Gateway ID

     - Parameter completionHandler: A closure to be executed once get id has finished. The closure takes 2 arguments: 1st one is Gateway ID and 2nd one is an instance of ThingIFError when failed.
     */
    open func getGatewayID(
        _ completionHandler: @escaping (String?, ThingIFError?)-> Void
        )
    {
        if !self.isLoggedIn() {
            completionHandler(nil, ThingIFError.userIsNotLoggedIn)
            return;
        }

        self.operationQueue.addHttpRequestOperation(
            .get,
            url: "\(self.gatewayAddressString)/\(self.app.siteName)/apps/\(self.app.appID)/gateway/id",
            requestHeader: self.defaultHeader,
            requestBody: nil,
            failureBeforeExecutionHandler: { completionHandler(nil, $0) }) {
                response, error in
                DispatchQueue.main.async {
                    completionHandler(response?["thingID"] as? String, error)
                }
        }
    }

    /** List connected end nodes which has been onboarded.

     - Parameter completionHandler: A closure to be executed once get id has finished. The closure takes 2 arguments: 1st one is list of end nodes and 2nd one is an instance of ThingIFError when failed.
     */
    open func listOnboardedEndNodes(
        _ completionHandler: @escaping ([EndNode]?, ThingIFError?)-> Void
        )
    {
        if !self.isLoggedIn() {
            completionHandler(nil, ThingIFError.userIsNotLoggedIn)
            return;
        }

        let requestURL = "\(self.gatewayAddressString)/\(self.app.siteName)/apps/\(self.app.appID)/gateway/end-nodes/onboarded"

        // generate header
        let requestHeaderDict:Dictionary<String, String> = generateAuthBearerHeader()

        // do request
        let request = buildNewRequest(
            HTTPMethod.GET,
            urlString: requestURL,
            requestHeaderDict: requestHeaderDict,
            requestBodyData: nil,
            completionHandler: { (response, error) -> Void in
                var endNodes = [EndNode]()
                if response != nil {
                    if let endNodeArray = response!["results"] as? [NSDictionary] {
                        for endNode in endNodeArray {
                            let thingID = endNode["thingID"] as? String
                            let vendorThingID = endNode["vendorThingID"] as? String
                            endNodes.append(EndNode(thingID!, vendorThingID: vendorThingID!))
                        }
                    }
                }
                DispatchQueue.main.async {
                    if error != nil {
                        completionHandler(nil, error)
                    } else {
                        completionHandler(endNodes, nil)
                    }
                }
            }
        )
        let operation = IoTRequestOperation(request: request)
        operationQueue.addOperation(operation)
    }

    /** List connected end nodes which has not been onboarded.

     - Parameter completionHandler: A closure to be executed once get id has finished. The closure takes 2 arguments: 1st one is list of end nodes connected to the gateway but waiting for onboarding and 2nd one is an instance of ThingIFError when failed.
     */
    open func listPendingEndNodes(
        _ completionHandler: @escaping ([PendingEndNode]?, ThingIFError?)-> Void
        )
    {
        fatalError("TODO: implement me")
        /*
        if !self.isLoggedIn() {
            completionHandler(nil, ThingIFError.userIsNotLoggedIn)
            return;
        }

        let requestURL = "\(self.gatewayAddressString)/\(self.app.siteName)/apps/\(self.app.appID)/gateway/end-nodes/pending"

        // generate header
        let requestHeaderDict:Dictionary<String, String> = generateAuthBearerHeader()

        // do request
        let request = buildNewRequest(
            HTTPMethod.GET,
            urlString: requestURL,
            requestHeaderDict: requestHeaderDict,
            requestBodyData: nil,
            completionHandler: { (response, error) -> Void in
                var endNodes = [PendingEndNode]()
                if response != nil {
                    if let endNodeArray = response!["results"] as? [NSDictionary] {
                        for endNode in endNodeArray {
                            endNodes.append(PendingEndNode(endNode as! Dictionary<String, AnyObject>))
                        }
                    }
                }
                DispatchQueue.main.async {
                    if error != nil {
                        completionHandler(nil, error)
                    } else {
                        completionHandler(endNodes, nil)
                    }
                }
            }
        )
        let operation = IoTRequestOperation(request: request)
        operationQueue.addOperation(operation)
        */
    }

    /** Notify Onboarding completion
     Call this api when the End Node onboarding is done.
     After the call succeeded, End Node will be fully connected to Kii Cloud through the Gateway.

     - Parameter endNode: Onboarded EndNode
     - Parameter completionHandler: A closure to be executed once finished. The closure takes 1 argument: an instance of ThingIFError when failed.
     */
    open func notifyOnboardingCompletion(
        _ endNode: EndNode,
        completionHandler: @escaping (ThingIFError?)-> Void
        )
    {
        if !self.isLoggedIn() {
            completionHandler(ThingIFError.userIsNotLoggedIn)
            return;
        }

        if endNode.thingID.isEmpty || endNode.vendorThingID.isEmpty {
            completionHandler(ThingIFError.unsupportedError)
            return;
        }

        let requestURL = "\(self.gatewayAddressString)/\(self.app.siteName)/apps/\(self.app.appID)/gateway/end-nodes/VENDOR_THING_ID:\(endNode.vendorThingID)"

        // generate header
        var requestHeaderDict:Dictionary<String, String> = generateAuthBearerHeader()
        requestHeaderDict["Content-Type"] = "application/json"

        // genrate body
        let requestBodyDict = NSMutableDictionary(dictionary:
            [
                "thingID": endNode.thingID
            ]
        )

        do {
            let requestBodyData = try JSONSerialization.data(withJSONObject: requestBodyDict, options: JSONSerialization.WritingOptions(rawValue: 0))
            // do request
            let request = buildNewRequest(
                HTTPMethod.PUT,
                urlString: requestURL,
                requestHeaderDict: requestHeaderDict,
                requestBodyData: requestBodyData,
                completionHandler: { (response, error) -> Void in
                    DispatchQueue.main.async {
                        completionHandler(error)
                    }
                }
            )
            let operation = IoTRequestOperation(request: request)
            operationQueue.addOperation(operation)
        } catch(_) {
            kiiSevereLog("ThingIFError.JSON_PARSE_ERROR")
            completionHandler(ThingIFError.jsonParseError)
        }
    }

    /** Restore the Gateway.
     This API can be used only for the Gateway App.

     - Parameter completionHandler: A closure to be executed once finished. The closure takes 1 argument: an instance of ThingIFError when failed.
     */
    open func restore(
        _ completionHandler: @escaping (ThingIFError?)-> Void
        )
    {
        if !self.isLoggedIn() {
            completionHandler(ThingIFError.userIsNotLoggedIn)
            return;
        }

        let requestURL = "\(self.gatewayAddressString)/gateway-app/gateway/restore"

        // generate header
        let requestHeaderDict:Dictionary<String, String> = generateAuthBearerHeader()

        // do request
        let request = buildNewRequest(
            HTTPMethod.post,
            urlString: requestURL,
            requestHeaderDict: requestHeaderDict,
            requestBodyData: nil,
            completionHandler: { (response, error) -> Void in
                DispatchQueue.main.async {
                    completionHandler(error)
                }
            }
        )
        let operation = IoTRequestOperation(request: request)
        operationQueue.addOperation(operation)
    }

    /** Replace end-node by new vendorThingID for end node thingID.

     - Parameter endNodeThingID: ID of the end-node assigned by Kii Cloud.
     - Parameter endNodeVendorThingID: ID of the end-node assigned by End Node vendor.
     - Parameter completionHandler: A closure to be executed once finished. The closure takes 1 argument: an instance of ThingIFError when failed.
     */
    open func replaceEndNode(
        _ endNodeThingID: String,
        endNodeVendorThingID: String,
        completionHandler: @escaping (ThingIFError?)-> Void
        )
    {
        if !self.isLoggedIn() {
            completionHandler(ThingIFError.userIsNotLoggedIn)
            return;
        }

        if endNodeThingID.isEmpty || endNodeVendorThingID.isEmpty {
            completionHandler(ThingIFError.unsupportedError)
            return;
        }

        let requestURL = "\(self.gatewayAddressString)/\(self.app.siteName)/apps/\(self.app.appID)/gateway/end-nodes/THING_ID:\(endNodeThingID)"

        // generate header
        var requestHeaderDict:Dictionary<String, String> = generateAuthBearerHeader()
        requestHeaderDict["Content-Type"] = "application/json"

        // genrate body
        let requestBodyDict = NSMutableDictionary(dictionary:
            [
                "vendorThingID": endNodeVendorThingID
            ]
        )

        do {
            let requestBodyData = try JSONSerialization.data(withJSONObject: requestBodyDict, options: JSONSerialization.WritingOptions(rawValue: 0))
            // do request
            let request = buildNewRequest(
                HTTPMethod.PUT,
                urlString: requestURL,
                requestHeaderDict: requestHeaderDict,
                requestBodyData: requestBodyData,
                completionHandler: { (response, error) -> Void in
                    DispatchQueue.main.async {
                        completionHandler(error)
                    }
                }
            )
            let operation = IoTRequestOperation(request: request)
            operationQueue.addOperation(operation)
        } catch(_) {
            kiiSevereLog("ThingIFError.JSON_PARSE_ERROR")
            completionHandler(ThingIFError.jsonParseError)
        }
    }

    /** Get information of the Gateway.
     When the end user replaces the Gateway, Gateway App/End Node App need to obtain the new Gateway’s vendorThingID.

     - Parameter completionHandler: A closure to be executed once get id has finished. The closure takes 2 arguments: 1st one is information of the Gateway and 2nd one is an instance of ThingIFError when failed.
     */
    open func getGatewayInformation(
        _ completionHandler: @escaping (GatewayInformation?, ThingIFError?)-> Void
        )
    {
        if !self.isLoggedIn() {
            completionHandler(nil, ThingIFError.userIsNotLoggedIn)
            return;
        }

        let requestURL = "\(self.gatewayAddressString)/gateway-info"

        // generate header
        let requestHeaderDict:Dictionary<String, String> = generateAuthBearerHeader()

        // do request
        let request = buildNewRequest(
            HTTPMethod.GET,
            urlString: requestURL,
            requestHeaderDict: requestHeaderDict,
            requestBodyData: nil,
            completionHandler: { (response, error) -> Void in
                let id = response?["vendorThingID"] as? String
                DispatchQueue.main.async {
                    if id == nil {
                        completionHandler(nil, error)
                    } else {
                        completionHandler(GatewayInformation(id!), error)
                    }
                }
            }
        )
        let operation = IoTRequestOperation(request: request)
        operationQueue.addOperation(operation)
    }

    /** Check if user is logged in to the Gateway.

     - Returns: true if user is logged in, false otherwise.
     */
    open func isLoggedIn() -> Bool
    {
        return !(self.accessToken?.isEmpty ?? true)
    }

    @available(iOS, deprecated: 1.0, message: "use defaultHeader")
    private func generateAuthBearerHeader() -> Dictionary<String, String> {
        return [ "authorization": "Bearer \(self.accessToken!)" ]
    }

}

fileprivate extension GatewayAPI {

    var defaultHeader: [String : String] {
        get {
            return [
              "authorization": "Bearer \(self.accessToken!)",
              "X-Kii-SDK" : SDKVersion.sharedInstance.kiiSDKHeader
            ]
        }
    }
}
