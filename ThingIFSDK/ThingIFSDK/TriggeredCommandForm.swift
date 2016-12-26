//
//  TriggeredCommandForm.swift
//  ThingIFSDK
//
//  Created on 2016/09/26.
//  Copyright (c) 2016 Kii. All rights reserved.
//

import Foundation

/**
Form of a command of a trigger.

This class contains data in order to create or modify `Command` in
`Trigger` with followings methods:

 - `ThingIFAPI.postNewTrigger(_:predicate:options:completionHandler:)`
 - `ThingIFAPI.patchTrigger(_:triggeredCommandForm:predicate:options:completionHandler:)`

Mandatory data are followings:

  - Array of actions

Optional data are followings:

  - Target thing id
  - Title of a triggered command
  - Description of a triggered command
  - Meta data of a triggered command
*/
open class TriggeredCommandForm: NSObject, NSCoding {

    // MARK: - Properties

    /// Array of actions.
    open let actions: [[String : Any]]

    /// Target thing ID.
    open let targetID: TypedID?

    /// Title of a command.
    open let title: String?

    /// Description of a command.
    open let commandDescription: String?

    /// Meta data of ad command.
    open let metadata: Dictionary<String, Any>?

    /// Use trait or not.
    internal let useTrait: Bool

    // MARK: - Initializing TriggeredCommandForm instance.
    private init(actions: [[String : Any]],
                 useTrait: Bool,
                 targetID: TypedID? = nil,
                 title: String? = nil,
                 commandDescription: String? = nil,
                 metadata: Dictionary<String, Any>? = nil)
    {
        self.actions = actions
        self.targetID = targetID
        self.useTrait = useTrait
        self.title = title;
        self.commandDescription = commandDescription;
        self.metadata = metadata;
    }

    /**
    Initializer of TriggeredCommandForm instance for non trait.

    - Parameter actions: Array of actions. Must not be empty. The
      contente of this array must be non trait actions.
    - Parameter title: Title of a command. This should be equal or
      less than 50 characters.
    - Parameter description: Description of a comand. This should be
      equal or less than 200 characters.
    - Parameter metadata: Meta data of a command.
    */
    public convenience init(actions: [[String : Any]],
                            targetID: TypedID? = nil,
                            title: String? = nil,
                            commandDescription: String? = nil,
                            metadata: Dictionary<String, Any>? = nil)
    {
        self.init(actions: actions,
                  useTrait: false,
                  targetID: targetID,
                  title: title,
                  commandDescription: commandDescription,
                  metadata: metadata)
    }

    /**
    Initializer of TriggeredCommandForm instance for trait.

    - Parameter actions: Array of actions. Must not be empty. The
      contente of this array must be trait actions.
    - Parameter title: Title of a command. This should be equal or
      less than 50 characters.
    - Parameter description: Description of a comand. This should be
      equal or less than 200 characters.
    - Parameter metadata: Meta data of a command.
    */
    public convenience init(traitActions: [[String : [String : Any]]],
                            targetID: TypedID? = nil,
                            title: String? = nil,
                            commandDescription: String? = nil,
                            metadata: Dictionary<String, Any>? = nil)
    {
        self.init(actions: traitActions,
                  useTrait: true,
                  targetID: targetID,
                  title: title,
                  commandDescription: commandDescription,
                  metadata: metadata)
    }

    /**
    Initializer of TriggeredCommandForm instance.

    This initializer copies following fields:

    - `Command.actions`
    - `Command.targetID`
    - `Command.title`
    - `Command.commandDescription`
    - `Command.metadata`

    If you specify optional arguments corresponding to above mentioned
    value, Optional argument values win against the `Command` values.

    - Parameter command: source command of this TriggeredCommandForm.
    - Parameter actions: Array of actions. Must not be empty. Both of
      non trait action array and trait action array are acceptable but
      non trait action and trait action must not be mixed in a array.
    - Parameter targetID: target thing ID.
    - Parameter title: Title of a command. This should be equal or
      less than 50 characters.
    - Parameter description: Description of a comand. This should be
      equal or less than 200 characters.
    - Parameter metadata: Meta data of a command.
    */
    public init(command: Command,
                actions: [Dictionary<String, Any>]? = nil,
                targetID: TypedID? = nil,
                title: String? = nil,
                commandDescription: String? = nil,
                metadata: Dictionary<String, Any>? = nil)
    {
        self.actions = actions != nil ? actions! : command.actions
        self.targetID = targetID != nil ? targetID : command.targetID
        self.title = title != nil ? title : command.title
        self.commandDescription =
            commandDescription != nil ? commandDescription :
                command.commandDescription
        self.metadata = metadata != nil ? metadata : command.metadata
    }

    open func encode(with aCoder: NSCoder) {
        aCoder.encode(self.actions, forKey: "actions")
        aCoder.encode(self.targetID, forKey: "targetID")
        aCoder.encode(self.title, forKey: "title")
        aCoder.encode(self.commandDescription,
                forKey: "commandDescription");
        aCoder.encode(self.metadata, forKey: "metadata")
    }

    public required init?(coder aDecoder: NSCoder) {
        self.actions = aDecoder.decodeObject(forKey: "actions")
                as! [Dictionary<String, Any>];
        self.targetID = aDecoder.decodeObject(forKey: "targetID") as? TypedID
        self.title = aDecoder.decodeObject(forKey: "title") as? String
        self.commandDescription =
            aDecoder.decodeObject(forKey: "commandDescription") as? String;
        self.metadata = aDecoder.decodeObject(forKey: "metadata")
                as? Dictionary<String, Any>;
    }

    func toDictionary() -> Dictionary<String, Any> {
        var retval: Dictionary<String, Any> =
            [
                "actions": self.actions
            ]
        if let targetID = self.targetID {
            retval["target"] = targetID.toString()
        }
        retval["title"] = self.title
        retval["description"] = self.commandDescription
        retval["metadata"] = self.metadata
        return retval;
    }
}
