//
//  BalanceViewModel.swift
//  VFGMVA10Group
//
//  Created by Sandra Morcos on 11/18/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import Foundation

/// Balance card model.
public struct BalanceViewModel {
    /// Balance type: data, money etc..
    public let usageType: UsageType?
    /// Balance card title, computed property returns *usageType* title.
    public var title: String? {
        return usageType?.title
    }
    /// Balance card image name in assets, computed property returns *usageType* imageName.
    public var imageName: String? {
        return usageType?.imageName
    }
    private let remainingValue: Double?
    /// Remaining value of the balance as a string.
    public var remainingValueString: String? {
        guard let remainingValue = remainingValue else {
            return nil
        }
        guard remainingValue.decimalPart() == 0 else {
            return String(remainingValue)
        }
        return String(Int(remainingValue))
    }
    private var totalValue: Double?
    /// Total value of the balance as a string.
    public var totalValueString: String?
    /// Units.
    public var units: String?
    /// Remaining period.
    public var remainingPeriodText: String?
    /// Roaming icon image name in assets.
    public var roamingIcon: String?

    public var totalValueDescription: String? {
        guard let description = usageType?.totalDescription.localized(bundle: Bundle.mva10Framework),
            let totalValue = totalValueString else {
                return nil
        }
        return String(format: description, totalValue)
    }

    /// Computed property returns the progress ratio of the balance depending on it's *remaining*.
    public var progressRatio: Float {
        if usageType == .unlimited {
            return 1.0
        }
        guard let remaining = remainingValue,
            let total = totalValue else {
                return 1.0
        }
        return Float(remaining / total)
    }

    public init(_ usageCard: BalanceAndProductsModel.Bucket) {
        usageType = UsageType(rawValue: usageCard.usageType ?? "")

        if let totalAmount = usageCard.bucketCounter?[0].value?.amount {
            totalValue = totalAmount
        }

        if let totalUnit = usageCard.bucketCounter?[0].value?.units {
            units = totalUnit
        }

        totalValueString = "\(Int(totalValue ?? 0.0)) \(units?.localized() ?? "")"

        remainingValue = usageCard.bucketBalance?[0].remainingValue?.amount
        if usageType == .roaming {
            remainingPeriodText = "usage_card_roaming_text".localized()
            roamingIcon = "usage_card_roaming_icon".localized()
        } else {
            remainingPeriodText = parseEndDateTime(usageCard.bucketBalance?[0].validfor?.endDateTime)
        }
    }

    func parseEndDateTime(_ endDateTimeString: String?) -> String {
        guard let endDateTimeString = endDateTimeString else {
            return ""
        }

        if let remainingDays = remainingPeriod(to: endDateTimeString, ofComponent: .day) {
            return localizeRemainingPeriod(remainingPeriod: remainingDays > 0 ? remainingDays : 1)
        }

        return ""
    }

    func remainingPeriod(to endDateTimeString: String, ofComponent component: Calendar.Component) -> Int? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let now = Date()

        if let endDateTime = dateFormatter.date(from: endDateTimeString) {
            if component == .day,
                let remainingDays = Calendar.current.dateComponents([.day], from: now, to: endDateTime).day {
                // 1 day is added to the remianingDays to consider the last 24 hours as a day
                return remainingDays + 1
            } else if component == .hour,
                let remainingHours = Calendar.current.dateComponents([.hour], from: now, to: endDateTime).hour {
                return remainingHours
            }
        }
        return nil
    }

    func localizeRemainingPeriod(remainingPeriod: Int) -> String {
        var localizedString: String

        if usageType == .unlimited {
            localizedString = "usage_card_unlimited_description".localized()
        } else {
            if remainingPeriod == 1 {
                localizedString = "usage_card_resets_in_day".localized(bundle: Bundle.mva10Framework)
            } else {
                localizedString = "usage_card_resets_in_days".localized(bundle: Bundle.mva10Framework)
            }
        }

        return String(format: localizedString, "\(remainingPeriod)")
    }
}
