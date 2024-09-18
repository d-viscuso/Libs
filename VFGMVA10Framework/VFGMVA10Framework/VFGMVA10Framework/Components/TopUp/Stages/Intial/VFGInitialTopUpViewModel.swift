//
//  VFGInitialTopUpViewModel.swift
//  VFGMVA10Framework
//
//  Created by Yahya Saddiq on 12/17/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import Foundation
import VFGMVA10Foundation

class VFGInitialTopUpViewModel {
    var giftImageName: String?
    weak var topUpDelegate: VFGTopUpProtocol? {
        didSet {
            giftImageName = topUpDelegate?.model?.timedOffer ?? false ? "icClock" : "all_rewards"
        }
    }
    var entryPoint: TopUpEntryPoint = .discoveryCard
    var amountPickerAxis: TopupAmountPickerAxis
    var childAccount: VFGAccount?
    var otherContactNumber: String?
    var quickActionAttributedTitleText: NSAttributedString?
    var quickActionHeaderButtonTitleText: String?
    var quickActionHeaderButtonCustomText: String?
    weak var delegate: VFGTopUpStateInternalProtocol?
    lazy var topUpActionView: VFGInitialTopUpView? = {
        guard let topUpActionView: VFGInitialTopUpView = UIView.loadXib(bundle: Bundle.mva10Framework) else {
            return VFGInitialTopUpView()
        }
        return topUpActionView
    }()
    var subTitle = ""
    var tabTitles: [String] = []
    var paymentMethodTitle = ""
    var buttonTitle = ""
    var editLabel = ""
    var withCustomAmount = false
    var textFieldUpperHint = ""
    var textFieldHint = ""
    var textFieldLowerHint = ""
    var textFieldCurrencyText = ""
    var textFieldErrorMessage = ""
    var amountThreshold = 0
    var isEditingMode = false
    var activeAutoTopUpModel: VFGActiveAutoTopUpProtocol?

    weak var autoTopUpDelegate: VFGAutoTopUpStateInternalProtocol?

    init (
        topUpDelegate: VFGTopUpProtocol?,
        delegate: VFGTopUpStateInternalProtocol?,
        withCustomAmount: Bool = false,
        entryPoint: TopUpEntryPoint = .discoveryCard,
        amountPickerAxis: TopupAmountPickerAxis = .vertical
    ) {
        self.topUpDelegate = topUpDelegate
        self.delegate = delegate
        self.entryPoint = entryPoint
        self.amountPickerAxis = amountPickerAxis
        self.withCustomAmount = withCustomAmount
        setLocalizedUIElementContent()
        setupAmountThreshold()
        DispatchQueue.main.async {
            self.delegate?.initialTopupPresent()
        }
    }

    init(
        topUpDelegate: VFGTopUpProtocol?,
        autoTopUpDelegate: VFGAutoTopUpStateInternalProtocol,
        isEditingMode: Bool = false,
        activeAutoTopUpModel: VFGActiveAutoTopUpProtocol? = nil
    ) {
        self.topUpDelegate = topUpDelegate
        self.autoTopUpDelegate = autoTopUpDelegate
        self.isEditingMode = isEditingMode
        self.activeAutoTopUpModel = activeAutoTopUpModel
        entryPoint = .autoTopUp
        amountPickerAxis = .vertical
        setLocalizedUIElementContent()
    }

    func getUserName() -> String? {
        return topUpDelegate?.model?.relatedParty?.first?.name
    }

    func setupAmountThreshold() {
        amountThreshold = topUpDelegate?.model?.amountThreshold ?? 0
    }

    private func setupSubtitle() {
        let currency = String(topUpDelegate?.model?.currency ?? "")
        let minOfferAmount = String(topUpDelegate?.model?.minOfferAmount ?? 0)
        let dataOfferAmount = String(topUpDelegate?.model?.dataOfferAmount ?? 0)
        let offerAmount = String(topUpDelegate?.model?.offerAmount ?? 0)
        if let subtitleText = topUpDelegate?.model?.subtitle {
            subTitle = subtitleText
        } else if entryPoint == .discoveryCard {
            subTitle =
                String(
                    format: "top_up_quick_action_offer_subtitle".localized(bundle: Bundle.mva10Framework),
                    arguments:
                        [
                            minOfferAmount,
                            currency,
                            dataOfferAmount,
                            topUpDelegate?.model?.dataUnit ?? "",
                            topUpDelegate?.model?.offerDescription?.localized(bundle: Bundle.mva10Framework) ?? "",
                            offerAmount,
                            currency
                        ]
                )
        } else {
            subTitle = "top_up_quick_action_subtitle".localized(bundle: Bundle.mva10Framework)
        }
    }

    func setupAmountTextFieldLocalization() {
        textFieldUpperHint = "custom_auto_top_up_field_upper_hint".localized(bundle: Bundle.mva10Framework)
        textFieldHint = "custom_auto_top_up_field_hint".localized(bundle: Bundle.mva10Framework)
        let lowerHint = "custom_auto_top_up_field_lower_hint".localized(bundle: Bundle.mva10Framework)
        textFieldLowerHint = String(
            format: lowerHint,
            "\(topUpDelegate?.model?.amountThreshold ?? 0)",
            "\(topUpDelegate?.model?.currency ?? "")"
        )
        textFieldCurrencyText = topUpDelegate?.model?.currency ?? ""
        let errorMessage = "custom_auto_top_up_field_lower_hint_error".localized(bundle: Bundle.mva10Framework)
        textFieldErrorMessage = String(
            format: errorMessage,
            "\(topUpDelegate?.model?.amountThreshold ?? 0)",
            "\(topUpDelegate?.model?.currency ?? "")"
        )
    }

    private func setLocalizedUIElementContent() {
        tabTitles.append("custom_auto_top_up_first_tab".localized(bundle: Bundle.mva10Framework))
        tabTitles.append("custom_auto_top_up_second_tab".localized(bundle: Bundle.mva10Framework))
        paymentMethodTitle = "top_up_quick_action_payment_method_title".localized(bundle: Bundle.mva10Framework)
        editLabel = "top_up_quick_action_edit".localized(bundle: Bundle.mva10Framework)
        if entryPoint == TopUpEntryPoint.autoTopUp {
            buttonTitle = isEditingMode ?
                "auto_top_up_quick_action_edit_button_text".localized(bundle: Bundle.mva10Framework) :
                "top_up_quick_action_set_auto_topup_button_text".localized(bundle: Bundle.mva10Framework)
        } else {
            buttonTitle = "dashboard_upgrade_component_button_topup".localized(bundle: Bundle.mva10Framework)
        }
        setupSubtitle()
        setupAmountTextFieldLocalization()
    }
    func reloadTopUp(completion: (() -> Void)? = nil) {
        setLocalizedUIElementContent()
        setupAmountThreshold()
        guard let topUpModel = topUpDelegate,
        let topUpActionView = topUpActionView else {
            return
        }
        topUpActionView.configure(with: topUpModel, viewModel: self, completion: completion)
    }

    func topUpValue() -> Double? {
        topUpActionView?.selectedAmount
    }
}

extension VFGInitialTopUpViewModel: VFQuickActionsModel {
    func closeQuickAction() {
        delegate?.dismiss()
    }

    func headerButtonAction() {
        delegate?.topUpSomeoneElse()
    }

    var isHeaderButtonHidden: Bool {
        (otherContactNumber != nil ||
        childAccount?.name != nil ||
        entryPoint == .basicTopUpTile ||
        quickActionHeaderButtonTitleText != nil ||
        quickActionHeaderButtonCustomText != nil) ? false : true
    }

    var headerButtonTitle: String {
        if let quickActionHeaderButtonCustomText = quickActionHeaderButtonCustomText {
            return quickActionHeaderButtonCustomText
        } else if let otherContactNumber = otherContactNumber {
            return otherContactNumber
        } else if let childAccountName = childAccount?.name {
            return childAccountName
        } else if entryPoint == .basicTopUpTile {
            return "top_up_someone_else_quick_action_subtitle".localized(bundle: Bundle.mva10Framework)
        }
        return quickActionHeaderButtonTitleText ?? ""
    }

    func quickActionsProtocol(delegate: VFQuickActionsProtocol) {}

    var quickActionsTitle: String {
        switch entryPoint {
        case .autoTopUp:
            return isEditingMode ?
                "auto_top_up_quick_action_edit_title".localized(bundle: Bundle.mva10Framework) :
                "auto_top_up_quick_action_title".localized(bundle: Bundle.mva10Framework)
        default:
            if childAccount != nil || otherContactNumber != nil || entryPoint == .basicTopUpTile {
                return "dashboard_top_up_item_title".localized(bundle: Bundle.mva10Framework)
            }
            return "top_up_quick_action_main_title".localized(bundle: Bundle.mva10Framework)
        }
    }

    var quickActionAttributedTitle: NSAttributedString? {
        return quickActionAttributedTitleText
    }

    var quickActionsContentView: UIView {
        guard
            let topUpModel = topUpDelegate,
            let topUpActionView = topUpActionView else {
            return UIView()
        }

        if topUpActionView.delegate == nil {
            self.topUpDelegate = topUpModel
            topUpActionView.configure(with: topUpModel, viewModel: self)
            topUpActionView.delegate = self
        } else {
            topUpActionView.animateViewAppearance()
        }

        return topUpActionView
    }

    var quickActionsStyle: VFQuickActionsStyle {
        .white
    }
}

extension VFGInitialTopUpViewModel: VFGInitialTopUpProtocol {
    func confirmTopUp(selectedAmount: Double, paymentCard: PaymentModelProtocol?) {
        switch entryPoint {
        case .autoTopUp:
            autoTopUpDelegate?.topUpFinished(amount: selectedAmount, paymentCard: paymentCard)
        default:
            if selectedAmount < topUpDelegate?.model?.minOfferAmount ?? 0 {
                delegate?.initialTopupFinished(withGift: false, selectedRow: selectedAmount, paymentCard: paymentCard)
            } else {
                delegate?.initialTopupFinished(withGift: true, selectedRow: selectedAmount, paymentCard: paymentCard)
            }
        }
    }
    func didChangedPickerValue(selectedAmount: Double, topupButton: VFGButton) {
        self.topUpDelegate?.didChangedPickerValue(
            selectedAmount: selectedAmount,
            topupButton: topupButton)
    }
    func tryAgain() {
        delegate?.reloadTopUp()
    }

    func topupPresented() {
        delegate?.topUpPresented()
    }
}
