//
//  TraitThingIFAPI.swift
//  ThingIFSDK
//
//  Created on 2016/12/07.
//  Copyright (c) 2016 Kii. All rights reserved.
//

import Foundation

open class TraitThingIFAPI: NSObject, NSCoding {

    // MARK: - Implements NSCoding protocol
    open func encode(with aCoder: NSCoder) {
        // TODO: implement me.
    }

    public required init(coder aDecoder: NSCoder){
        // TODO: implement me.
    }

    // MARK: - On board methods

    /** On board IoT Cloud with the specified vendor thing ID.
     Specified thing will be owned by owner who consumes this API.
     (Specified on creation of TraitThingIFAPI instance.)

     If you are using a gateway, you need to use
     `TraitThingIFAPI.onboard(pendingEndnode:endnodePassword:options:completionHandler:)`
     to onboard endnode instead.

     **Note**: You should not call onboard second time, after
     successfully onboarded. Otherwise, ThingIFError.ALREADY_ONBOARDED
     will be returned in completionHandler callback.

     - Parameter vendorThingID: Thing ID given by vendor. Must be specified.
     - Parameter thingPassword: Thing Password given by vendor. Must be
       specified.
     - Parameter options: Optional parameters inside.
     - Parameter completionHandler: A closure to be executed once on
       board has finished. The closure takes 2 arguments: an target,
       an ThingIFError
    */
    open func onboardWith(
        vendorThingID:String,
        thingPassword:String,
        options:OnboardWithVendorThingIDOptions? = nil,
        completionHandler: @escaping (Target?, ThingIFError?)-> Void
        ) ->Void
    {
        // TODO: implement me.
    }

    /** On board IoT Cloud with the specified thing ID.

     Specified thing will be owned by owner who consumes this API.
     (Specified on creation of TraitThingIFAPI instance.)  When you're
     sure that the on board process has been done, this method is
     convenient. If you are using a gateway, you need to use
     `TraitThingIFAPI.onboard(pendingEndnode:endnodePassword:options:completionHandler:)`
     to onboard endnode instead.

     **Note**: You should not call onboard second time, after
     successfully onboarded. Otherwise, ThingIFError.ALREADY_ONBOARDED
     will be returned in completionHandler callback.

     - Parameter thingID: Thing ID given by IoT Cloud. Must be specified.
     - Parameter thingPassword: Thing Password given by vendor. Must
       be specified.
     - Parameter options: Optional parameters inside.
     - Parameter completionHandler: A closure to be executed once on
       board has finished. The closure takes 2 arguments: an target,
       an ThingIFError
     */
    open func onboardWith(
        thingID:String,
        thingPassword:String,
        options:OnboardWithThingIDOptions? = nil,
        completionHandler: @escaping (Target?, ThingIFError?)-> Void
        ) ->Void
    {
        // TODO: implement me.
    }

    /** Endpoints execute onboarding for the thing and merge MQTT
     channel to the gateway. Thing act as Gateway is already
     registered and marked as Gateway.

     - Parameter pendingEndnode: Pending End Node
     - Parameter endnodePassword: Password of the End Node
     - Parameter options: Optional parameters inside.
     - Parameter completionHandler: A closure to be executed once on
       board has finished. The closure takes 2 arguments: an end node,
       an ThingIFError
     */
    open func onboard(
        pendingEndnode:PendingEndNode,
        endnodePassword:String,
        options:OnboardEndnodeWithGatewayOptions? = nil,
        completionHandler: @escaping (EndNode?, ThingIFError?)-> Void
        ) ->Void
    {
        // TODO: implement me.
    }

    // MARK: - Push notification methods

    /** Install push notification to receive notification from IoT
     Cloud. IoT Cloud will send notification when the Target replies
     to the Command. Application can receive the notification and
     check the result of Command fired by Application or registered
     Trigger. After installation is done Installation ID is managed in
     this class.

     - Parameter deviceToken: NSData instance of device token for APNS.
     - Parameter development: flag indicate whether the cert is
       development or production. This is optional, the default is
       false (production).
     - Parameter completionHandler: A closure to be executed once on
       board has finished.
    */
    open func installPush(
        _ deviceToken:Data,
        development:Bool?=false,
        completionHandler: @escaping (String?, ThingIFError?)-> Void) -> Void
    {
        // TODO: implement me.
    }

    /** Uninstall push notification.
     After done, notification from IoT Cloud won't be notified.

     - Parameter installationID: installation ID returned from
       installPush(). If null is specified, value of the
       installationID property is used.
    */
    open func uninstallPush(
        _ installationID:String?,
        completionHandler: @escaping (ThingIFError?)-> Void) -> Void
    {
        // TODO: implement me.
    }

    // MARK: - Trigger methods

    /** Enable/Disable a registered Trigger
     If its already enabled(/disabled), this method won't throw error
     and behave as succeeded.

     **Note**: Please onboard first, or provide a target instance by
     calling copyWithTarget. Otherwise,
     KiiCloudError.TARGET_NOT_AVAILABLE will be return in
     completionHandler callback

     - Parameter triggerID: ID of the Trigger to be enabled/disabled.
     - Parameter enable: Flag indicate enable/disable Trigger.
     - Parameter completionHandler: A closure to be executed once
       finished. The closure takes 2 arguments: 1st one is the
       enabled/disabled Trigger instance, 2nd one is an ThingIFError
       instance when failed.
    */
    open func enableTrigger(
        _ triggerID:String,
        enable:Bool,
        completionHandler: @escaping (Trigger?, ThingIFError?)-> Void) -> Void
    {
        // TODO: implement me.
    }

    /** Delete a registered Trigger.

     **Note**: Please onboard first, or provide a target instance by
     calling copyWithTarget. Otherwise,
     KiiCloudError.TARGET_NOT_AVAILABLE will be return in
     completionHandler callback

     - Parameter triggerID: ID of the Trigger to be deleted.
     - Parameter completionHandler: A closure to be executed once
       finished. The closure takes 2 arguments: 1st one is the deleted
       TriggerId, 2nd one is an ThingIFError instance when failed.
    */
    open func deleteTrigger(
        _ triggerID:String,
        completionHandler: @escaping (String, ThingIFError?)-> Void) -> Void
    {
        // TODO: implement me.
    }

    // MARK: - Get the state of specified target

    /** Get the Vendor Thing ID of specified Target.

     - Parameter completionHandler: A closure to be executed once get
       id has finished. The closure takes 2 arguments: 1st one is
       Vendor Thing ID and 2nd one is an instance of ThingIFError when
       failed.
     */
    open func getVendorThingID(
        _ completionHandler: @escaping (String?, ThingIFError?)-> Void
        )
    {
        // TODO: implement me.
    }

    /** Update the Vendor Thing ID of specified Target.

     - Parameter vendorThingID: New vendor thing id
     - Parameter password: New password
     - Parameter completionHandler: A closure to be executed once
       finished. The closure takes 1 argument: an instance of
       ThingIFError when failed.
     */
    open func update(
        _ vendorThingID: String,
        password: String,
        completionHandler: @escaping (ThingIFError?)-> Void) -> Void
    {
        // TODO: implement me.
    }

    // MARK: - Copy with new target instance

    /** Get new instance with new target

     - Parameter newTarget: target instance will be setted to new
       TraitThingIFAPI instance
     - Parameter tag: tag of the TraitThingIFAPI instance or nil for
       default tag
     - Returns: New TraitThingIFAPI instance with newTarget
    */
    open func copyWithTarget(
        _ newTarget: Target,
        tag : String? = nil) -> TraitThingIFAPI
    {
        // TODO: implement me.
    }

    /** Try to load the instance of TraitThingIFAPI using stored serialized instance.

     Instance is automatically saved when following methods are
     called. onboard, onboardWithVendorThingID, copyWithTarget and
     installPush has been successfully completed. (When copyWithTarget
     is called, only the copied instance is saved.)

     If the TraitThingIFAPI instance is build without the tag, all
     instance is saved in same place and overwritten when the instance
     is saved.

     If the TraitThingIFAPI instance is build with the tag(optional),
     tag is used as key to distinguish the storage area to save the
     instance. This would be useful to saving multiple instance.

     When you catch exceptions, please call onload for saving or
     updating serialized instance.

     - Parameter tag: tag of the TraitThingIFAPI instance
     - Returns: TraitThingIFAPI instance.
    */
    open static func loadWithStoredInstance(
        _ tag : String? = nil)
      throws -> TraitThingIFAPI?
    {
        // TODO: implement me.
    }

    /** Save this instance */
    open func saveInstance() -> Void {
        // TODO: implement me.
    }

    /** Clear all saved instances in the NSUserDefaults. */
    open static func removeAllStoredInstances(){
        // TODO: implement me.
    }

    /** Remove saved specified instance in the NSUserDefaults.

     - Parameter tag: tag of the TraitThingIFAPI instance or nil for
       default tag
    */
    open static func removeStoredInstances(_ tag : String?=nil) -> Void{
        // TODO: implement me.
    }


}
