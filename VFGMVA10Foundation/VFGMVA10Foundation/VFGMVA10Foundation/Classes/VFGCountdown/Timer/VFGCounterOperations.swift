//
//  CounterBehavior.swift
//  VFGMVA10Foundation
//
//  Created by Ahmed AbdElnabi on 15/06/2022.
//

import Foundation

class VFGCounterOperations {
    private(set) var totalCountedValue: TimeInterval = 0.0
    private(set) var effectiveValue: TimeInterval = 1.0
    private(set) var defaultValue: TimeInterval = 0.0 {
        willSet {
            totalCountedValue += newValue
        }
    }

    func subtract() {
        totalCountedValue = max(0, totalCountedValue - effectiveValue)
    }

    func resetTotalCountedValue() {
        totalCountedValue = 0
    }

    func setTotalCountedValue(_ value: TimeInterval) {
        totalCountedValue = value
    }

    func setEffectiveValue(_ value: TimeInterval) {
        effectiveValue = value
    }

    func setDefaultValue(_ value: TimeInterval) {
        defaultValue = value
    }

    func resetToDefaultValue() {
        totalCountedValue = defaultValue
    }
}
