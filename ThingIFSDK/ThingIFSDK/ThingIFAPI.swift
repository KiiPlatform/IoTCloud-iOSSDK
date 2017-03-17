//
//  ThingIFAPI.swift
//  ThingIFSDK
//

import Foundation

/** Class provides API of the ThingIF. */
open class ThingIFAPI: Equatable {

    /** Tag of the ThingIFAPI instance */
    open let tag : String?

    let operationQueue = OperationQueue()
    /** URL of KiiApps Server */
    open var baseURL: String {
        get {
            return self.app.baseURL
        }
    }
    /** The application ID found in your Kii developer console */
    open var appID: String {
        get {
            return self.app.appID
        }
    }
    /** The application key found in your Kii developer console */
    open var appKey: String {
        get {
            return self.app.appKey
        }
    }
    /** Kii Cloud Application */
    open let app: KiiApp
    /** owner of target */
    open let owner: Owner

    /** Get installationID if the push is already installed.
    null will be returned if the push installation has not been done.

    - Returns: Installation ID used in IoT Cloud.
    */
    open internal(set) var installationID: String?

    /** target */
    open internal(set) var target: Target?

    /** Checks whether on boarding is done. */
    open var onboarded: Bool {
        get {
            return self.target != nil
        }
    }

    /** Initialize `ThingIFAPI` instance.

     - Parameter app: Kii Cloud Application.
     - Parameter owner: Owner who consumes ThingIFAPI.
     - Parameter target: target of the ThingIFAPI instance.
     - Parameter tag: tag of the ThingIFAPI instance.
     */
    public init(
      _ app: KiiApp,
      owner: Owner,
      target: Target? = nil,
      tag : String? = nil)
    {
        self.app = app
        self.owner = owner
        self.target = target
        self.tag = tag
    }

    // MARK: - Push notification methods

    /** Install push notification to receive notification from IoT Cloud.
    IoT Cloud will send notification when the Target replies to the Command.
    Application can receive the notification and check the result of Command
    fired by Application or registered Trigger.
    After installation is done Installation ID is managed in this class.

    - Parameter deviceToken: NSData instance of device token for APNS.
    - Parameter development: flag indicate whether the cert is development or
    production. This is optional, the default is false (production).
    - Parameter completionHandler: A closure to be executed once on board has finished.
    */
    open func installPush(
        _ deviceToken:Data,
        development:Bool?=false,
        completionHandler: @escaping (String?, ThingIFError?)-> Void
        )
    {
        _installPush(deviceToken, development: development) { (token, error) -> Void in
            if error == nil {
                self.saveToUserDefault()
            }
            completionHandler(token, error)
        }
    }
    
    /** Uninstall push notification.
    After done, notification from IoT Cloud won't be notified.

    - Parameter installationID: installation ID returned from installPush().
    If null is specified, value of the installationID property is used.
    */
    open func uninstallPush(
        _ installationID:String?,
        completionHandler: @escaping (ThingIFError?)-> Void
        )
    {
        _uninstallPush(installationID, completionHandler: completionHandler)
    }
    

    // MARK: - Command methods

    /** Post new command to IoT Cloud.
    Command will be delivered to specified target and result will be notified
    through push notification.

    **Note**: Please onboard first, or provide a target instance by calling copyWithTarget. Otherwise, KiiCloudError.TARGET_NOT_AVAILABLE will be return in completionHandler callback

    - Parameter commandForm: Command form of posting command.
    - Parameter completionHandler: A closure to be executed once finished. The closure takes 2 arguments: an instance of created command, an instance of ThingIFError when failed.
    */
    open func postNewCommand(
        _ commandForm: CommandForm,
        completionHandler: @escaping (Command?, ThingIFError?) -> Void) -> Void {
        fatalError("must be implemented.")
        /*
        _postNewCommand(commandForm.schemaName,
                        schemaVersion: commandForm.schemaVersion,
                        actions: commandForm.actions,
                        title: commandForm.title,
                        description: commandForm.commandDescription,
                        metadata: commandForm.metadata,
                        completionHandler: completionHandler);
         */
    }

    /** Get specified command

    **Note**: Please onboard first, or provide a target instance by calling copyWithTarget. Otherwise, KiiCloudError.TARGET_NOT_AVAILABLE will be return in completionHandler callback

    - Parameter commandID: ID of the Command to obtain.
    - Parameter completionHandler: A closure to be executed once finished. The closure takes 2 arguments: an instance of created command, an instance of ThingIFError when failed.
     */
    open func getCommand(
        _ commandID:String,
        completionHandler: @escaping (Command?, ThingIFError?)-> Void
        )
    {
        _getCommand(commandID, completionHandler: completionHandler)
    }
    
    /** List Commands in the specified Target.

    **Note**: Please onboard first, or provide a target instance by calling copyWithTarget. Otherwise, KiiCloudError.TARGET_NOT_AVAILABLE will be return in completionHandler callback

    - Parameter bestEffortLimit: Limit the maximum number of the Commands in the
    Response. If omitted default limit internally defined is applied.
    Meaning of 'bestEffort' is if specified value is greater than default limit,
    default limit is applied.
    - Parameter paginationKey: If there is further page to be retrieved, this
    API returns paginationKey in sencond element. Specifying this value in next
    call results continue to get the results from the next page.
    - Returns: Where 1st element is Array of the commands
    belongs to the Target. 2nd element is paginationKey if there is further page
    to be retrieved.
    - Parameter completionHandler: A closure to be executed once finished. The closure takes 3 arguments: 1st one is Array of Commands if found, 2nd one is paginationKey if there is further page to be retrieved, and 3rd one is an instance of ThingIFError when failed.
     */
    open func listCommands(
        _ bestEffortLimit: Int? = nil,
        paginationKey: String? = nil,
        completionHandler: @escaping ([Command]?, String?, ThingIFError?)-> Void
        )
    {
        _listCommands(bestEffortLimit, paginationKey: paginationKey, completionHandler: completionHandler)
    }

    // MARK: - Trigger methods

    /** Post new Trigger to IoT Cloud.

    **Note**: Please onboard first, or provide a target instance by
      calling copyWithTarget. Otherwise,
      KiiCloudError.TARGET_NOT_AVAILABLE will be return in
      completionHandler callback

    When thing related to this ThingIFAPI instance meets condition
    described by predicate, A registered command sends to thing
    related to `TriggeredCommandForm.targetID`.

    `target` property and `TriggeredCommandForm.targetID` must be same
    owner's things.

    - Parameter triggeredCommandForm: Triggered command form of posting trigger.
    - Parameter predicate: Predicate of this trigger.
    - Parameter options: Optional data for this trigger.
    - Parameter completionHandler: A closure to be executed once
      finished. The closure takes 2 arguments: 1st one is an created
      Trigger instance, 2nd one is an ThingIFError instance when
      failed.
    */
    open func postNewTrigger(
        _ triggeredCommandForm:TriggeredCommandForm,
        predicate:Predicate,
        options:TriggerOptions? = nil,
        completionHandler: @escaping (Trigger?, ThingIFError?) -> Void)
    {
        _postNewTrigger(triggeredCommandForm,
                        predicate: predicate,
                        options: options,
                        completionHandler: completionHandler);
    }

    /** Post new Trigger to IoT Cloud.
     
     **Note**: Please onboard first, or provide a target instance by calling copyWithTarget. Otherwise, KiiCloudError.TARGET_NOT_AVAILABLE will be return in completionHandler callback
     
     - Parameter serverCode: Server code to be executed by the Trigger.
     - Parameter predicate: Predicate of the Command.
     - Parameter options: Optional data for this trigger.
     - Parameter completionHandler: A closure to be executed once finished. The closure takes 2 arguments: 1st one is an created Trigger instance, 2nd one is an ThingIFError instance when failed.
     */
    open func postNewTrigger(
        _ serverCode:ServerCode,
        predicate:Predicate,
        options:TriggerOptions? = nil,
        completionHandler: @escaping (Trigger?, ThingIFError?)-> Void
        )
    {
        _postNewTrigger(
          serverCode,
          predicate: predicate,
          options: options,
          completionHandler: completionHandler)
    }


    /** Get specified trigger

    **Note**: Please onboard first, or provide a target instance by calling copyWithTarget. Otherwise, KiiCloudError.TARGET_NOT_AVAILABLE will be return in completionHandler callback

    - Parameter triggerID: ID of the Trigger to obtain.
    - Parameter completionHandler: A closure to be executed once finished. The closure takes 2 arguments: an instance of Trigger, an instance of ThingIFError when failed.
    */
    open func getTrigger(
        _ triggerID:String,
        completionHandler: @escaping (Trigger?, ThingIFError?)-> Void
        )
    {
        _getTrigger(triggerID, completionHandler: completionHandler)
    }

    /** Apply patch to a registered Trigger
    Modify a registered Trigger with the specified patch.

    **Note**: Please onboard first, or provide a target instance by
      calling copyWithTarget. Otherwise,
      KiiCloudError.TARGET_NOT_AVAILABLE will be return in
      completionHandler callback

    `target` property and `TriggeredCommandForm.targetID` must be same
    owner's things.

    - Parameter triggerID: ID of the Trigger to which the patch is applied.
    - Parameter triggeredCommandForm: Modified triggered command form
      to patch trigger.
    - Parameter predicate: Modified Predicate to be applied as patch.
    - Parameter options: Modified optional data for this trigger.
    - Parameter completionHandler: A closure to be executed once
      finished. The closure takes 2 arguments: 1st one is the modified
      Trigger instance, 2nd one is an ThingIFError instance when
      failed.
    */
    open func patchTrigger(
        _ triggerID:String,
        triggeredCommandForm:TriggeredCommandForm? = nil,
        predicate:Predicate? = nil,
        options:TriggerOptions? = nil,
        completionHandler: @escaping (Trigger?, ThingIFError?) -> Void)
    {
        _patchTrigger(
            triggerID,
            triggeredCommandForm: triggeredCommandForm,
            predicate: predicate,
            options: options,
            completionHandler: completionHandler)
    }

    /** Apply patch to a registered Trigger
     Modify a registered Trigger with the specified patch.
     
     **Note**: Please onboard first, or provide a target instance by calling copyWithTarget. Otherwise, KiiCloudError.TARGET_NOT_AVAILABLE will be return in completionHandler callback
     
     - Parameter triggerID: ID of the Trigger to which the patch is applied.
     - Parameter serverCode: Modified ServerCode to be applied as patch.
     - Parameter predicate: Modified Predicate to be applied as patch.
     - Parameter options: Optional data for this trigger.
     - Parameter completionHandler: A closure to be executed once finished. The closure takes 2 arguments: 1st one is the modified Trigger instance, 2nd one is an ThingIFError instance when failed.
     */
    open func patchTrigger(
        _ triggerID:String,
        serverCode:ServerCode? = nil,
        predicate:Predicate? = nil,
        options:TriggerOptions? = nil,
        completionHandler: @escaping (Trigger?, ThingIFError?)-> Void
        )
    {
        _patchTrigger(triggerID,
                      serverCode: serverCode,
                      predicate: predicate,
                      options: options,
                      completionHandler: completionHandler)
    }

    /** Enable/Disable a registered Trigger
    If its already enabled(/disabled), this method won't throw error and behave
    as succeeded.

    **Note**: Please onboard first, or provide a target instance by calling copyWithTarget. Otherwise, KiiCloudError.TARGET_NOT_AVAILABLE will be return in completionHandler callback

    - Parameter triggerID: ID of the Trigger to be enabled/disabled.
    - Parameter enable: Flag indicate enable/disable Trigger.
    - Parameter completionHandler: A closure to be executed once finished. The closure takes 2 arguments: 1st one is the enabled/disabled Trigger instance, 2nd one is an ThingIFError instance when failed.
    */
    open func enableTrigger(
        _ triggerID:String,
        enable:Bool,
        completionHandler: @escaping (Trigger?, ThingIFError?)-> Void
        )
    {
        _enableTrigger(triggerID, enable: enable, completionHandler: completionHandler)
    }
    
    /** Delete a registered Trigger.

    **Note**: Please onboard first, or provide a target instance by calling copyWithTarget. Otherwise, KiiCloudError.TARGET_NOT_AVAILABLE will be return in completionHandler callback

    - Parameter triggerID: ID of the Trigger to be deleted.
    - Parameter completionHandler: A closure to be executed once finished. The closure takes 2 arguments: 1st one is the deleted TriggerId, 2nd one is an ThingIFError instance when failed.
    */
    open func deleteTrigger(
        _ triggerID:String,
        completionHandler: @escaping (String, ThingIFError?)-> Void
        )
    {
        _deleteTrigger(triggerID, completionHandler: completionHandler)
    }
    
    /** List Triggers belongs to the specified Target

    **Note**: Please onboard first, or provide a target instance by calling copyWithTarget. Otherwise, KiiCloudError.TARGET_NOT_AVAILABLE will be return in completionHandler callback

    - Parameter bestEffortLimit: Limit the maximum number of the Triggers in the
    Response. If omitted default limit internally defined is applied.
    Meaning of 'bestEffort' is if specified value is greater than default limit,
    default limit is applied.
    - Parameter paginationKey: If there is further page to be retrieved, this
    API returns paginationKey in 2nd element. Specifying this value in next
    call in the argument results continue to get the results from the next page.
    - Parameter completionHandler: A closure to be executed once finished. The closure takes 3 arguments: 1st one is Array of Triggers instance if found, 2nd one is paginationKey if there is further page to be retrieved, and 3rd one is an instance of ThingIFError when failed.
    */
    open func listTriggers(
        _ bestEffortLimit:Int? = nil,
        paginationKey:String? = nil,
        completionHandler: @escaping (_ triggers:[Trigger]?, _ paginationKey:String?, _ error: ThingIFError?)-> Void
        )
    {
        _listTriggers(bestEffortLimit, paginationKey: paginationKey, completionHandler: completionHandler)
    }
    
    /** Retrieves list of server code results that was executed by the specified trigger.
        Results will be listing with order by modified date descending (latest first)
     
     **Note**: Please onboard first, or provide a target instance by calling copyWithTarget. Otherwise, KiiCloudError.TARGET_NOT_AVAILABLE will be return in completionHandler callback
     
     - Parameter bestEffortLimit: Limit the maximum number of the Results in the
     Response. If omitted default limit internally defined is applied.
     Meaning of 'bestEffort' is if specified value is greater than default limit,
     default limit is applied.
     - Parameter triggerID: ID of the Trigger
     - Parameter paginationKey: If there is further page to be retrieved, this
     API returns paginationKey in 2nd element. Specifying this value in next
     call in the argument results continue to get the results from the next page.
     - Parameter completionHandler: A closure to be executed once finished. The closure takes 3 arguments: 1st one is Array of Results instance if found, 2nd one is paginationKey if there is further page to be retrieved, and 3rd one is an instance of ThingIFError when failed.
     */
    open func listTriggeredServerCodeResults(
        _ triggerID:String,
        bestEffortLimit:Int? = nil,
        paginationKey:String? = nil,
        completionHandler: @escaping (_ results:[TriggeredServerCodeResult]?, _ paginationKey:String?, _ error: ThingIFError?)-> Void
        )
    {
        _listTriggeredServerCodeResults(triggerID, bestEffortLimit:bestEffortLimit, paginationKey:paginationKey, completionHandler: completionHandler)
    }


    // MARK: - Getting thing state methods

    /** Get the state of specified target.

     **Note**: Please onboard first, or provide a target instance by
     calling copyWithTarget. Otherwise,
     KiiCloudError.TARGET_NOT_AVAILABLE will be return in
     completionHandler callback

     - Parameter completionHandler: A closure to be executed once get
       state has finished. The closure takes 2 arguments: 1st one is
       Dictionary that represent Target State and 2nd one is an
       instance of ThingIFError when failed.
    */
    open func getTargetState(
      _ completionHandler:@escaping ([String : [String : Any]]?,
                                     ThingIFError?)-> Void) -> Void
    {
        _getTargetStates(completionHandler)
    }

    /** Get the state of specified target by trait.

     **Note**: Please onboard first, or provide a target instance by
     calling copyWithTarget. Otherwise,
     KiiCloudError.TARGET_NOT_AVAILABLE will be return in
     completionHandler callback

     You can not use this method if You chose non trait verson.

     - Parameter alias: alias of trait.
     - Parameter completionHandler: A closure to be executed once get
       state has finished. The closure takes 2 arguments: 1st one is
       Dictionary that represent Target State and 2nd one is an
       instance of ThingIFError when failed.
     */
    open func getTargetState(
      _ alias: String,
      completionHandler:@escaping ([String : Any]?,
                                   ThingIFError?)-> Void) -> Void
    {
        _getTargetState(alias, completionHandler: completionHandler)
    }

    // MARK: - Thing information methods

    /** Get the Vendor Thing ID of specified Target.
     
     - Parameter completionHandler: A closure to be executed once get id has finished. The closure takes 2 arguments: 1st one is Vendor Thing ID and 2nd one is an instance of ThingIFError when failed.
     */
    open func getVendorThingID(
        _ completionHandler: @escaping (String?, ThingIFError?)-> Void
        )
    {
        if self.target == nil {
            completionHandler(nil, ThingIFError.targetNotAvailable)
            return;
        }

        let requestURL = "\(self.baseURL)/api/apps/\(self.appID)/things/\(self.target!.typedID.id)/vendor-thing-id"

        // generate header
        let requestHeaderDict:Dictionary<String, String> = [
            "x-kii-appid": self.appID,
            "x-kii-appkey": self.appKey,
            "authorization": "Bearer \(self.owner.accessToken)"
        ]

        // do request
        let request = buildDefaultRequest(
            HTTPMethod.GET,
            urlString: requestURL,
            requestHeaderDict: requestHeaderDict,
            requestBodyData: nil,
            completionHandler: { (response, error) -> Void in
                let vendorThingID = response?["_vendorThingID"] as? String
                DispatchQueue.main.async {
                    completionHandler(vendorThingID, error)
                }
            }
        )
        let operation = IoTRequestOperation(request: request)
        operationQueue.addOperation(operation)
    }

    /** Update the Vendor Thing ID of specified Target.

     - Parameter vendorThingID: New vendor thing id
     - Parameter password: New password
     - Parameter completionHandler: A closure to be executed once finished. The closure takes 1 argument: an instance of ThingIFError when failed.
     */
    open func update(
        vendorThingID: String,
        password: String,
        completionHandler: @escaping (ThingIFError?)-> Void
        )
    {
        if self.target == nil {
            completionHandler(ThingIFError.targetNotAvailable)
            return;
        }
        if vendorThingID.isEmpty || password.isEmpty {
            completionHandler(ThingIFError.unsupportedError)
            return;
        }

        let requestURL = "\(self.baseURL)/api/apps/\(self.appID)/things/\(self.target!.typedID.id)/vendor-thing-id"

        // generate header
        let requestHeaderDict:Dictionary<String, String> = [
            "x-kii-appid": self.appID,
            "x-kii-appkey": self.appKey,
            "authorization": "Bearer \(self.owner.accessToken)",
            "Content-Type": "application/vnd.kii.VendorThingIDUpdateRequest+json"
        ]

        // genrate body
        let requestBodyDict = NSMutableDictionary(dictionary:
            [
                "_vendorThingID": vendorThingID,
                "_password": password
            ]
        )

        do {
            let requestBodyData = try JSONSerialization.data(withJSONObject: requestBodyDict, options: JSONSerialization.WritingOptions(rawValue: 0))
            // do request
            let request = buildDefaultRequest(
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

    /** Update firmware version.

     This method updates firmware version for `target` thing.

     - Parameter firmwareVersion: firmwareVersion to be updated.
     - Parameter completionHandler: A closure to be executed once on
       updating has finished The closure takes 1 argument. The
       argument is ThingIFError.
     */
    open func update(
      firmwareVersion: String,
      completionHandler: @escaping (ThingIFError?)-> Void) -> Void
    {
        // TODO: implement me.
    }

    /** Get firmeware version.

     This method gets firmware version for `target` thing.

     - Parameter completionHandler: A closure to be executed once on
       getting has finished The closure takes 2 arguments. First one
       is firmware version. Second one is ThingIFError.
     */
    open func getFirmewareVerson(
      _ completionHandler: @escaping (String?, ThingIFError?) -> Void) -> Void
    {
        // TODO: implement me.
    }

    /** Update thing type.

     This method updates thing type for `target` thing.

     - Parameter thingType: thing type to be updated.
     - Parameter completionHandler: A closure to be executed once on
       updating has finished The closure takes 1 argument. The
       argument is ThingIFError.
     */
    open func update(
      thingType: String,
      completionHandler: @escaping (ThingIFError?)-> Void) -> Void
    {
        // TODO: implement me.
    }

    /** Get thing type.

     This method gets thing type for `target` thing.

     - Parameter completionHandler: A closure to be executed once on
       getting has finished The closure takes 2 arguments. First one
       is thing type. Second one is ThingIFError.
     */
    open func getThingType(
      _ completionHandler: @escaping (String?, ThingIFError?) -> Void) -> Void
    {
        // TODO: implement me.
    }

    // MARK: Qeury state history.

    /** Query history states with trait alias.

     - Parameter query: Instance of `HistoryStatesQuery`. If nil or
       omitted, query all history states
     - Parameter completionHandler: A closure to be executed once
       finished. The closure takes 3 arguments:
       - 1st one is array of history states. If there is no objects to
         be queried, the array is empty.
       - 2nd one is a pagination key. It represents information to
         retrieve further page. You can use pagination key to retrieve
         next page by setting nextPaginationKey. if there is no
         further page, pagination key is nil.
       - 3rd one is an instance of ThingIFError when failed.
     */
    open func query(
      _ query: HistoryStatesQuery? = nil,
      completionHandler: @escaping (
        [HistoryState]?, String?, ThingIFError?) -> Void) -> Void
    {
        // TODO: implement me.
    }

    /** Group history state

     - Parameter query: `GroupedHistoryStatesQuery` instance.timeRange
       in query should less than 60 data grouping intervals.
     - Parameter completionHandler: A closure to be executed once
       finished. The closure takes 2 arguments:
       - 1st one is `GroupedHistoryStates` array.
       - 2nd one is an instance of ThingIFError when failed.
     */
    open func query(
      _ query: GroupedHistoryStatesQuery,
      completionHandler: @escaping (
        [GroupedHistoryStates]?, ThingIFError?) -> Void) -> Void
    {
        // TODO: implement me.
    }

    /** Aggregate history states

     `AggregatedValueType` represents type of calcuated value with
     `Aggregation.FunctionType`.

     - If the function is `Aggregation.FunctionType.max`,
       `Aggregation.FunctionType.min` or
       `Aggregation.FunctionType.sum`, the type may be same as type of
       field represented by `Aggregation.FieldType`.
     - If the function is `Aggregation.FunctionType.mean`, the type
       may be `Double`.
     - If the function is `Aggregation.FunctionType.count`, the type
       must be `Int`.

     - Parameter query: `GroupedHistoryStatesQuery`
       instance. timeRange in query should less than 60 data grouping
       intervals.
     - Parameter aggregation: `Aggregation` instance.
     - Parameter completionHandler: A closure to be executed once
       finished. The closure takes 2 arguments:
       - 1st one is an `AggregatedResult` array.
       - 2nd one is an instance of ThingIFError when failed.
     */
    open func aggregate<AggregatedValueType>(
      _ query: GroupedHistoryStatesQuery,
      aggregation: Aggregation,
      completionHandler: @escaping(
        [AggregatedResult<AggregatedValueType>]?,
        ThingIFError?) -> Void) -> Void
    {
        if self.target == nil {
            completionHandler(nil, ThingIFError.targetNotAvailable)
            return;
        }

        // generate body
        let requestBody : [ String : Any] = ["query" : query.makeJsonObject() + ["aggregations" : [ aggregation.makeJsonObject() ]] ]

        self.operationQueue.addHttpRequestOperation(
            .post,
            url: "\(self.baseURL)/thing-if/apps/\(self.appID)/targets/\(self.target!.typedID.toString())/states/aliases/\(query.alias)/query",
            requestHeader:
            self.defaultHeader + ["Content-Type" : MediaType.mediaTypeTraitStateQueryRequest.rawValue],
            requestBody: requestBody,
            failureBeforeExecutionHandler: { completionHandler(nil, $0) }) {
                response, error in

                var results : [AggregatedResult<AggregatedValueType>]? = nil
                if let response = response {
                    results = []
                    let queryResults = response["groupedResults"] as! [[String:Any]]
                    for result in queryResults {
                        var value: AggregatedValueType? = nil
                        var history: [HistoryState] = []
                        let range = result["range"] as! [String: Double]
                        let timeRange = TimeRange(
                            Date(timeIntervalSince1970:range["from"]!),
                            to: Date(timeIntervalSince1970:range["to"]!))
                        let aggregation = (result["aggregations"] as! [[String: Any]])[0]
                        if aggregation["value"] != nil {
                            value = aggregation["value"] as? AggregatedValueType
                        }
                        if aggregation["object"] != nil {
                            do {
                                let object = aggregation["object"] as! [String: Any]
                                history.append(try HistoryState(object))
                            } catch let error {
                                DispatchQueue.main.async {
                                    completionHandler(nil, error as? ThingIFError)
                                }
                                return;
                            }
                        }
                        results!.append(
                            AggregatedResult<AggregatedValueType>(
                                value,
                                timeRange: timeRange,
                                aggregatedObjects: history))
                    }
                } else if error != nil {
                    switch error! {
                    case .errorResponse(let errorResponse):
                        if errorResponse.httpStatusCode == 409 &&
                            errorResponse.errorCode == "STATE_HISTORY_NOT_AVAILABLE" {
                            DispatchQueue.main.async {
                                completionHandler([], nil)
                            }
                            return;
                        }
                        break
                    default:
                        break
                    }
                }
                DispatchQueue.main.async {
                    completionHandler(results, error)
                }
            }
    }

    // MARK: - Copy with new target instance

    /** Get new instance with new target

    - Parameter newTarget: target instance will be setted to new ThingIFAPI instance
    - Parameter tag: tag of the ThingIFAPI instance or nil for default tag
    - Returns: New ThingIFAPI instance with newTarget
    */
    open func copyWithTarget(_ newTarget: Target, tag : String? = nil) -> ThingIFAPI {

        let newIotapi = ThingIFAPI(self.app,
                                   owner: self.owner,
                                   target: newTarget,
                                   tag: tag)

        newIotapi.installationID = self.installationID
        newIotapi.saveToUserDefault()
        return newIotapi
    }

    public static func == (left: ThingIFAPI, right: ThingIFAPI) -> Bool {
        return left.appID == right.appID &&
          left.appKey == right.appKey &&
          left.baseURL == right.baseURL &&
          left.target?.accessToken == right.target?.accessToken &&
          left.target?.typedID == right.target?.typedID &&
          left.installationID == right.installationID &&
          left.tag == right.tag
    }

}

internal extension ThingIFAPI {

    var defaultHeader: [String : String] {
        get {
            return [
              "Authorization" : "Bearer \(self.owner.accessToken)",
              "X-Kii-AppID" : self.appID,
              "X-Kii-AppKey" : self.appKey,
              "X-Kii-SDK" : SDKVersion.sharedInstance.kiiSDKHeader
            ]
        }
    }
}
