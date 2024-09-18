//
//  VFGCowntdownDataSource.swift
//  VFGMVA10Foundation
//
//  Created by Ahmed AbdElnabi on 19/06/2022.
//

import Foundation

public protocol VFGCountdownDataSource: AnyObject {
    /// An amount of time between two given points in time which appeared in days, hours, minutes and seconds
    /// - Parameter view: Current countdown view associated with the data source.
    /// - Returns: An amount of time between two given points of type TimeInterval which is double.
    func countdownTime(_ view: VFGCountdownView) -> TimeInterval
    /// A default amount of time between two given points in time which appeared in days, hours, minutes and seconds
    /// - Parameter view: Current countdown view associated with the data source.
    /// - Returns: Default amount of time of type TimeInterval which is double.
    func defaultCountdownTime(_ view: VFGCountdownView) -> TimeInterval
    /// An amount of time which is subtracted from the total countdown time
    /// - Parameter view: Current countdown view associated with the data source.
    /// - Returns: Effective amount of time of type TimeInterval  which is double and is used in calculate the new total counted value.
    func effectiveValue(_ view: VFGCountdownView) -> TimeInterval
    /// A time interval which is used by timer to schedule time event.
    /// - Parameter view: Current countdown view associated with the data source.
    /// - Returns: A time interval value which is used by timer to schedule time event.
    func timeInterval(_ view: VFGCountdownView) -> TimeInterval
    /// A string which represents the days text.
    /// - Parameter view: Current countdown view associated with the data source.
    /// - Returns: A string value which represents the days text.
    func daysText(_ view: VFGCountdownView) -> String
    /// A string which represents the hours text.
    /// - Parameter view: Current countdown view associated with the data source.
    /// - Returns: A string value which represents the hours text.
    func hoursText(_ view: VFGCountdownView) -> String
    /// A string which represents the minutes text.
    /// - Parameter view: Current countdown view associated with the data source.
    /// - Returns: A string value which represents the minutes text.
    func minutesText(_ view: VFGCountdownView) -> String
    /// A string which represents the seconds text.
    /// - Parameter view: Current countdown view associated with the data source.
    /// - Returns: A string value which represents the seconds text.
    func secondsText(_ view: VFGCountdownView) -> String
}

extension VFGCountdownDataSource {
    public func defaultCountdownTime(_ view: VFGCountdownView) -> TimeInterval {
        return 0
    }

    public func effectiveValue(_ view: VFGCountdownView) -> TimeInterval {
        return 1
    }

    public func timeInterval(_ view: VFGCountdownView) -> TimeInterval {
        return 1
    }

    public func daysText(_ view: VFGCountdownView) -> String {
        return "days"
    }

    public func hoursText(_ view: VFGCountdownView) -> String {
        return "hrs"
    }

    public func minutesText(_ view: VFGCountdownView) -> String {
        return "mins"
    }

    public func secondsText(_ view: VFGCountdownView) -> String {
        return "secs"
    }
}
