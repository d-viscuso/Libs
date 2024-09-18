//
//  VFGDatePickerDataSource.swift
//  VFGMVA10Foundation
//
//  Created by Yahya Saddiq on 21/09/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

/// A data source protocol that manages the data in your date picker
/// It represents your data model and vends information to the date picker as needed
public protocol VFGDatePickerDataSource: AnyObject {
    /// Access specific day of week letter of given day number.
    /// - Parameters:
    ///   - view: Current date picker view associated with the data source.
    ///   - dayNumber: Day number used to specify day letter.
    func dayOfWeekLetter(_ view: VFGDatePicker, for dayNumber: Int) -> String
}
