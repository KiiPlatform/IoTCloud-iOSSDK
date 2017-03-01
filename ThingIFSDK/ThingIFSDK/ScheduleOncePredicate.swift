//
//  ScheduleOncePredicate.swift
//  ThingIFSDK
//
//  Created by syahRiza on 5/10/16.
//  Copyright (c) 2016 Kii. All rights reserved.
//

/** Class represents ScheduleOncePredicate. */
public struct ScheduleOncePredicate: Predicate {
    /** Specified schedule. */
    public let scheduleAt: Date

    public let eventSource: EventSource = EventSource.scheduleOnce

    /** Instantiate new ScheduleOncePredicate.

     -Parameter scheduleAt: Specify execution schedule. It must be future date.
     */
    public init(_ scheduleAt: Date) {
        self.scheduleAt = scheduleAt
    }

}
