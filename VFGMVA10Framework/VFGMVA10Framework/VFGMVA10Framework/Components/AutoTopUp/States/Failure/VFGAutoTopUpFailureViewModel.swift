//
//  VFGAutoTopUpFailureViewModel.swift
//  VFGMVA10Framework
//
//  Created by Moataz Akram on 27/09/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation
/// Auto top up failure quick action view model
class VFGAutoTopUpFailureViewModel {
    /// Auto top up quick action failure title
    var sectionTitle = "auto_top_up_quick_action_failure_title".localized(bundle: Bundle.mva10Framework)
    /// Auto top up quick action title
    var mainTitle = ""
    /// Auto top up quick action failure description
    var subTitle = "auto_top_up_quick_action_failure_description".localized(bundle: Bundle.mva10Framework)
    /// Auto top up quick action failure primary button text
    var primaryButtonTitle = "auto_top_up_quick_action_failure_primary_button_text"
        .localized(bundle: Bundle.mva10Framework)
    /// Auto top up quick action failure secondary button text
    var secondaryButtonTitle = "auto_top_up_quick_action_failure_secondary_button_text"
        .localized(bundle: Bundle.mva10Framework)
    /// Determine if auto bill is in editing mode or not
    var isEditingMode = false
    /// *VFGAutoTopUpFailureViewModel* initializer
    /// - Parameters:
    ///    - isEditingMode: Determine if auto bill is in editing mode or not
    init(isEditingMode: Bool = false) {
        self.isEditingMode = isEditingMode
        setupLocalization()
    }
    /// Localization setup
    func setupLocalization() {
        mainTitle = isEditingMode ?
            "auto_top_up_quick_action_edit_title".localized(bundle: Bundle.mva10Framework) :
            "auto_top_up_quick_action_title".localized(bundle: Bundle.mva10Framework)
    }
}
