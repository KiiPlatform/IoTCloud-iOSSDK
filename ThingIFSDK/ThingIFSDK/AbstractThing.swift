//
//  AbstructThing.swift
//  ThingIFSDK
//
import Foundation

/** Represents Target */
open class AbstractThing : Equatable, TargetThing {
    open let typedID: TypedID
    open let accessToken: String?
    open var thingID: String {
        return self.typedID.id
    }
    open let vendorThingID: String

    // MARK: - Implements NSCoding protocol
    open func encode(with aCoder: NSCoder) {
        aCoder.encode(self.thingID, forKey: "thingID")
        aCoder.encode(self.accessToken, forKey: "accessToken")
        aCoder.encode(self.vendorThingID, forKey: "vendorThingID")
    }

    // MARK: - Implements NSCoding protocol
    public required init(coder aDecoder: NSCoder) {
        let thingID = aDecoder.decodeObject(forKey: "thingID") as! String
        self.typedID = TypedID(TypedID.Types.thing, id: thingID)
        self.accessToken = aDecoder.decodeObject(forKey: "accessToken") as! String?
        self.vendorThingID = aDecoder.decodeObject(forKey: "vendorThingID") as! String
    }

    /** Init

    - Parameter thingID: ID of thing
    - Parameter vendorThingID: ID of vendor thing
    - Parameter accessToken: Access token of the target, can nil.
    */
    public init(_ thingID: String, vendorThingID : String, accessToken: String? = nil) {
        self.typedID = TypedID(TypedID.Types.thing, id: thingID)
        self.accessToken = accessToken
        self.vendorThingID = vendorThingID
    }

    open func isEqual(_ object: Any?) -> Bool {
        guard let aTarget = object as? AbstractThing else {
            return false
        }
        return self.typedID == aTarget.typedID && self.accessToken == aTarget.accessToken
    }

    public static func == (left: AbstractThing, right: AbstractThing) -> Bool{
        return left.isEqual(right);
    }
}
