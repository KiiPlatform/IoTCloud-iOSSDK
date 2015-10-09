//
//  TypedID.swift
//  IoTCloudSDK
//
import Foundation

/** Represents entity type and its ID. */
public class TypedID : NSObject, NSCoding {

    // MARK: - Implements NSCoding protocol
    public func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.type, forKey: "type")
        aCoder.encodeObject(self.typedID, forKey: "typedID")
    }

    // MARK: - Implements NSCoding protocol
    public required init(coder aDecoder: NSCoder) {
        self.type = aDecoder.decodeObjectForKey("type") as! String
        self.typedID = aDecoder.decodeObjectForKey("typedID") as! String
    }

    /** Type of the ID */
    public let type:String
    /** ID of the entity. */
    public let typedID:String

    /** Ininitialize TypedID with type and id.

    - Parameter type: Type of the entity.
    - Parameter typedID: ID of the entity.
     */
    public init(type:String, typedID:String) {
        self.type = type
        self.typedID = typedID
    }

    func toString() -> String {
        return "\(type):\(typedID)"
    }

    public override func isEqual(object: AnyObject?) -> Bool {
        guard let aType = object as? TypedID else{
            return false
        }
        return (self.type == aType.type) && (self.typedID == aType.typedID)
    }
}