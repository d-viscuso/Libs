//
//  VFGSuccessTopUpViewModel.swift
//  VFGMVA10Framework
//
//  Created by Esraa Eldaltony on 1/6/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation
import VFGMVA10Foundation

class VFGSuccessTopUpViewModel {
    weak var topUpDelegate: VFGTopUpProtocol?
    weak var quickActionDelegate: VFQuickActionsProtocol?
    var addDataSuccess: Bool?
    var entryPoint: TopUpEntryPoint = .discoveryCard
    var balance: Int
    var topUpStatus: TopUpStatus
    var someOneElseIdentifier = ""
    var sectionTitle = ""
    var subTitle = ""
    var buttonTitle = ""
    var mainTitle = "top_up_quick_action_main_title".localized(bundle: .mva10Framework)

    init(
        topUpDelegate: VFGTopUpProtocol?,
        topUpStatus: TopUpStatus = .topUpMine,
        someOneElseIdentifier: String = "",
        addDataSuccess: Bool = false,
        entryPoint: TopUpEntryPoint = .discoveryCard,
        balance: Int
    ) {
        self.addDataSuccess = addDataSuccess
        self.entryPoint = entryPoint
        self.balance = balance
        self.topUpDelegate = topUpDelegate
        self.topUpStatus = topUpStatus
        self.someOneElseIdentifier = someOneElseIdentifier
        self.setLocalizedUIElementContent()
    }

    private func setLocalizedUIElementContent() {
        switch entryPoint {
        case .topUpTile, .basicTopUpTile:
            setContentWithCloseAndSuccessful()
            setSubTitleWithBalance()
        default:
            setContentWithCloseAndSuccessful()
            if addDataSuccess ?? false {
                setSubTitleWithBanalaceAndData()
            } else {
                setSubTitleWithBalance()
            }
        }
    }

    func setSubTitleWithBalance() {
        if topUpStatus == .topUpSomeOneElse {
            subTitle = String(
                format: "top_up_someone_else_successful_description".localized(bundle: .mva10Framework),
                arguments: [
                    String(balance),
                    String(topUpDelegate?.model?.currency ?? "$"),
                    someOneElseIdentifier
                ])
            mainTitle = String(
                format: "top_up_someone_else_quick_action_title_with_formatting".localized(bundle: .mva10Framework),
                arguments: [someOneElseIdentifier]
            )
        } else {
            if balance < Int(topUpDelegate?.model?.minOfferAmount ?? 0) {
            subTitle = String(
                format: "top_up_quick_action_balance".localized(bundle: Bundle.mva10Framework),
                arguments: [
                    String(balance),
                    String(topUpDelegate?.model?.currency ?? ""),
                    String(topUpDelegate?.model?.remainingData ?? "0"),
                    String(topUpDelegate?.model?.dataUnit ?? "")
                ])
            } else {
                subTitle = String(
                    format: "top_up_quick_action_balance_and_ramaining".localized(bundle: Bundle.mva10Framework),
                    arguments: [
                        String(topUpDelegate?.model?.balance ?? 0),
                        String(topUpDelegate?.model?.currency ?? ""),
                        String(topUpDelegate?.model?.remainingData ?? "0"),
                        String(topUpDelegate?.model?.dataUnit ?? "")
                    ])
            }
        }
    }

    func setSubTitleWithBanalaceAndData() {
        let modelRemainingBalance = topUpDelegate?.model?.remainingData ?? "0"
        let modelUnit = String(topUpDelegate?.model?.dataUnit ?? "")
        subTitle = String(
            format: "top_up_quick_action_data_added_remaining".localized(bundle: Bundle.mva10Framework),
            arguments: [
                modelRemainingBalance, modelUnit
            ])
    }

    func setContentWithCloseAndSuccessful() {
        buttonTitle = "top_up_quick_action_return_to_dashboard_button_text".localized(bundle: .mva10Framework)
        sectionTitle = "top_up_quick_action_successful".localized(bundle: .mva10Framework)
    }
}
