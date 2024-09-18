//
//  VFGTimerManager.swift
//  VFGMVA10Foundation
//
//  Created by Ahmed AbdElnabi on 15/06/2022.
//

import Foundation

public class VFGTimerManager {
    private var counterOperations: VFGCounterOperations
    private var executive: VFGTimerExecutive
    private var backgroundCalculator: VFGBackgroundCalculator

    private var state: VFGTimerState = .none {
        willSet {
            executive.state = newValue
            backgroundCalculator.state = newValue
        }
    }

    public var countDownTime: TimeInterval = 0.0

    public var didStateChange: ((VFGTimerState) -> Void)?

    public var observeElapsedTime: ((TimeInterval) -> Void)?

    public var defaultValue: TimeInterval = 0 {
        willSet {
            let positiveValue = max(0, newValue)
            counterOperations.setDefaultValue(positiveValue)
        }
    }

    public var effectiveValue: TimeInterval = 2 {
        willSet {
            let positiveValue = max(0, newValue)
            counterOperations.setEffectiveValue(positiveValue)
        }
    }

    public var timeInterval: TimeInterval = 1 {
        willSet {
            let positiveValue = max(0, newValue)
            executive.setTimeInterval(positiveValue)
        }
    }

    public var currentState: VFGTimerState {
        return state
    }

    public init() {
        counterOperations = VFGCounterOperations()
        executive = VFGTimerExecutive()
        backgroundCalculator = VFGBackgroundCalculator()

        backgroundCalculator.observe = { [weak self] elapsedTime in
            guard let self = self else { return }
            self.calculateBackgroundTime(elapsedTime: elapsedTime)
        }
    }

    private func calculateBackgroundTime(elapsedTime: TimeInterval) {
        let subtraction = countDownTime - elapsedTime

        if subtraction.sign == .plus {
            counterOperations.setTotalCountedValue(subtraction)
        } else {
            counterOperations.setTotalCountedValue(1)
        }
    }

    private func countDown(seconds: TimeInterval) {
        guard
            effectiveValue >= 0,
            timeInterval >= 0
        else {
            fatalError("The time does not leading to valid format. Use valid effetiveValue/ timeInterval")
        }

        counterOperations.setTotalCountedValue(seconds)

        executive.observeValue = { [weak self] in
            guard let self = self else { return }
            guard self.counterOperations.totalCountedValue > 0
            else {
                self.executive.suspend()
                self.state = .finished
                self.didStateChange?(.finished)

                return
            }
            self.counterOperations.subtract()
            self.observeElapsedTime?(self.counterOperations.totalCountedValue)
        }
    }

    public func start() {
        executive.start {
            self.backgroundCalculator.setTimerFiredDate(Date())
        }
        countDown(seconds: countDownTime)
        state = .fired
        didStateChange?(.fired)
    }

    public func stop() {
        executive.suspend()
        state = .stopped
        didStateChange?(.stopped)
    }

    public func reset() {
        executive.suspend()
        counterOperations.resetTotalCountedValue()
        state = .restarted
        didStateChange?(.restarted)
    }

    public func resetToDefault() {
        executive.suspend()
        counterOperations.resetToDefaultValue()
        state = .restarted
        didStateChange?(.restarted)
    }
}
