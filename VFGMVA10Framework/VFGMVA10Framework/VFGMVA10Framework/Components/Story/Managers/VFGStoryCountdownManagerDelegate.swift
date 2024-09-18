//
//  VFGStoryCountdownManager.swift
//  VFGMVA10Framework
//
//  Created by Ihsan Kahramanoglu on 9.06.2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import Foundation

public protocol VFGStoryCountdownManagerDelegate: AnyObject {
    func updateLabel(isHidden: Bool, text: String, accessibilityLabel: String)
}

public enum VFGStoryCountdownFormat {
    case hourAndMinute
    case hourAndMinuteAndSecond
}

public class VFGStoryCountdownManager {
    public var delegate: VFGStoryCountdownManagerDelegate?

    private var endDate: Date
    private var timer: Timer?
    private var format: VFGStoryCountdownFormat

    public init(
        endDate: Date,
        format: VFGStoryCountdownFormat,
        delegate: VFGStoryCountdownManagerDelegate? = nil
    ) {
        self.endDate = endDate
        self.format = format
        self.delegate = delegate
    }

    public func startCountdownTimer() {
        var timeInterval: TimeInterval = 1
        switch format {
        case .hourAndMinute:
            timeInterval = 15
        case .hourAndMinuteAndSecond:
            timeInterval = 1
        }

        timer = Timer.scheduledTimer(
            timeInterval: timeInterval,
            target: self,
            selector: #selector(updateCountdownLabel),
            userInfo: nil,
            repeats: true
        )
        timer?.fire()
    }

    public func invalidateTimer() {
        timer?.invalidate()
        timer = nil
    }

    @objc private func updateCountdownLabel() {
        guard endDate.timeIntervalSinceNow.sign == .plus else {
            invalidateTimer()

            let labelText = self.getLabelText(
                hour: 0,
                minute: 0,
                second: 0)
            let accessibilityLabel = self.getLabelAccessiblityLabel(
                hour: 0,
                minute: 0,
                second: 0)
            delegate?.updateLabel(
                isHidden: true,
                text: labelText,
                accessibilityLabel: accessibilityLabel)
            return
        }

        let components = Calendar.current.dateComponents(
            [.hour, .minute, .second],
            from: Date(),
            to: endDate
        )
        guard
            let hour = components.hour,
            let minute = components.minute,
            let second = components.second
        else {
            invalidateTimer()
            return
        }

        let labelText = self.getLabelText(
            hour: hour,
            minute: minute,
            second: second)
        let accessibilityLabel = self.getLabelAccessiblityLabel(
            hour: hour,
            minute: minute,
            second: second)
        delegate?.updateLabel(
            isHidden: false,
            text: labelText,
            accessibilityLabel: accessibilityLabel)
    }

    private func getLabelText(
        hour: Int,
        minute: Int,
        second: Int
    ) -> String {
        switch format {
        case .hourAndMinute:
            return String(format: "%02d:%02d", hour, minute)
        case .hourAndMinuteAndSecond:
            return String(format: "%02d:%02d:%02d", hour, minute, second)
        }
    }

    private func getLabelAccessiblityLabel(
        hour: Int,
        minute: Int,
        second: Int
    ) -> String {
        switch format {
        case .hourAndMinute:
            return "countdown in \(hour) hours and \(minute) minutes"
        case .hourAndMinuteAndSecond:
            return "countdown in \(hour) hours and \(minute) minutes and \(second) seconds"
        }
    }
}
