//
//  Refreshable.swift
//  VFGMVA10Group
//
//  Created by Yahya Saddiq on 10/16/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//
import Foundation
/// Protocol for refresh footer view
@objc protocol AutoRefreshable {
    /// Auto refresh time in seconds
    var autoRefreshIntervalInSeconds: Double { get set }
    /// Auto refresh timer
    var timer: Timer? { get set }
    /// Next time auto refresh will happen
    var nextRefreshDate: Date? { get set }
    /// Reload dashboard after auto refresh starts
    @objc func refreshDashboard(_ sender: Any)
}

extension AutoRefreshable {
    /// Starts time-based refresh
    func scheduleAutoRefresh() {
        guard autoRefreshIntervalInSeconds > 0 else {
            return
        }

        timer?.invalidate()
        let remainingTimeInterval = nextRefreshDate?.timeIntervalSinceNow
        timer = Timer.scheduledTimer(
            timeInterval: remainingTimeInterval ?? autoRefreshIntervalInSeconds,
            target: self,
            selector: #selector(refreshDashboard(_:)),
            userInfo: nil,
            repeats: false)
        nextRefreshDate = nil
    }

    /// Stops time-based refresh
    func descheduleAutoRefresh() {
        guard
            let timer = timer,
            timer.isValid else {
            return
        }
        // nextRefreshDate is used to calcualte remaining timeInterval
        nextRefreshDate = timer.fireDate
        timer.invalidate()
    }
}
