//
//  VFGAddPlanStateManager.swift
//  VFGMVA10Framework
//
//  Created by Hussein Kishk on 7/5/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

/// Add plan state manager.
public class VFGAddPlanStateManager {
    var state: VFQuickActionsModel?
    weak var quickActionDelegate: VFQuickActionsProtocol?
    /// Add plan state manager delegate.
    public weak var addPlaneStateMangerDelegate: VFGAddPlanStateManagerProtocol?
    /// Add plan data provider.
    public var dataProvider: VFGAddPlanProtocol?
    var selectedPlanIndexPath: IndexPath?
    var isRecurring: Bool?
    var titles: VFGFailureAddPlanModel?
    var quickActionViewTitle: String?
    var successAddPlanStrings: VFGSuccessAddPlanModel?

    func setState(state: VFQuickActionsModel? = nil) {
        self.state = state
    }

    /// Setup add plan type and start add plan journey.
    /// - Parameters:
    ///    - planType: Plan type whether *data, sms or calls*.
    public func setup(_ planType: AddPlanType) {
        dataProvider?.setup(planType) { [weak self] _ in
            guard let self = self else { return }
            self.addPlan()
        }
    }

    public init(with provider: VFGAddPlanProtocol?, titles: VFGFailureAddPlanModel?, quickActionViewTitle: String?, successAddPlanStrings: VFGSuccessAddPlanModel?) {
        dataProvider = provider
        self.titles = titles
        self.quickActionViewTitle = quickActionViewTitle
        self.successAddPlanStrings = successAddPlanStrings
    }

    // MARK: - success
    var successAddPlanViewModel: VFGSuccessAddPlanViewModel?
    func successAddPlan(selectedPlanIndexPath: Int) {
        successAddPlanViewModel = VFGSuccessAddPlanViewModel(
            with: dataProvider?.model,
            delegate: self,
            selectedPlanIndex: selectedPlanIndexPath,
            quickActionViewTitle: quickActionViewTitle,
            successAddPlanStrings: successAddPlanStrings)
        setState(state: successAddPlanViewModel)
    }

    // MARK: - loading
    var loadingAddPlanViewModel: VFGLoadingAddPlanViewModel?
    func loadingAddPlan() {
        loadingAddPlanViewModel = VFGLoadingAddPlanViewModel(
            with: dataProvider?.model,
            delegate: self,
            quickActionViewTitle: quickActionViewTitle)
        setState(state: loadingAddPlanViewModel)
    }

    // MARK: - Failure
    var failureAddPlanViewModel: VFGFailureAddPlanViewModel?
    func failureAddPlan(selectedPlanIndexPath: IndexPath, isRecurring: Bool) {
        failureAddPlanViewModel = VFGFailureAddPlanViewModel(
            with: dataProvider?.model,
            delegate: self,
            titles: titles,
            quickActionViewTitle: quickActionViewTitle
        )
        self.selectedPlanIndexPath = selectedPlanIndexPath
        self.isRecurring = isRecurring
        setState(state: failureAddPlanViewModel)
    }

    // MARK: - add data
    var addPlanViewModel: VFGAddPlanViewModel?
    func addPlan() {
        addPlanViewModel = VFGAddPlanViewModel(
            with: dataProvider?.model,
            delegate: self,
            quickActionViewTitle: quickActionViewTitle)
        setState(state: addPlanViewModel)
    }

    // MARK: - Add new payment card
    var addNewCardViewModel: AddPaymentCardViewModel?
    func addNewCard() {
        addNewCardViewModel = AddPaymentCardViewModel(
            topUpDelegate: nil,
            delegate: self,
            didPurchaseGift: false)
        setState(state: addNewCardViewModel)
    }

    func addNewPayment() {
        addNewCard()
        quickActionDelegate?.reloadQuickAction(model: addNewCardViewModel)
    }
}

// MARK: - VFQuickActionsModel
extension VFGAddPlanStateManager: VFQuickActionsModel {
    public func closeQuickAction() {
        quickActionDelegate?.closeQuickAction(completion: nil)
    }

    public func quickActionsProtocol(delegate: VFQuickActionsProtocol) {
        quickActionDelegate = delegate
    }

    public var quickActionsTitle: String {
        state?.quickActionsTitle ?? ""
    }

    public var quickActionsContentView: UIView {
        state?.quickActionsContentView ?? UIView()
    }

    public var quickActionsStyle: VFQuickActionsStyle {
        state?.quickActionsStyle ?? .white
    }

    public func backQuickAction() {
        quickActionDelegate?.reloadQuickAction(model: addPlanViewModel ?? VFGAddPlanStateManager(
            with: nil,
            titles: titles,
            quickActionViewTitle: quickActionViewTitle,
            successAddPlanStrings: successAddPlanStrings)
        )
    }
}

// MARK: - VFGAddPlanStateInternalProtocol
extension VFGAddPlanStateManager: VFGAddPlanStateInternalProtocol {
    public func dismiss() {
        quickActionDelegate?.closeQuickAction(completion: nil)
    }

    public func addNewCardDidFinish(withGift: Bool, completion: (() -> Void)?) {
        let selectedIndexPath = addPlanViewModel?.selectedPlanIndexPath
        loadingAddPlan()
        dataProvider?.requestCardVerification(
            selectedRow: selectedPlanIndexPath?.row ?? 0) { [weak self] success in
                guard let self = self,
                    let success = success else {
                    return
                }
                guard let selectedIndexPath = selectedIndexPath else {
                    self.quickActionDelegate?
                        .reloadQuickAction(model: self.addPlanViewModel ?? VFGAddPlanStateManager(
                            with: nil,
                            titles: self.titles,
                            quickActionViewTitle: self.quickActionViewTitle,
                            successAddPlanStrings: self.successAddPlanStrings)
                        )
                    return
                }
                self.loadingViewFinished(
                    success: success,
                    selectedPlanIndexPath: selectedIndexPath,
                    isRecurring: self.isRecurring ?? false)
                completion?()
        }
    }

    public func failureViewFinished() {
        addPlanViewModel?.selectedPlanIndexPath = selectedPlanIndexPath
        addPlanViewModel?.isRecurring = isRecurring
        quickActionDelegate?.reloadQuickAction(model: addPlanViewModel)
    }

    public func presentFailureView() {
        quickActionDelegate?.reloadQuickAction(model: failureAddPlanViewModel)
    }

    public func presentAddPlanView() {
        addPlaneStateMangerDelegate?.presentAddPlan(model: self)
    }

    public func addPlanFinished(selectedPlanIndexPath: IndexPath, isRecurring: Bool, serviceType: String, with paymentCard: PaymentModelProtocol, amount: Double) {
        loadingAddPlan()
        dataProvider?.requestPlan(
            selectedRow: selectedPlanIndexPath.row,
            isRecurring: isRecurring) { requestState in
                guard let requestState = requestState else { return }

                VFGPaymentManager.pay(amount: amount, with: paymentCard) { [weak self] error in
                    self?.loadingViewFinished(
                        success: error != nil ? false : requestState,
                        selectedPlanIndexPath: selectedPlanIndexPath,
                        isRecurring: isRecurring)
                }
        }
    }

    public func presentLoadingView() {
        quickActionDelegate?.reloadQuickAction(model: loadingAddPlanViewModel)
    }

    public func loadingViewFinished(success: Bool, selectedPlanIndexPath: IndexPath, isRecurring: Bool) {
        if success {
            successAddPlan(selectedPlanIndexPath: selectedPlanIndexPath.row)
        } else {
            failureAddPlan(selectedPlanIndexPath: selectedPlanIndexPath, isRecurring: isRecurring)
        }
    }

    public func presentSucccessView() {
        quickActionDelegate?.reloadQuickAction(model: successAddPlanViewModel)
    }

    public func successViewFinished() {
        dismissQuickAction()
    }

    public func dismissQuickAction() {
        quickActionDelegate?.closeQuickAction(completion: nil)
    }
}
