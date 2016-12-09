//
//  File.swift
//  ThingIFSDK
//
//  Created on 2016/12/09.
//  Copyright (c) 2016 Kii. All rights reserved.
//

import Foundation

/** Class represents TraitCommand */
open class TraitCommand: NSObject, NSCoding {

    // MARK: - Implements NSCoding protocol
    open func encode(with aCoder: NSCoder) {
        aCoder.encode(self.commandID, forKey: "commandID")
        aCoder.encode(self.targetID, forKey: "targetID")
        aCoder.encode(self.issuerID, forKey: "issuerID")
        aCoder.encode(self.actions, forKey: "actions")
        aCoder.encode(self.actionResults, forKey: "actionResults")
        aCoder.encode(self.commandState.rawValue, forKey: "commandState")
        aCoder.encode(self.firedByTriggerID, forKey: "firedByTriggerID")
        if let date = self.created {
            aCoder.encode(date.timeIntervalSince1970, forKey: "created")
        }
        if let date = self.modified {
            aCoder.encode(date.timeIntervalSince1970, forKey: "modified")
        }
        aCoder.encode(self.title, forKey: "title")
        aCoder.encode(self.commandDescription, forKey: "commandDescription")
        aCoder.encode(self.metadata, forKey: "metadata")
    }

    public required init(coder aDecoder: NSCoder) {
        self.commandID = aDecoder.decodeObject(forKey: "commandID") as! String
        self.targetID = aDecoder.decodeObject(forKey: "targetID") as! TypedID
        self.issuerID = aDecoder.decodeObject(forKey: "issuerID") as! TypedID
        self.actions = aDecoder.decodeObject(forKey: "actions")
                as! [[String : [String : Any]]];
        self.actionResults = aDecoder.decodeObject(forKey: "actionResults")
                as! [[String : [String : Any]]];
        self.commandState = CommandState(
          rawValue: aDecoder.decodeInteger(forKey: "commandState"))!;
        self.firedByTriggerID =
          aDecoder.decodeObject(forKey: "firedByTriggerID") as? String

        var created: Date? = nil
        if aDecoder.containsValue(forKey: "created") {
            created = Date(
              timeIntervalSince1970: aDecoder.decodeDouble(forKey: "created"))
        }
        self.created = created

        var modified: Date? = nil
        if aDecoder.containsValue(forKey: "modified") {
            modified = Date(
              timeIntervalSince1970: aDecoder.decodeDouble(forKey: "modified"))
        }
        self.modified = modified

        self.title = aDecoder.decodeObject(forKey: "title") as? String
        self.commandDescription =
          aDecoder.decodeObject(forKey: "commandDescription") as? String
        self.metadata =
          aDecoder.decodeObject(forKey: "metadata") as? [String : Any]
    }

    // MARK: Properties

    /** ID of the Command. */
    open let commandID: String
    /** ID of the Command Target. */
    open let targetID: TypedID
    /** ID of the issuer of the Command. */
    open let issuerID: TypedID
    /** Actions to be executed. */
    open let actions: [[String : [String : Any]]]
    /** Results of the action. */
    open let actionResults: [[String : [String : Any]]]
    /** State of the Command. */
    open let commandState: CommandState
    /** ID of the trigger which fired this command */
    open let firedByTriggerID: String?
    /** Creation time of the Command.*/
    open let created: Date?
    /** Modification time of the Command. */
    open let modified: Date?
    /** Title of the Command */
    open let title: String?
    /** Description of the Command */
    open let commandDescription: String?
    /** Metadata of the Command */
    open let metadata: [String : Any]?

    internal init(commandID: String,
         targetID: TypedID,
         issuerID: TypedID,
         actions:[[String : [String : Any]]],
         actionResults:[[String : [String : Any]]]?,
         commandState: CommandState,
         firedByTriggerID: String? = nil,
         created: Date? = nil,
         modified: Date? = nil,
         title: String? = nil,
         commandDescription: String? = nil,
         metadata: [String : Any]? = nil)
    {
        self.commandID = commandID
        self.targetID = targetID
        self.issuerID = issuerID
        self.actions = actions
        self.actionResults = actionResults ?? []
        self.commandState = commandState
        self.firedByTriggerID = firedByTriggerID
        self.created = created
        self.modified = modified
        self.title = title
        self.commandDescription = commandDescription
        self.metadata = metadata
    }

    open override func isEqual(_ object: Any?) -> Bool {
        guard let aCommand = object as? TraitCommand else{
            return false
        }

        return self.commandID == aCommand.commandID &&
            self.targetID == aCommand.targetID &&
            self.issuerID == aCommand.issuerID
    }

}
