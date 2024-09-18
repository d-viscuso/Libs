//
//  VFGTopUpStatManager.swift
//  VFGMVA10Framework
//
//  Created by Esraa Eldaltony on 1/6/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation
import VFGMVA10Foundation

/// TopUp entry point.
public enum TopUpEntryPoint: String {
    /// TopUp tile.
    case topUpTile
    /// Basic topUp tile.
    case basicTopUpTile
    /// Discovery card.
    case discoveryCard
    /// Auto topUp.
    case autoTopUp
}

/// TopUp status.
public enum TopUpStatus {
    /// TopUp myself.
    case topUpMine
    /// TopUp someone else.
    case topUpSomeOneElse
}

/// TopUp Amount Picker Axis
public enum TopupAmountPickerAxis {
    /// Vertical Picker
    case vertical
    /// Horizontal Picker
    case horizontal
}

/// TopUp state manager.
public class VFGTopUpStateManager {
    /// topUp state manager delegate.
    public weak var topUpStateManagerDelegate: VFGTopUpStateManagerProtocol?
    /// topUp user interaction manager delegate.
    public weak var topUpUserInteractionManagerDelegate: VFGTopupUserInteractionProtocol?
    /// Initial topUp delegate.
    public weak var initialTopDelegate: VFGTopUpProtocol?
    /// Boolean determines whether to show or hide quick action header button.
    public var isQuickActionHeaderButtonHidden: Bool?
    /// Quick action header button title.
    public var quickActionHeaderButtonTitle: String?
    /// quick action attributed title text.
    public var quickActionAttributedTitleText: NSAttributedString? {
        didSet {
            initialTopUpViewModel?.quickActionAttributedTitleText = quickActionAttributedTitleText
        }
    }
    /// Quick action header button title text.
    public var quickActionHeaderButtonTitleText: String? {
        didSet {
            initialTopUpViewModel?.quickActionHeaderButtonTitleText = quickActionHeaderButtonTitleText
        }
    }
    /// Quick action header button custom title text.
    public var quickActionHeaderButtonCustomText: String? {
        didSet {
            initialTopUpViewModel?.quickActionHeaderButtonCustomText = quickActionHeaderButtonCustomText
        }
    }
    /// Quick action delegate.
    public weak var quickActionDelegate: VFQuickActionsProtocol?

    var state: VFQuickActionsModel?
    var totalTopUpBalance = 0.0
    var withGift = false
    var initialTopUpWithOffer = false
    var initialTopUpWithCustomAmount = false
    var openSuccessPageWithData = false
    var openBuyNowPageWithData = false
    var isSuccessTopUp = false

    var topUpEntryPoint: TopUpEntryPoint = .discoveryCard
    var topUpAmountPickerAxis: TopupAmountPickerAxis = .vertical
    var selectedPaymentCard: PaymentModelProtocol?
    var someOneElseIdentifier = ""
    var topUpStatus: TopUpStatus = .topUpMine
    var addPaymentCardCustomView: AddPaymentCardCustomView?
    var successCustomQuickActionModel: VFQuickActionsModel?
    var quickActionCustomHeaderView: UIView?
    var topUpSomeoneElseCustomView: UIView?

    func setState(state: VFQuickActionsModel) {
        self.state = state
    }

    init() {}

    public init(
        initialTopProtocol: VFGTopUpProtocol,
        withOffer: Bool = false,
        withCustomAmount: Bool = false,
        entryPoint: TopUpEntryPoint = .discoveryCard,
        amountPickerAxis: TopupAmountPickerAxis = .vertical,
        addPaymentCardCustomView: AddPaymentCardCustomView? = nil,
        successCustomQuickActionModel: VFQuickActionsModel? = nil,
        quickActionCustomHeaderView: UIView? = nil,
        topUpSomeoneElseCustomView: UIView? = nil
    ) {
        initialTopDelegate = initialTopProtocol
        initialTopUpWithOffer = withOffer
        initialTopUpWithCustomAmount = withCustomAmount
        topUpEntryPoint = entryPoint
        topUpAmountPickerAxis = amountPickerAxis
        self.addPaymentCardCustomView = addPaymentCardCustomView
        self.successCustomQuickActionModel = successCustomQuickActionModel
        self.topUpSomeoneElseCustomView = topUpSomeoneElseCustomView
        self.quickActionCustomHeaderView = quickActionCustomHeaderView
        initialTopProtocol.setup { [weak self] _ in
            guard let self = self else { return }
            self.initialTopUp(entryPoint: entryPoint)
            self.initialTopUpViewModel?.quickActionAttributedTitleText = self.quickActionAttributedTitleText
            self.initialTopUpViewModel?.quickActionHeaderButtonTitleText = self.quickActionHeaderButtonTitleText
            self.initialTopUpViewModel?.quickActionHeaderButtonCustomText = self.quickActionHeaderButtonCustomText
        }
    }

    // MARK: - initial topUp
    var initialTopUpViewModel: VFGInitialTopUpViewModel?
    func reloadInitialTopUp() {
        initialTopDelegate?.setup { [weak self] _ in
            guard let self = self else { return }
            self.initialTopUpViewModel?.reloadTopUp()
        }
    }
    func initialTopUp(entryPoint: TopUpEntryPoint) {
        initialTopUpViewModel = VFGInitialTopUpViewModel(
            topUpDelegate: initialTopDelegate,
            delegate: self,
            withCustomAmount: initialTopUpWithCustomAmount,
            entryPoint: entryPoint,
            amountPickerAxis: topUpAmountPickerAxis)
        setState(state: initialTopUpViewModel ?? VFGTopUpStateManager())
        if entryPoint == .basicTopUpTile && VFGUser.shared.type == .payM {
            topUpSomeoneElse()
        }
    }

    // MARK: - success topUp
    var successViewModel: VFGQuickActionsResultModel?

    func successTopUp(
        addDataSuccess: Bool = false,
        withGift: Bool = false,
        balance: Int = 0,
        entryPoint: TopUpEntryPoint = .discoveryCard
    ) {
        if let successCustomQuickActionModel = successCustomQuickActionModel {
            setState(state: successCustomQuickActionModel)
            quickActionDelegate?.reloadQuickAction(model: successCustomQuickActionModel)
        } else {
            let successTopUpViewModel = VFGSuccessTopUpViewModel(
                topUpDelegate: initialTopDelegate,
                topUpStatus: topUpStatus,
                someOneElseIdentifier: someOneElseIdentifier,
                addDataSuccess: addDataSuccess,
                entryPoint: entryPoint,
                balance: balance)

            successViewModel = VFGQuickActionsResultModel(
                type: .success,
                delegate: self,
                titleText: successTopUpViewModel.sectionTitle,
                descriptionText: successTopUpViewModel.subTitle,
                primaryButtonTitle: successTopUpViewModel.buttonTitle,
                titleFont: .vodafoneBold(24),
                descriptionFont: .vodafoneRegular(16)
            )

            guard let model = successViewModel else { return }
            let isCloseButtonHidden = topUpEntryPoint == .basicTopUpTile
            let quickActionsResultView = VFGQuickActionsResultView(
                title: successTopUpViewModel.mainTitle,
                isCloseButtonHidden: isCloseButtonHidden,
                model: model,
                accessibilityModel: VFGResultViewAccessibilityModel(
                    imageViewID: "TPmainIcon",
                    titleID: "TPprimaryTitle",
                    descriptionID: "TPsecondaryTitle",
                    primaryButtonID: "TP\(successTopUpViewModel.buttonTitle.lowercased())Button"),
                accessibilityVoiceOverModel: VFGResultViewAccessibilityVoiceOverModel(
                    imageViewLabel: nil,
                    animationViewLabel: "Check mark animated view")
            )

            setState(state: quickActionsResultView)
            quickActionDelegate?.reloadQuickAction(model: quickActionsResultView)
        }
    }

    // MARK: - failure topUp
    var failureViewModel: VFGQuickActionsResultModel?

    func failureTopUp() {
        let failureTopUpViewModel = VFGFailureTopUpViewModel(
            topUpStatus: topUpStatus,
            someOneElseIdentifier: someOneElseIdentifier)

        failureViewModel = VFGQuickActionsResultModel(
            type: .failure,
            delegate: self,
            titleText: failureTopUpViewModel.sectionTitle,
            descriptionText: failureTopUpViewModel.subTitle,
            primaryButtonTitle: failureTopUpViewModel.primaryButtonTitle,
            secondaryButtonTitle: failureTopUpViewModel.secondaryButtonTitle)

        guard let model = failureViewModel else { return }
        let quickActionsResultView = VFGQuickActionsResultView(
            title: failureTopUpViewModel.mainTitle,
            model: model,
            accessibilityVoiceOverModel: VFGResultViewAccessibilityVoiceOverModel(
                imageViewLabel: "Failure warning view",
                animationViewLabel: nil))

        setState(state: quickActionsResultView)
        quickActionDelegate?.reloadQuickAction(model: quickActionsResultView)
    }

    // MARK: - loading topUp
    var loadingViewModel: VFGTopupLoadingViewModel?
    func loadingTopUp(didPurchaseGift: Bool) {
        loadingViewModel = VFGTopupLoadingViewModel(
            topUpDelegate: initialTopDelegate,
            delegate: self,
            someOneElseIdentifier: someOneElseIdentifier,
            topUpStatus: topUpStatus,
            didPurchaseGift: didPurchaseGift,
            topUpEntryPoint: topUpEntryPoint)
        setState(state: loadingViewModel ?? VFGTopUpStateManager())
    }

    // MARK: - add data
    var addDataViewModel: VFGAddDataViewModel?
    func addDataPage(selectedAmount: Double) {
        addDataViewModel = VFGAddDataViewModel(
            topUpDelegate: initialTopDelegate,
            delegate: self,
            selectedAmount: selectedAmount)
        setState(state: addDataViewModel ?? VFGTopUpStateManager())
    }

    // MARK: - topUp offer
    var topupOfferViewModel: VFGTopUpOfferViewModel?
    func topUpOfferPage(selectedAmount: Double) {
        topupOfferViewModel = VFGTopUpOfferViewModel(
            topUpDelegate: initialTopDelegate,
            delegate: self,
            selectedAmount: selectedAmount)
        setState(state: topupOfferViewModel ?? VFGTopUpStateManager())
    }

    // MARK: - Add new card
    var addNewCardViewModel: AddPaymentCardViewModel?
    func addNewCard(didPurchaseGift: Bool) {
        topUpUserInteractionManagerDelegate?.addNewCardDidPress()
        addPaymentCardCustomView?.amountValue = initialTopUpViewModel?.topUpValue()
        addNewCardViewModel = AddPaymentCardViewModel(
            topUpDelegate: initialTopDelegate,
            delegate: self,
            didPurchaseGift: didPurchaseGift,
            addPaymentCardCustomView: addPaymentCardCustomView)
        setState(state: addNewCardViewModel ?? VFGTopUpStateManager())
    }

    // MARK: - Payment
    func addNewPayment(didPurchaseGift: Bool = false) {
        addNewCard(didPurchaseGift: didPurchaseGift)
        self.quickActionDelegate?.reloadQuickAction(model: addNewCardViewModel)
    }

    // MARK: - TopUp someone else
    var topUpSomeoneElseViewModel: VFGTopUpSomeoneElseViewModel?

    public func topUpSomeoneElse() {
        topUpUserInteractionManagerDelegate?.headerButtonDidPress()
        topUpSomeoneElseViewModel = VFGTopUpSomeoneElseViewModel(
            delegate: self,
            initialTopDelegate: initialTopDelegate,
            customView: topUpSomeoneElseCustomView)
        setState(state: topUpSomeoneElseViewModel ?? VFGTopUpStateManager())
        quickActionDelegate?.reloadQuickAction(model: self.topUpSomeoneElseViewModel)
    }

    func pay(with balance: Int) {
        guard let card = self.selectedPaymentCard else {
            return
        }
        VFGPaymentManager.pay(
            amount: totalTopUpBalance,
            with: card) { [weak self] error in
            self?.loadingTopupFinished(success: error == nil, balance: balance)
        }
    }
}

// MARK: - VFQuickActionsModel
extension VFGTopUpStateManager: VFQuickActionsModel {
    public var isHeaderButtonHidden: Bool {
        if quickActionHeaderButtonCustomText != nil {
            return false
        }
        return isQuickActionHeaderButtonHidden ?? (topUpEntryPoint != .basicTopUpTile || VFGUser.shared.type == .payM)
    }

    public var headerButtonTitle: String {
        quickActionHeaderButtonCustomText ??
        quickActionHeaderButtonTitle ??
        "top_up_someone_else_quick_action_subtitle".localized(bundle: .mva10Framework)
    }

    public func headerButtonAction() {
        topUpSomeoneElse()
    }

    public func closeQuickAction() {
        quickActionDelegate?.closeQuickAction(completion: nil)
    }

    public func quickActionsProtocol(delegate: VFQuickActionsProtocol) {
        quickActionDelegate = delegate
    }

    public var quickActionsTitle: String {
        if topUpEntryPoint == .basicTopUpTile {
            return "top_up_someone_else_quick_action_title".localized(bundle: Bundle.mva10Framework)
        }
        return state?.quickActionsTitle ?? ""
    }

    public var quickActionsContentView: UIView {
        return state?.quickActionsContentView ?? UIView()
    }

    public var quickActionsStyle: VFQuickActionsStyle {
        return .white
    }

    public var customHeaderView: UIView? {
        return quickActionCustomHeaderView
    }

    public var quickActionAttributedTitle: NSAttributedString? {
        return quickActionAttributedTitleText
    }
}

extension VFGTopUpStateManager: VFGResultViewProtocol {
    public func resultViewPrimaryButtonAction() {
        if isSuccessTopUp {
            dismiss()
        } else {
            tryAgain()
        }
    }

    public func resultViewSecondaryButtonAction() {
        backQuickAction()
    }

    public func quickActionsClose(isCloseButton: Bool) {
        if isSuccessTopUp {
            topUpStateManagerDelegate?.topupDidCloseWithSuccess()
        }
    }
}
