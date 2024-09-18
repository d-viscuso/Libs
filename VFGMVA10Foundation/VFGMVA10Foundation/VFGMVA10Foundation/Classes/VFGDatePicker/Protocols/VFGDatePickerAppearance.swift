//
//  VFGDatePickerAppearance.swift
//  VFGMVA10Foundation
//
//  Created by Yahya Saddiq on 22/09/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

/// An appearance protocol that manages the layout of your date picker
/// You can customize today, selected, selected range, default and disabled date picker cell styles
public protocol VFGDatePickerAppearance: AnyObject {
    /// Customize today date picker cell style.
    /// - Parameter cell: Date picker collection view cell.
    func applyTodayStyle(for cell: VFGDatePickerCollectionViewCell)
    /// Customize selected date picker cell style.
    /// - Parameter cell: Date picker collection view cell.
    func applySelectedStyle(for cell: VFGDatePickerCollectionViewCell)
    /// Customize selected range date picker cell style.
    /// - Parameter cell: Date picker collection view cell.
    func applySelectedRangeStyle(for cell: VFGDatePickerCollectionViewCell)
    /// Customize default date picker cell style.
    /// - Parameter cell: Date picker collection view cell.
    func applyDefaultStyle(for cell: VFGDatePickerCollectionViewCell)
    /// Customize disabled date picker cell style.
    /// - Parameter cell: Date picker collection view cell.
    func applyDisabledStyle(for cell: VFGDatePickerCollectionViewCell)
}

public extension VFGDatePickerAppearance {
    func applyTodayStyle(for cell: VFGDatePickerCollectionViewCell) {
        cell.accessibilityTraits.remove(.selected)
        cell.accessibilityHint = nil

        cell.numberLabel.textColor = cell.isSmallScreenSize ? .systemRed : .VFGPrimaryText
        cell.numberLabel.font = UIFont.vodafoneRegular(14.6)
        cell.selectionBackgroundView.isHidden = true
        cell.rangeSelectionBackgroundView.isHidden = true
        cell.todayBackgroundView.isHidden = false
    }

    func applySelectedStyle(for cell: VFGDatePickerCollectionViewCell) {
        cell.accessibilityTraits.insert(.selected)
        cell.accessibilityHint = nil

        cell.numberLabel.textColor = cell.isSmallScreenSize ? .VFGRedText : .VFGWhiteText
        cell.numberLabel.font = UIFont.vodafoneBold(14.6)
        cell.selectionBackgroundView.isHidden = cell.isSmallScreenSize
        cell.rangeSelectionBackgroundView.isHidden = true
        cell.todayBackgroundView.isHidden = true
        cell.todayBackgroundView.isHidden = !(cell.day?.isToday ?? false)
    }

    func applySelectedRangeStyle(for cell: VFGDatePickerCollectionViewCell) {
        cell.accessibilityTraits.insert(.selected)
        cell.accessibilityHint = nil

        guard let day = cell.day else {
            return
        }

        cell.numberLabel.textColor = day.isFirstSelected || day.isLastSelected ? .VFGWhiteText : .VFGPrimaryText
        cell.numberLabel.font = (day.isFirstSelected || day.isLastSelected)
            ? UIFont.vodafoneBold(14.6)
            : UIFont.vodafoneRegular(14.6)
        cell.selectionBackgroundView.isHidden = !(day.isFirstSelected || day.isLastSelected)
        cell.rangeSelectionBackgroundView.isHidden = false
        cell.todayBackgroundView.isHidden = !(cell.day?.isToday ?? false)
    }

    func applyDefaultStyle(for cell: VFGDatePickerCollectionViewCell) {
        cell.accessibilityTraits.remove(.selected)
        cell.accessibilityHint = "Tap to select"

        guard let day = cell.day else {
            return
        }

        cell.numberLabel.textColor = day.isWithinDisplayedMonth ? .VFGPrimaryText : .VFGSecondaryText
        cell.numberLabel.font = UIFont.vodafoneRegular(14.6)
        cell.selectionBackgroundView.isHidden = true
        cell.rangeSelectionBackgroundView.isHidden = true
        cell.todayBackgroundView.isHidden = true
    }

    func applyDisabledStyle(for cell: VFGDatePickerCollectionViewCell) {
        cell.accessibilityTraits.remove(.selected)
        cell.accessibilityHint = nil

        cell.numberLabel.textColor = .VFGPlatinumText
        cell.numberLabel.font = UIFont.vodafoneRegular(14.6)
        cell.selectionBackgroundView.isHidden = true
        cell.rangeSelectionBackgroundView.isHidden = true
        cell.todayBackgroundView.isHidden = true
    }
}
