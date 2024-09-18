//
//  VFGFailureTopUpViewModel.swift
//  VFGMVA10Framework
//
//  Created by Atta Ahmed on 3/24/21.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

class VFGFailureTopUpViewModel {
    var topUpStatus: TopUpStatus = .topUpMine
    var sectionTitle = ""
    var mainTitle = ""
    var subTitle = ""
    var primaryButtonTitle = ""
    var secondaryButtonTitle = ""
    var someOneElseIdentifier = ""

    private func setupTextForSomeOneElse() {
        sectionTitle = "top_up_someone_else_quick_action_failure_title".localized(
            bundle: .mva10Framework)
        subTitle = "top_up_someone_else_quick_action_failure_description".localized(
            bundle: .mva10Framework)
        primaryButtonTitle = "top_up_someone_else_quick_action_failure_primary_button_text".localized(
            bundle: .mva10Framework)
        secondaryButtonTitle = "top_up_someone_else_quick_action_failure_secondary_button_text".localized(
            bundle: .mva10Framework)
    }

    private func setupMainTitle() {
        if topUpStatus == .topUpSomeOneElse {
        mainTitle = String(
            format: "top_up_someone_else_quick_action_title_with_formatting".localized(bundle: .mva10Framework),
            arguments: [someOneElseIdentifier]
        )
        } else {
            mainTitle = "top_up_quick_action_main_title".localized(bundle: Bundle.mva10Framework)
        }
    }

    init (
        topUpStatus: TopUpStatus = .topUpMine,
        someOneElseIdentifier: String
    ) {
        self.topUpStatus = topUpStatus
        self.someOneElseIdentifier = someOneElseIdentifier
        setupTextForSomeOneElse()
        setupMainTitle()
    }
}
