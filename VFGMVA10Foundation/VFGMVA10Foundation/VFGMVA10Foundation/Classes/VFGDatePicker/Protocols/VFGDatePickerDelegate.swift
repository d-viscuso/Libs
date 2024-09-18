//
//  VFGDatePickerDelegate.swift
//  VFGMVA10Foundation
//
//  Created by Yahya Saddiq on 14/09/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

/// A delegate protocol manages user interactions with the location picker's contents,
/// including date and range selection
public protocol VFGDatePickerDelegate: AnyObject {
    /// Notify the delegate once a date is selected.
    /// - Parameters:
    ///   - view: Current date picker view associated with the delegate.
    ///   - date: Selected date.
    func datePicker(_ view: VFGDatePicker, dateDidSelect date: Date)
    /// Notify the delegate once a range of dates are selected.
    /// - Parameters:
    ///   - view: Current date picker view associated with the delegate.
    ///   - startDate: Start date on which the range begins.
    ///   - endDate: End date on which the range ends.
    func datePicker(_ view: VFGDatePicker, rangeDidSelect startDate: Date, _ endDate: Date)
}

public extension VFGDatePickerDelegate {
    func datePicker(_ view: VFGDatePicker, dateDidSelect date: Date) {}
    func datePicker(_ view: VFGDatePicker, rangeDidSelect startDate: Date, _ endDate: Date) {}
}
