//
//  VFGPayBillStateManager.swift
//  VFGMVA10Framework
//
//  Created by Atta Ahmed on 11/17/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

/// Pay Bill State Manager
public class VFGPayBillStateManager {
    /// Quick action Object
    var state: VFQuickActionsModel?
    /// Quick action delegate object
    weak var quickActionDelegate: VFQuickActionsProtocol?
    /// An instance of the delegate  that responsible for bill payment view to present or hide
    public weak var payBillStateMangerDelegate: VFGPayBillStateManagerProtocol?
    /// An instance of the delegate that responsible for the payment process
    public weak var initialPayBillDelegate: VFGPayBillProtocol?
    var autoBillActiveSuccess = false
    private var selectedCard: PaymentModelProtocol?
    // todo: add weak keyword when this PR is merged
    // https://github.vodafone.com/VFGroup-MyVodafone-OnePlatform/iOS-MVA10-Foundation/pull/1312
    var previousState: VFQuickActionsModel?
    func setState(state: VFQuickActionsModel) {
        previousState = state
        self.state = state
    }

    private init() {}

    /// manager initializer with *VFGPayBillProtocol*
    public init(
        initialPayBillProtocol: VFGPayBillProtocol
    ) {
        initialPayBillDelegate = initialPayBillProtocol
        initialPayBillDelegate?.setup { [weak self] _ in
            guard let self = self else { return }
            self.startPayBill()
        }
    }

    // MARK: - initial pay Bill
    var initialPayBillViewModel: VFGPayBillViewModel?
    func startPayBill() {
        initialPayBillViewModel = VFGPayBillViewModel(
            payBillDelegate: initialPayBillDelegate,
            delegate: self)
        setState(state: initialPayBillViewModel ?? VFGPayBillStateManager())
        initialPayBillViewModel?.presentPayBill()
    }

    // MARK: - loading topUp
    var loadingViewModel: PayBillLoadingViewModel?
    func loadingPayBill() {
        loadingViewModel = PayBillLoadingViewModel(
            delegate: self,
            month: initialPayBillDelegate?.model?.billMonth ?? "")
        setState(state: loadingViewModel ?? VFGPayBillStateManager())
    }

    // MARK: - Add new card
    var addNewCardViewModel: AddPaymentCardViewModel?
    func addNewCard() {
        addNewCardViewModel = AddPaymentCardViewModel(
            topUpDelegate: nil,
            delegate: self,
            didPurchaseGift: false)
        setState(state: addNewCardViewModel ?? VFGPayBillStateManager())
    }

    // MARK: - Payment
    func addNewPayment() {
        addNewCard()
        quickActionDelegate?.reloadQuickAction(model: addNewCardViewModel)
    }

    // MARK: - success Pay Bill
    var successPayBillViewModel: VFGSuccessPayBillViewModel?
    func successPayBill() {
        successPayBillViewModel = VFGSuccessPayBillViewModel(
            delegate: self,
            month: initialPayBillDelegate?.model?.billMonth ?? "")
        setState(state: successPayBillViewModel ?? VFGPayBillStateManager())
    }

    // MARK: - Fail Pay Bill
    var failurePayBillViewModel: VFGPayBillFailureViewModel?
    func failPayBill() {
        failurePayBillViewModel = VFGPayBillFailureViewModel(
            delegate: self,
            billMonth: initialPayBillDelegate?.model?.billMonth ?? "")
        setState(state: failurePayBillViewModel ?? VFGPayBillStateManager())
    }

    func payBill() {
        guard let card = self.selectedCard,
        let amount = Double(self.initialPayBillViewModel?.amount ?? "0") else {
            return
        }
        VFGPaymentManager.pay(
            amount: amount,
            with: card) { error in
            self.loadingPayBillFinished(success: error == nil)
        }
    }
}

// MARK: - VFQuickActionsModel
extension VFGPayBillStateManager: VFQuickActionsModel {
    /// Quick action close action
    public func closeQuickAction() {
        quickActionDelegate?.closeQuickAction(completion: nil)
    }

    /// Quick action actions protocol
    public func quickActionsProtocol(delegate: VFQuickActionsProtocol) {
        quickActionDelegate = delegate
    }

    /// Quick action Actions title
    public var quickActionsTitle: String {
        return state?.quickActionsTitle ?? ""
    }
    /// Quick action Content view
    public var quickActionsContentView: UIView {
        return state?.quickActionsContentView ?? UIView()
    }
    /// Quick action Presenting Style
    public var quickActionsStyle: VFQuickActionsStyle {
        return .white
    }
}

// MARK: - VFGTopUpStateProtocol
extension VFGPayBillStateManager: VFGPayBillStateInternalProtocol {
    func initialPayBillPresent() {
        previousState = self
        payBillStateMangerDelegate?.presentPayBill(model: self)
    }

    func initialPayBillFinished(with paymentCard: PaymentModelProtocol?) {
        loadingPayBill()
        selectedCard = paymentCard
        initialPayBillDelegate?.requestPayBill(
            billValue: Double(initialPayBillViewModel?.amount ?? "0") ?? 0
        ) { [weak self] success in
            guard let self = self, let success = success else {
                return
            }
            if success {
                self.payBill()
            } else {
                self.loadingPayBillFinished(success: false)
            }
        }
    }

    func initialPayBillFinished(selectedViewId: String?) {
        loadingPayBill()
        VFGPaymentManager.alternativePaymentProvider?.didSelectSection(
            for: selectedViewId,
            with: Double(initialPayBillViewModel?.amount ?? "0") ?? 0,
            paymentIdentifier: nil) { [weak self] error in
            self?.loadingPayBillFinished(success: error == nil)
        }
    }

    /// method to dismiss pay bill quick action
    public func dismiss() {
        payBillStateMangerDelegate?.closePayBill(with: autoBillActiveSuccess)
        quickActionDelegate?.closeQuickAction(completion: nil)
    }

    /// method used to trigger after adding new card successfully 
    public func addNewCardDidFinish(withGift: Bool, completion: (() -> Void)?) {
        loadingPayBill()
        initialPayBillDelegate?.requestCardVerification(
            withOffer: withGift) { [weak self] success, _ in
            guard let self = self, let success = success else {
                return
            }
            self.loadingPayBillFinished(success: success)
            completion?()
        }
    }

    func successPayBillPresent() {
        quickActionDelegate?.reloadQuickAction(model: successPayBillViewModel)
    }

    func finishPayBill() {
        dismiss()
    }

    public func backQuickAction() {
        quickActionDelegate?.reloadQuickAction(model: initialPayBillViewModel ?? VFGPayBillStateManager())
    }
    func loadingPayBillPresent() {
        quickActionDelegate?.reloadQuickAction(model: loadingViewModel)
    }

    func loadingPayBillFinished(success: Bool) {
        autoBillActiveSuccess = success
        if success {
            successPayBill()
        } else {
            failPayBill()
        }
    }
    func presentFailureView() {
        quickActionDelegate?.reloadQuickAction(model: failurePayBillViewModel)
    }
    func tryAgain() {
        initialPayBillFinished(with: selectedCard)
    }
}
