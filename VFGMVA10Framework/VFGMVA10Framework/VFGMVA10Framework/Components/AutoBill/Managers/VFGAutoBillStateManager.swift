//
//  VFGAutoBillStateManager.swift
//  VFGMVA10Framework
//
//  Created by Hussein Kishk on 31/01/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import VFGMVA10Foundation
/// Auto bill manager
public class VFGAutoBillStateManager {
    /// An instance of *VFQuickActionsModel*
    var state: VFQuickActionsModel?
    /// An instance of *VFQuickActionsProtocol*
    weak var quickActionDelegate: VFQuickActionsProtocol?
    /// An instance of *VFGAutoBillStateManagerProtocol*
    public weak var autoBillStateMangerDelegate: VFGAutoBillStateManagerProtocol?
    /// An instance of *VFGAutoBillProtocol*
    public weak var initialAutoBillDelegate: VFGAutoBillProtocol?
    /// A boolean to determine whether auto bill process succeeded or not
    var autoBillSuccess = false
    /// A boolean to determine whether auto bill is in editing mode or not
    var isEditingMode = false
    /// Set current state for auto bill
    /// - Parameters:
    ///    - state: Instance of *VFQuickActionsModel* to determine its state
    func setState(state: VFQuickActionsModel) {
        self.state = state
    }

    private init() {}
    /// *VFGAutoBillStateManager* initializer
    /// - Parameters:
    ///    - initialAutoBillProtocol: Set the delegate for *initialAutoBillProtocol*
    ///    - isEditingMode: Determine whether auto bill is in editing mode or not
    public init(initialAutoBillProtocol: VFGAutoBillProtocol, isEditingMode: Bool) {
        initialAutoBillDelegate = initialAutoBillProtocol
        self.isEditingMode = isEditingMode
        initialAutoBillDelegate?.setup { [weak self] _ in
            guard let self = self else { return }
            self.startAutoBill()
        }
    }

    // MARK: - initial Auto Bill View Model
    /// *VFGAutoBillStateManager* auto bill view model instance
    var initialAutoBillViewModel: VFGAutoBillViewModel?
    /// Initialize auto bill journey
    func startAutoBill() {
        initialAutoBillViewModel = VFGAutoBillViewModel(
            model: initialAutoBillDelegate?.model,
            delegate: self,
            isEditingMode: isEditingMode
        )
        setState(state: initialAutoBillViewModel ?? VFGAutoBillStateManager())
        initialAutoBillViewModel?.presentAutoBill()
    }

    // MARK: - loading Auto Bill View Model
    /// *VFGAutoBillStateManager* loading view model instance
    var loadingViewModel: VFGAutoBillLoadingViewModel?
    /// Start loading auto bill
    func loadingAutoBill() {
        loadingViewModel = VFGAutoBillLoadingViewModel(
            delegate: self,
            isEditingMode: isEditingMode
        )
        setState(state: loadingViewModel ?? VFGAutoBillStateManager())
    }

    // MARK: - Add new card View Model
    /// *VFGAutoBillStateManager* payment card view model instance
    var addNewCardViewModel: AddPaymentCardViewModel?
    /// Start adding new payment card
    func addNewCard() {
        addNewCardViewModel = AddPaymentCardViewModel(
            topUpDelegate: nil,
            delegate: self,
            didPurchaseGift: false)
        setState(state: addNewCardViewModel ?? VFGAutoBillStateManager())
    }

    // MARK: - Payment
    /// Start adding new payment method
    func addNewPayment() {
        addNewCard()
        quickActionDelegate?.reloadQuickAction(model: addNewCardViewModel)
    }

    // MARK: - Success Auto Bill View Model
    /// *VFGAutoBillStateManager* auto bill success view model instance
    var successAutoBillViewModel: VFGSuccessAutoBillViewModel?
    /// handle auto bill in case of success
    func successAutoBill() {
        guard
            let selectedDay = initialAutoBillDelegate?.model?.selectedDay,
            let billDate = initialAutoBillDelegate?.model?.billDate else { return }
        let todaysDay = Calendar.current.component(.day, from: Date())
        var month: String?
        if todaysDay >= selectedDay {
            month = VFGDateHelper.getNextMonthFromISO8601Date(dateString: billDate)
        } else {
            month = VFGDateHelper.getMonthFromISO8601Date(dateString: billDate)
        }
        successAutoBillViewModel = VFGSuccessAutoBillViewModel(
            delegate: self,
            month: month ?? "",
            selectedDay: selectedDay,
            isEditingMode: isEditingMode)
        setState(state: successAutoBillViewModel ?? VFGAutoBillStateManager())
    }

    // MARK: - Fail Auto Bill View Model
    /// *VFGAutoBillStateManager* auto bill failure view model instance
    var failureAutoBillViewModel: VFGAutoBillFailureViewModel?
    /// handle auto bill in case of failure
    func failAutoBill() {
        failureAutoBillViewModel = VFGAutoBillFailureViewModel(delegate: self)
        setState(state: failureAutoBillViewModel ?? VFGAutoBillStateManager())
    }
    /// Auto bill initialization setup
    func autoBill() {
        guard
            let card = initialAutoBillDelegate?.model?.defaultPaymentMethod,
            let selectedDay = initialAutoBillDelegate?.model?.selectedDay else {
            return
        }
        VFGPaymentManager.autoBill(
            day: selectedDay,
            with: card) { error in
            self.loadingAutoBillFinished(success: error == nil)
        }
    }
}

// MARK: - VFQuickActionsModel
extension VFGAutoBillStateManager: VFQuickActionsModel {
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

// MARK: - VFGAutoBillStateInternalProtocol
extension VFGAutoBillStateManager: VFGAutoBillStateInternalProtocol {
    func initialAutoBillPresent() {
        autoBillStateMangerDelegate?.presentAutoBill(model: self)
    }

    func initialAutoBillFinished(with paymentCard: PaymentModelProtocol?, selectedDay: Int?) {
        loadingAutoBill()
        initialAutoBillDelegate?.model?.defaultPaymentMethod = paymentCard
        initialAutoBillDelegate?.model?.selectedDay = selectedDay
        initialAutoBillDelegate?.requestAutoBill(
            selectedDay: selectedDay ?? 0
        ) { [weak self] success in
            guard let self = self, let success = success else {
                return
            }
            if success {
                self.autoBill()
            } else {
                self.loadingAutoBillFinished(success: false)
            }
        }
    }

    public func dismiss() {
        guard let selectedDay = initialAutoBillDelegate?.model?.selectedDay else {
            quickActionDelegate?.closeQuickAction(completion: nil)
            return
        }
        let todaysDay = Calendar.current.component(.day, from: Date())
        let daysNumberRange = Calendar.current.range(of: .day, in: .month, for: Date())
        let daysInMonth = daysNumberRange?.count
        var nextPayment: Int?
        if selectedDay > todaysDay {
            nextPayment = selectedDay - todaysDay
        } else if let daysInMonth = daysInMonth {
            nextPayment = daysInMonth - todaysDay + selectedDay
        }
        autoBillStateMangerDelegate?.closeAutoBill(
            with: autoBillSuccess,
            selectedDay: initialAutoBillDelegate?.model?.selectedDay,
            remainingDays: nextPayment,
            selectedCardNumber: initialAutoBillDelegate?.model?.defaultPaymentMethod?.cardNumber
        )
        quickActionDelegate?.closeQuickAction(completion: nil)
    }

    public func backQuickAction() {
        quickActionDelegate?.reloadQuickAction(model: initialAutoBillViewModel ?? VFGAutoBillStateManager())
    }

    public func addNewCardDidFinish(withGift: Bool, completion: (() -> Void)?) {
        loadingAutoBill()
        initialAutoBillDelegate?.requestCardVerification(
            withOffer: withGift) { [weak self] success, _ in
            guard let self = self, let success = success else {
                return
            }
            self.loadingAutoBillFinished(success: success)
            completion?()
        }
    }

    func successAutoBillPresent() {
        quickActionDelegate?.reloadQuickAction(model: successAutoBillViewModel)
    }

    func finishAutoBill() {
        dismiss()
    }

    func loadingAutoBillPresent() {
        quickActionDelegate?.reloadQuickAction(model: loadingViewModel)
    }

    func loadingAutoBillFinished(success: Bool) {
        autoBillSuccess = success
        if success {
            successAutoBill()
        } else {
            failAutoBill()
        }
    }

    func presentFailureView() {
        quickActionDelegate?.reloadQuickAction(model: failureAutoBillViewModel)
    }

    func tryAgain() {
        initialAutoBillViewModel?.model = initialAutoBillDelegate?.model
        quickActionDelegate?.reloadQuickAction(model: initialAutoBillViewModel)
    }
}
