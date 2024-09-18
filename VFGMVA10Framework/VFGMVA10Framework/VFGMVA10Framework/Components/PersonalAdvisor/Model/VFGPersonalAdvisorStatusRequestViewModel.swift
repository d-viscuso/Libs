//
//  VFGPersonalAdvisorStatusRequestViewModel.swift
//  VFGMVA10PersonalAdvisor
//
//  Created by Vasiliki Trachani, Vodafone on 17/08/2022.
//

import VFGMVA10Foundation

/// Personal Advisor Previous Status Request model for QuickActionsViewController
public struct VFGPersonalAdvisorStatusRequestViewModel {
    /// Result type of quick action model.
    var resultType: VFGResultViewType
    /// Title of quick action model.
    var title: String
    /// Description of quick action model.
    var description: String
    /// Title text of quick action model.
    var titleText: String
    /// Title text of quick action model.
    var primaryButton: String
    /// Title text of quick action model.
    var secondaryButton: String?
    public init(
        resultType: VFGResultViewType = .success,
        title: String = "",
        description: String = "",
        titleText: String = "",
        primaryButton: String = "",
        secondaryButton: String = ""
    ) {
        self.resultType = resultType
        self.title = title
        self.description = description
        self.titleText = titleText
        self.primaryButton = primaryButton
        self.secondaryButton = secondaryButton
    }
}
