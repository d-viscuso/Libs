//
//  VFGAutoTopUpManager.swift
//  VFGMVA10Framework
//
//  Created by Moataz Akram on 08/09/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import VFGMVA10Foundation
/// All top ups manager
public class VFGAutoTopUpStateManager {
    /// State of the quick action
    public var state: VFQuickActionsModel?
    /// An instance of *VFQuickActionsProtocol*
    weak var quickActionDelegate: VFQuickActionsProtocol?
    /// An instance of *VFGAutoTopUpStateManagerDelegate*
    weak var CVMDelegate: VFGAutoTopUpStateManagerDelegate?
    /// An instance of *VFGAutoTopUpProtocol*
    weak var autoTopUpDelegate: VFGAutoTopUpProtocol?
    /// Top up model
    var topupModel: VFGTopUpProtocol?
    /// Auto top up model
    var autoTopUpModel: AutoTopUpModelProtocol?
    /// Auto top up type
    var autoTopUpType: String?
    /// Occurrence type
    var exactOccurrence: String?
    /// Selected payment card to pay with
    var paymentCard: PaymentModelProtocol?
    /// Selected amount to top up with
    public var autoTopUpAmount: Double?
    /// Auto top up view model
    public var autoTopUpViewModel: AutoTopUpViewModel?
    /// Auto top up success view model
    public var autoTopUpSuccessViewModel: VFGAutoTopUpSuccessViewModel?
    /// Auto top up loading view model
    var loadingViewModel: AutoTopUpLoadingViewModel?
    /// Active auto top up model
    var activeAutoTopUpModel: VFGActiveAutoTopUpProtocol?
    /// Auto top up failure view model
    var autoTopUpFailureViewModel: VFGAutoTopUpFailureViewModel?
    /// Top up view model
    var topUpViewModel: VFGInitialTopUpViewModel?
    /// Determine if auto bill is in editing mode or not
    var isEditingMode = false
    /// *VFGAutoTopUpStateManager* initializer
    /// - Parameters:
    ///    - autoTopUpDelegate: Set the delegate for *VFGAutoTopUpStateManager*
    ///    - isEditingMode: Determine if auto bill is in editing mode or not
    ///    - activeAutoTopUpModel: Active auto top up model data
    public init(autoTopUpDelegate: VFGAutoTopUpProtocol, isEditingMode: Bool = false, activeAutoTopUpModel: VFGActiveAutoTopUpProtocol? = nil) {
        self.autoTopUpDelegate = autoTopUpDelegate
        self.isEditingMode = isEditingMode
        self.activeAutoTopUpModel = activeAutoTopUpModel
        topupModel = autoTopUpDelegate.topUpDelegate
        autoTopUpModel = autoTopUpDelegate.autoTopUpModel
    }
    /// Set the state of the quick action
    func setState(state: VFQuickActionsModel) {
        self.state = state
    }
    /// Initialize auto top up
    func autoTopUp() {
        guard let activeModel = activeAutoTopUpModel else { return }
        VFGPaymentManager.autoTopUp(activeAutoTopUpModel: activeModel) { [weak self] error in
            guard let self = self else { return }
            self.loadingAutoTopUpFinished(success: error == nil)
        }
    }

    // MARK: - Add new card View Model
    /// *VFGAutoTopUpStateManager* payment card view model instance
    var addNewCardViewModel: AddPaymentCardViewModel?
    /// Start adding new payment card
    func addNewCard() {
        addNewCardViewModel = AddPaymentCardViewModel(
            topUpDelegate: nil,
            delegate: self,
            didPurchaseGift: false)
        guard let newCardViewModel = addNewCardViewModel else { return }
        setState(state: newCardViewModel)
        quickActionDelegate?.reloadQuickAction(model: self)
    }
}


// MARK: - VFQuickActionsModel
extension VFGAutoTopUpStateManager: VFQuickActionsModel {
    public func closeQuickAction() {
        quickActionDelegate?.closeQuickAction(completion: nil)
    }

    public func quickActionsProtocol(delegate: VFQuickActionsProtocol) {
        quickActionDelegate = delegate
    }

    public var quickActionsTitle: String {
        return state?.quickActionsTitle ?? ""
    }

    public var quickActionsContentView: UIView {
        return state?.quickActionsContentView ?? UIView()
    }
    public var quickActionsStyle: VFQuickActionsStyle {
        return .white
    }
}


// MARK: - VFGAutoTopUpStateInternalProtocol

extension VFGAutoTopUpStateManager: VFGAutoTopUpStateInternalProtocol {
    public func initialAutoTopUpPresent() {
        autoTopUpViewModel = AutoTopUpViewModel(
            model: autoTopUpModel,
            stateManager: self,
            isEditingMode: isEditingMode,
            activeAutoTopUpModel: activeAutoTopUpModel
        )
        guard let autoTopUpViewModel = autoTopUpViewModel else { return }
        setState(state: autoTopUpViewModel)
        VFQuickActionsViewController.presentQuickActionsViewController(with: self)
        guard let quickActionDelegate = quickActionDelegate else { return }
        autoTopUpViewModel.quickActionsProtocol(delegate: quickActionDelegate)
    }

    public func initialAutoTopUpFinished(autoTopUpType: String, exactOcurrence: String) {
        self.autoTopUpType = autoTopUpType
        self.exactOccurrence = exactOcurrence
        topupModel?.setup { [weak self] _ in
            guard let self = self else { return }
            self.topUpViewModel = VFGInitialTopUpViewModel(
                topUpDelegate: self.topupModel,
                autoTopUpDelegate: self,
                isEditingMode: self.isEditingMode,
                activeAutoTopUpModel: self.activeAutoTopUpModel
            )
            guard let topUpState = self.topUpViewModel else { return }
            self.setState(state: topUpState)
            self.topUpPresent()
        }
    }

    func topUpPresent() {
        quickActionDelegate?.reloadQuickAction(model: self)
    }

    public func topUpFinished(amount: Double, paymentCard: PaymentModelProtocol?) {
        autoTopUpAmount = amount
        self.paymentCard = paymentCard
        loadingViewModel = AutoTopUpLoadingViewModel(isEditingMode: isEditingMode)
        loadingAutoTopUpPresent()
    }

    func loadingAutoTopUpPresent() {
        autoTopUpFailureViewModel = nil
        guard let loadingState = loadingViewModel else { return }
        setState(state: loadingState)
        quickActionDelegate?.reloadQuickAction(model: self)
        guard let autoTopUpType = autoTopUpType,
            let exactOccurrence = exactOccurrence,
            let autoTopUpAmount = autoTopUpAmount,
            let paymentCard = paymentCard else { return }
        activeAutoTopUpModel = VFGActiveAutoTopUpModel(
            autoTopUpType: autoTopUpType,
            exactOccurrence: exactOccurrence,
            autoTopUpAmount: autoTopUpAmount,
            paymentCard: paymentCard
        )
        guard let activeModel = activeAutoTopUpModel else { return }
        autoTopUpDelegate?.requestAutoTopUp(activeAutoTopUpModel: activeModel) { [weak self] success in
            guard let self = self,
                let success = success else { return }
            if success {
                self.autoTopUp()
            } else {
                self.presentFailureView()
            }
        }
    }

    func loadingAutoTopUpFinished(success: Bool) {
        if success {
            successAutoTopUpPresent()
        } else {
            presentFailureView()
        }
    }

    public func successAutoTopUpPresent() {
        guard let autoTopUpType = autoTopUpType,
            let exactOccurrence = exactOccurrence,
            let autoTopUpAmount = autoTopUpAmount else { return }

        autoTopUpSuccessViewModel = VFGAutoTopUpSuccessViewModel(
            autoTopUpType: autoTopUpType,
            exactOccurrence: exactOccurrence,
            autoTopUpAmount: autoTopUpAmount,
            isEditingMode: isEditingMode
        )
        guard let autoTopUpSuccessViewModel = autoTopUpSuccessViewModel else { return }
        let successViewModel = VFGQuickActionsResultModel(
            type: .success,
            delegate: self,
            titleText: autoTopUpSuccessViewModel.sectionTitle,
            descriptionText: autoTopUpSuccessViewModel.subTitle,
            primaryButtonTitle: autoTopUpSuccessViewModel.buttonTitle,
            titleFont: .vodafoneBold(29),
            descriptionFont: .vodafoneRegular(19)
        )

        let quickActionsResultView = VFGQuickActionsResultView(
            title: autoTopUpSuccessViewModel.mainTitle,
            isCloseButtonHidden: true,
            model: successViewModel,
            accessibilityModel: VFGResultViewAccessibilityModel(
                imageViewID: "TPmainIcon",
                titleID: "TPprimaryTitle",
                descriptionID: "TPsecondaryTitle",
                primaryButtonID: "TP\(autoTopUpSuccessViewModel.buttonTitle.lowercased())Button")
        )
        setState(state: quickActionsResultView)
        quickActionDelegate?.reloadQuickAction(model: self)
    }

    public func finishAutoTopUp() {
        state = nil
        guard let activeModel = activeAutoTopUpModel else { return }
        CVMDelegate?.journeyDidFinish(activeAutoTopUpModel: activeModel)
    }

    func presentFailureView() {
        autoTopUpFailureViewModel = VFGAutoTopUpFailureViewModel(isEditingMode: isEditingMode)
        guard let failureViewModel = autoTopUpFailureViewModel else { return }
        let quickActionViewModel = VFGQuickActionsResultModel(
            type: .failure,
            delegate: self,
            titleText: failureViewModel.sectionTitle,
            descriptionText: failureViewModel.subTitle,
            primaryButtonTitle: failureViewModel.primaryButtonTitle,
            secondaryButtonTitle: failureViewModel.secondaryButtonTitle,
            titleFont: .vodafoneBold(29),
            descriptionFont: .vodafoneRegular(19)
        )
        let quickActionsResultView = VFGQuickActionsResultView(
            title: failureViewModel.mainTitle,
            model: quickActionViewModel)

        setState(state: quickActionsResultView)
        quickActionDelegate?.reloadQuickAction(model: quickActionsResultView)
    }

    func tryAgain() {
        loadingAutoTopUpPresent()
    }
}

// MARK: - VFGResultViewProtocol

extension VFGAutoTopUpStateManager: VFGResultViewProtocol {
    public func resultViewPrimaryButtonAction() {
        if autoTopUpFailureViewModel != nil {
            tryAgain()
        } else {
            finishAutoTopUp()
            quickActionDelegate?.closeQuickAction(completion: nil)
        }
    }

    public func resultViewSecondaryButtonAction() {
        if autoTopUpFailureViewModel != nil {
            autoTopUpFailureViewModel = nil
            guard let topUpState = topUpViewModel else { return }
            setState(state: topUpState)
            quickActionDelegate?.reloadQuickAction(model: self)
        } else {
            quickActionDelegate?.closeQuickAction(completion: nil)
        }
    }
}

// MARK: - VFGQuickActionStateInternalProtocol

extension VFGAutoTopUpStateManager: VFGQuickActionStateInternalProtocol {
    public func dismiss() {
        quickActionDelegate?.closeQuickAction(completion: nil)
    }

    public func addNewCardDidFinish(withGift: Bool, completion: (() -> Void)?) {
        loadingViewModel = AutoTopUpLoadingViewModel(isEditingMode: isEditingMode)
        guard let loadingState = loadingViewModel else { return }
        setState(state: loadingState)
        quickActionDelegate?.reloadQuickAction(model: self)
        guard let topupModel = topupModel else { return }
        topupModel.requestCardVerification(withOffer: false) { [weak self] _, _ in
            guard let self = self,
                let type = self.autoTopUpType,
                let occurrence = self.exactOccurrence else { return }
            self.initialAutoTopUpFinished(autoTopUpType: type, exactOcurrence: occurrence)
        }
    }
}
