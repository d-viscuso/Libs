//
//  TimerExecutive.swift
//  VFGMVA10Foundation
//
//  Created by Ahmed AbdElnabi on 15/06/2022.
//

import Foundation

class VFGTimerExecutive {
    var state: VFGTimerState = .none
    private var timer: Timer?
    private var timeInterval: TimeInterval = 1.0
    var observeValue: (() -> Void)?

    public func start(completion: (() -> Void)?) {
        guard state != .fired else { return }

        timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true) { [weak self] _ in
            self?.observeValue?()
        }
        guard let timer = timer else {
            completion?()
            return
        }
        state = .fired
        RunLoop.main.add(timer, forMode: .common)
        completion?()
    }

    public func suspend() {
        timer?.invalidate()
        state = .stopped
    }

    public func setTimeInterval(_ value: TimeInterval) {
        timeInterval = value
    }
}
