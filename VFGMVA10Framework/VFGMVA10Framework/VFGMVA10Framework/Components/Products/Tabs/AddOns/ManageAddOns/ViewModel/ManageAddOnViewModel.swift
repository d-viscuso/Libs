//
//  ManageAddOnViewModel.swift
//  VFGMVA10Framework
//
//  Created by Ahmed Sultan on 5/6/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation
import VFGMVA10Foundation

class ManageAddOnPlanViewModel {
    var actionType: ManageAddOnActions?
    weak var quickActionDelegate: VFQuickActionsProtocol?
    weak var confirmAlertDelegate: VFGTwoActionsViewProtocol?
    weak var resultViewDelegate: VFGResultViewProtocol?
    var addOn: AddOnsProductModel?
    var addOnPriceAttributedText: NSMutableAttributedString?
    var manageAddOnDataProvider: VFGManageAddOnDataProviderProtocol
    var activeResultViewType: VFGResultViewType?
    var resultViewModel: VFGQuickActionsResultModel?
    var confirmationViewMessageText: String?

    private lazy var quickActionsView = confirmationView

    private lazy var confirmationView: UIView = {
        guard let confirmationView: VFGTwoActionsView = UIView
            .loadXib(bundle: Bundle.foundation) else {
                return UIView()
        }
        confirmationView.delegate = confirmAlertDelegate

        let description = String(
            format: actionType?.quickActionConfirmationMessage ?? "",
            addOn?.title ?? "")
        let moreDetails = confirmationViewMessageText ?? String(
            format: actionType?.quickActionNoteMessage ?? "",
            getExpireDateFormatted() )
        let primaryButtonTitle = "manage_addon_action_confirm".localized(bundle: Bundle.mva10Framework)
        let secondaryButtonTitle = "manage_addon_action_cancel".localized(bundle: Bundle.mva10Framework)
        let titlesModel = VFGTitlesModel(
            description: description,
            moreDetails: moreDetails,
            primaryButtonTitle: primaryButtonTitle,
            secondaryButtonTitle: secondaryButtonTitle)
        let titlesFont = VFGTitlesFontModel(
            descriptionFont: .vodafoneLite(25),
            moreDetailsFont: .vodafoneRegular(15))
        let accessibilityIDsModel = VFGTwoActionsAccessibilityModel(
            primaryButton: "ADconfirmButton",
            secondaryButton: "ADcancelButton")
        confirmationView.configure(
            viewStyle: .white,
            titlesModel: titlesModel,
            titlesFontModel: titlesFont,
            accessibilityIDsModel: accessibilityIDsModel)
        return confirmationView
    }()

    private(set) lazy var resultSuccessView: UIView = {
        let resultView: VFGResultView? = VFGResultView.loadXib(bundle: .foundation)
        guard let resultView = resultView else {
            return UIView()
        }
        let resultViewModel = resultViewModel ?? VFGQuickActionsResultModel(
            type: .success,
            delegate: resultViewDelegate,
            titleText: actionType?.quickActionSuccessTitle ?? "",
            descriptionText: actionType?.quickActionSuccessSubtitle ?? "",
            primaryButtonTitle: "addons_buy_modal_success_primary_button_title".localized(bundle: .mva10Framework),
            secondaryButtonTitle: "addons_buy_modal_success_secondary_button_title".localized(bundle: .mva10Framework),
            titleFont: .vodafoneBold(25),
            descriptionFont: .vodafoneRegular(16.6))
        let accessibilityVoiceOverModel = VFGResultViewAccessibilityVoiceOverModel(
            imageViewLabel: nil,
            animationViewLabel: "Check mark animated view")
        resultView.configure(
            model: resultViewModel,
            accessibilityVoiceOverModel: accessibilityVoiceOverModel
        )
        return resultView
    }()

    private(set) lazy var resultFailureView: UIView = {
        let resultView: VFGResultView? = VFGResultView.loadXib(bundle: .foundation)
        guard let resultView = resultView else {
            return UIView()
        }
        let resultViewModel = resultViewModel ?? VFGQuickActionsResultModel(
            type: .failure,
            delegate: resultViewDelegate,
            titleText: "addons_buy_modal_failure_title".localized(bundle: .mva10Framework),
            descriptionText: actionType?.quickActionFailureSubtitle ?? "",
            primaryButtonTitle: "addons_buy_modal_failure_primary_button_title".localized(bundle: .mva10Framework),
            secondaryButtonTitle: "addons_buy_modal_failure_secondary_button_title".localized(bundle: .mva10Framework),
            titleFont: .vodafoneBold(25),
            descriptionFont: .vodafoneRegular(16.6))
        let accessibilityVoiceOverModel = VFGResultViewAccessibilityVoiceOverModel(
            imageViewLabel: "Failure warning view",
            animationViewLabel: nil)
        resultView.configure(
            model: resultViewModel,
            accessibilityVoiceOverModel: accessibilityVoiceOverModel
        )
        return resultView
    }()

    init(
        manageAddOnDataProvider: VFGManageAddOnDataProviderProtocol,
        addOn: AddOnsProductModel,
        actionType: ManageAddOnActions,
        confirmAlertDelegate: VFGTwoActionsViewProtocol? = nil,
        resultViewDelegate: VFGResultViewProtocol? = nil
    ) {
        self.manageAddOnDataProvider = manageAddOnDataProvider
        self.addOn = addOn
        self.actionType = actionType
        self.confirmAlertDelegate = confirmAlertDelegate
        self.resultViewDelegate = resultViewDelegate
    }

    func changeQuickActionContentView(to view: UIView) {
        quickActionsView = view
    }
}

// MARK: - Data provider operations
extension ManageAddOnPlanViewModel {
    func updateAddOnDetails(completion: (() -> Void)? = nil) {
        guard let addOn = addOn else { return }
        manageAddOnDataProvider.updateAddOnDetails(addOn: addOn) { error in
            guard error == nil else {
                VFGErrorLog(String(describing: error?.localizedDescription))
                return
            }
            completion?()
        }
    }
    func removeAddOn(completion: ManageAddOnCompletion? = nil) {
        guard let addOnId = addOn?.identifier else { return }
        manageAddOnDataProvider.removeAddOn(addOnId: addOnId) { [weak self] error in
            if let resultModel = self?.manageAddOnDataProvider.resultModel {
                self?.resultViewModel = VFGQuickActionsResultModel(
                    type: error == nil ? .success : .failure,
                    delegate: self?.resultViewDelegate,
                    titleText: resultModel.title,
                    descriptionText: resultModel.descriptionText,
                    primaryButtonTitle: resultModel.primaryButtonTitle,
                    secondaryButtonTitle: resultModel.secondaryButtonTitle,
                    titleFont: .vodafoneBold(25),
                    descriptionFont: .vodafoneRegular(16.6))
            }
            completion?(error)
        }
    }

    func buyAddOn(completion: ManageAddOnCompletion? = nil) {
        guard let addOnId = addOn?.identifier else { return }
        manageAddOnDataProvider.buyAddOn(addOnId: addOnId) { [weak self] error in
            if let resultModel = self?.manageAddOnDataProvider.resultModel {
                self?.resultViewModel = VFGQuickActionsResultModel(
                    type: error == nil ? .success : .failure,
                    delegate: self?.resultViewDelegate,
                    titleText: resultModel.title,
                    descriptionText: resultModel.descriptionText,
                    primaryButtonTitle: resultModel.primaryButtonTitle,
                    secondaryButtonTitle: resultModel.secondaryButtonTitle,
                    titleFont: .vodafoneBold(25),
                    descriptionFont: .vodafoneRegular(16.6))
            }
            completion?(error)
        }
    }
}
// MARK: - Manage Action operations
public enum ManageAddOnActions {
    case buy
    case remove
    case edit

    var buttonActionTitle: String {
        switch self {
        case .buy:
            return "manage_addon_buy_action_button_title".localized(bundle: Bundle.mva10Framework)
        case .remove:
            return "manage_addon_remove_action_button_title".localized(bundle: Bundle.mva10Framework)
        default:
            return ""
        }
    }

    var autoRenewTitle: String {
        return "manage_addon_renew_title".localized(bundle: Bundle.mva10Framework)
    }

    var dateLabelTitle: String {
        switch self {
        case .buy:
            return "manage_addon_buy_date_title".localized(bundle: Bundle.mva10Framework)
        case .remove:
            return "manage_addon_remove_date_title".localized(bundle: Bundle.mva10Framework)
        default:
            return ""
        }
    }
    var quickActionTitle: String {
        switch self {
        case .buy:
            return "manage_addon_buy_quick_action_title".localized(bundle: Bundle.mva10Framework)
        case .remove:
            return "manage_addon_remove_quick_action_title".localized(bundle: Bundle.mva10Framework)
        default:
            return ""
        }
    }

    var quickActionConfirmationMessage: String {
        switch self {
        case .buy:
            return "manage_addon_buy_confirm_message".localized(bundle: Bundle.mva10Framework)
        case .remove:
            return "manage_addon_remove_confirm_message".localized(bundle: Bundle.mva10Framework)
        default:
            return ""
        }
    }

    var quickActionNoteMessage: String {
        switch self {
        case .buy:
            return "manage_addon_buy_more_details".localized(bundle: Bundle.mva10Framework)
        case .remove:
            return "manage_addon_remove_more_details".localized(bundle: Bundle.mva10Framework)
        default:
            return ""
        }
    }

    var quickActionSuccessTitle: String {
        switch self {
        case .buy:
            return "addons_buy_modal_success_title".localized(bundle: .mva10Framework)
        case .remove:
            return "addons_remove_modal_success_title".localized(bundle: .mva10Framework)
        default:
            return ""
        }
    }

    var quickActionSuccessSubtitle: String {
        switch self {
        case .buy:
            return "addons_buy_modal_success_subtitle".localized(bundle: .mva10Framework)
        case .remove:
            return "addons_remove_modal_success_subtitle".localized(bundle: .mva10Framework)
        default:
            return ""
        }
    }

    var quickActionFailureSubtitle: String {
        switch self {
        case .buy:
            return "addons_buy_modal_failure_subtitle".localized(bundle: .mva10Framework)
        case .remove:
            return "addons_remove_modal_failure_subtitle".localized(bundle: .mva10Framework)
        default:
            return ""
        }
    }
}
// MARK: - Quick Action operations
extension ManageAddOnPlanViewModel: VFQuickActionsModel {
    var quickActionsStyle: VFQuickActionsStyle {
        return .white
    }
    var quickActionsTitle: String {
        return actionType?.quickActionTitle ?? ""
    }

    var quickActionsContentView: UIView {
        quickActionsView
    }

    func quickActionsProtocol(delegate: VFQuickActionsProtocol) {
        quickActionDelegate = delegate
    }

    func closeQuickAction() {
        quickActionDelegate?.closeQuickAction(completion: nil)
    }

    func closeQuickAction(_ completion: (() -> Void)?) {
        quickActionDelegate?.closeQuickAction(completion: completion)
    }

    func getExpireDateFormatted() -> String {
        return VFGDateHelper.changeDateStringFormat(
            dateString: addOn?.addOnDetails?.expirationDate ?? "",
            format: "dd/MM/yyyy",
            dateFormatString: "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ") ?? ""
    }
}
