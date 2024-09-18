//
//  BackgroundCalculator.swift
//  VFGMVA10Foundation
//
//  Created by Ahmed AbdElnabi on 15/06/2022.
//

import Foundation
import UIKit

class VFGBackgroundCalculator {
    public var timerFireDate: Date?
    public var observe: ((TimeInterval) -> Void)?
    public var state: VFGTimerState = .none

    init() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(willEnterForegroundNotification),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
    }

    @objc private func willEnterForegroundNotification() {
        if state == .fired {
            if let timeInterval = calculateDateDifference() {
                observe?(timeInterval)
            }
        }
    }

    private func calculateDateDifference() -> TimeInterval? {
        guard let timerFireDate = timerFireDate else { return nil }
        let validTimeSubtraction = abs(
            timerFireDate.timeIntervalSinceReferenceDate -
            Date().timeIntervalSinceReferenceDate
        )
        return TimeInterval(validTimeSubtraction)
    }

    public func invalidateFiredDate() {
        timerFireDate = nil
    }

    public func setTimerFiredDate(_ value: Date) {
        timerFireDate = value
    }
}
