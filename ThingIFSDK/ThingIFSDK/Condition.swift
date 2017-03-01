//
//  Condition.swift
//  ThingIFSDK
//
//  Created by syahRiza on 4/25/16.
//  Copyright 2016 Kii. All rights reserved.
//

import Foundation
/** Class represents Condition */
public struct Condition {
    public let clause: TriggerClause

    /** Init Condition with Clause

     - Parameter clause: Clause instance
     */
    public init(_ clause: TriggerClause) {
        self.clause = clause
    }

}
