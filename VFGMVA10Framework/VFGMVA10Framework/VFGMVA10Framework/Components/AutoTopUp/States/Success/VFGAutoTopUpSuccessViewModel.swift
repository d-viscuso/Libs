//
//  VFGAutoTopUpSuccessViewModel.swift
//  VFGMVA10Framework
//
//  Created by Moataz Akram on 13/09/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation
/// Auto top up success quick action view model
public class VFGAutoTopUpSuccessViewModel {
    /// Auto top up quick action title
    var mainTitle = ""
    /// Auto top up quick action success title
    var sectionTitle = "auto_top_up_quick_action_success_title".localized(bundle: .mva10Framework)
    /// Auto top up quick action success primary button text
    var buttonTitle = "auto_top_up_quick_action_success_primary_button_text".localized(bundle: .mva10Framework)
    /// Auto top up quick action success weekly description
    var subTitle = ""
    /// Auto top up type
    var autoTopUpType = ""
    /// Occurrence type
    var exactOcurrence = ""
    /// Selected amount to top up with
    var autoTopUpAmount: Double?
    /// Determine if auto bill is in editing mode or not
    var isEditingMode = false
    /// *VFGAutoTopUpSuccessViewModel* initializer
    /// - Parameters:
    ///    - autoTopUpType: Auto top up type
    ///    - exactOccurrence: Occurrence type
    ///    - autoTopUpAmount: Selected amount to top up with
    ///    - isEditingMode: Determine if auto bill is in editing mode or not
    init(
        autoTopUpType: String,
        exactOccurrence: String,
        autoTopUpAmount: Double,
        isEditingMode: Bool = false
    ) {
        self.autoTopUpType = autoTopUpType
        self.exactOcurrence = exactOccurrence
        self.autoTopUpAmount = autoTopUpAmount
        self.isEditingMode = isEditingMode
        setAutoTopUpSubtitle()
    }
    /// Localization configuration
    func setAutoTopUpSubtitle() {
        mainTitle = isEditingMode ?
            "auto_top_up_quick_action_edit_title".localized(bundle: Bundle.mva10Framework) :
            "auto_top_up_quick_action_title".localized(bundle: Bundle.mva10Framework)
        guard let autoTopUpAmount = autoTopUpAmount else { return }
        switch autoTopUpType {
        case AutoTopUpType.weekly:
            exactOcurrence = exactOcurrence.getFullDayName().capitalizingFirstLetter()
            subTitle = String(
                format: "auto_top_up_quick_action_success_weekly_description".localized(bundle: .mva10Framework),
                arguments: [String(describing: autoTopUpAmount), exactOcurrence]
            )
        case AutoTopUpType.monthly:
            subTitle = String(
                format: "auto_top_up_quick_action_success_monthly_description".localized(bundle: .mva10Framework),
                arguments: [String(describing: autoTopUpAmount), String(exactOcurrence)]
            )
        default:
            subTitle = String(
                format: "auto_top_up_quick_action_success_amount_description".localized(bundle: .mva10Framework),
                arguments: [String(describing: autoTopUpAmount), String(exactOcurrence)]
            )
        }
    }
}

extension String {
    /// Changes the day from SU to sunday
    func getFullDayName() -> String {
        let daysCellArray = [
            "auto_top_up_days_list_monday".localized(bundle: Bundle.mva10Framework),
            "auto_top_up_days_list_tuesday".localized(bundle: Bundle.mva10Framework),
            "auto_top_up_days_list_wednesday".localized(bundle: Bundle.mva10Framework),
            "auto_top_up_days_list_thursday".localized(bundle: Bundle.mva10Framework),
            "auto_top_up_days_list_friday".localized(bundle: Bundle.mva10Framework),
            "auto_top_up_days_list_saturday".localized(bundle: Bundle.mva10Framework),
            "auto_top_up_days_list_sunday".localized(bundle: Bundle.mva10Framework)
        ]
        let daysArray = [
            "auto_top_up_week_days_monday".localized(bundle: Bundle.mva10Framework),
            "auto_top_up_week_days_tuesday".localized(bundle: Bundle.mva10Framework),
            "auto_top_up_week_days_wednesday".localized(bundle: Bundle.mva10Framework),
            "auto_top_up_week_days_thursday".localized(bundle: Bundle.mva10Framework),
            "auto_top_up_week_days_friday".localized(bundle: Bundle.mva10Framework),
            "auto_top_up_week_days_saturday".localized(bundle: Bundle.mva10Framework),
            "auto_top_up_week_days_sunday".localized(bundle: Bundle.mva10Framework)
        ]
        return daysArray[daysCellArray.firstIndex(of: self) ?? 0]
    }
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + self.lowercased().dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
