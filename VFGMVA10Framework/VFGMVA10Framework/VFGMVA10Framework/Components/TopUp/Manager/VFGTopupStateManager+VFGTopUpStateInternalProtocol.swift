//
//  VFGTopupStateManager+VFGTopUpStateInternalProtocol.swift
//  VFGMVA10Framework
//
//  Created by Atta Ahmed on 3/16/21.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

extension VFGTopUpStateManager: VFGTopUpStateInternalProtocol {
    // MARK: - QuickAction
    public func addNewCardDidFinish(withGift: Bool, completion: (() -> Void)?) {
        loadingTopUp(didPurchaseGift: withGift)
        initialTopDelegate?.requestCardVerification(
            withOffer: withGift) { [weak self] _, balance in
            guard
                let self = self,
                let balance = balance else { return }

            if self.topUpEntryPoint == .discoveryCard {
                self.addDataPage(selectedAmount: Double(balance))
            } else {
                self.requestTopUp(value: Double(balance), didPurchaseGift: false)
            }
            completion?()
        }
    }

    public func dismiss() {
        quickActionDelegate?.closeQuickAction { [weak self] in
            if self?.isSuccessTopUp ?? false {
                self?.topUpStateManagerDelegate?.topupDidCloseWithSuccess()
            }
        }
    }

    public func backQuickAction() {
        quickActionDelegate?.reloadQuickAction(model:
            initialTopUpViewModel ?? VFGTopUpStateManager())
    }

    public func backAndReloadAction() {
        quickActionDelegate?.reloadQuickAction(model:
            initialTopUpViewModel ?? VFGTopUpStateManager())
        reloadTopUp()
    }

    // MARK: - TopUp Offer screen
    func topUpOfferDidPresent() {
        quickActionDelegate?.reloadQuickAction(model: topupOfferViewModel)
    }

    func topUpOfferDidFinish(topUpValue: Double?, withOffer: Bool) {
        totalTopUpBalance += (topUpValue ?? 0)
        if topUpEntryPoint == .discoveryCard {
            addDataPage(selectedAmount: totalTopUpBalance)
        } else {
            requestTopUp(value: totalTopUpBalance, didPurchaseGift: false)
        }
    }

    func noOfferDidFinish(topUpValue: Double?, withOffer: Bool) {
        openSuccessPageWithData = false
        requestTopUp(value: totalTopUpBalance, didPurchaseGift: false)
    }

    // MARK: - add data
    func addDataViewDidPresent() {
        quickActionDelegate?.reloadQuickAction(model: self.addDataViewModel)
        shouldScrollContent(height: 0)
    }

    func acceptDataButtonDidPress(topUpValue: Double?, withOffer: Bool) {
        totalTopUpBalance += (topUpValue ?? 0)
        requestTopUp(value: totalTopUpBalance, didPurchaseGift: true)
    }

    func declineDataButtonDidPress(topUpValue: Double?, withOffer: Bool) {
        requestTopUp(value: totalTopUpBalance, didPurchaseGift: false)
    }

    func backButtonDidPress() {
        backQuickAction()
    }

    // MARK: - initial topUp
    func reloadTopUp() {
        reloadInitialTopUp()
    }

    func initialTopupPresent() {
        topUpStateManagerDelegate?.presentTopup(model: self)
    }

    func initialTopupFinished(withGift: Bool, selectedRow: Double, paymentCard: PaymentModelProtocol?) {
        self.totalTopUpBalance = selectedRow
        self.withGift = withGift
        selectedPaymentCard = paymentCard

        if initialTopUpWithOffer && !withGift {
            topUpOfferPage(selectedAmount: selectedRow)
        } else if initialTopUpWithOffer {
            addDataPage(selectedAmount: selectedRow)
        } else {
            requestTopUp(value: selectedRow, didPurchaseGift: false)
        }
    }

    // MARK: - loading topUp
    func loadingTopUpPresent() {
        quickActionDelegate?.reloadQuickAction(model: loadingViewModel)
    }

    func loadingTopupFinished(success: Bool, balance: Int) {
        isSuccessTopUp = success
        if success {
            successTopUp(
                addDataSuccess: openSuccessPageWithData,
                balance: balance,
                entryPoint: topUpEntryPoint
            )
        } else {
            failureTopUp()
        }
    }

    // MARK: - TopUp someone else
    func navigateToInitialTopUp(childAccount: VFGAccount, topUpStatus: TopUpStatus) {
        initialTopUpViewModel?.otherContactNumber = nil
        initialTopUpViewModel?.childAccount = childAccount
        someOneElseIdentifier = childAccount.name
        self.topUpStatus = topUpStatus
        quickActionDelegate?.reloadQuickAction(model:
        initialTopUpViewModel ?? VFGTopUpStateManager())
    }

    func navigateToInitialTopUp(contactNumber: String) {
        initialTopUpViewModel?.childAccount = nil
        initialTopUpViewModel?.otherContactNumber = contactNumber
        someOneElseIdentifier = contactNumber
        topUpStatus = .topUpSomeOneElse
        quickActionDelegate?.reloadQuickAction(model:
        initialTopUpViewModel ?? VFGTopUpStateManager())
    }

    func shouldScrollContent(height: CGFloat) {
        quickActionDelegate?.shouldScroll(height: height)
    }

    func permissionDidReceive() {
        topUpSomeoneElseViewModel?.isOpenContactsGranted = true
        DispatchQueue.main.async {
            self.quickActionDelegate?.reloadQuickAction(model: self.topUpSomeoneElseViewModel)
        }
    }

    func tryAgain() {
        initialTopupFinished(withGift: withGift, selectedRow: totalTopUpBalance, paymentCard: selectedPaymentCard)
    }

    func contactButtonDidPress() {
        topUpUserInteractionManagerDelegate?.contactButtonDidPress()
    }

    func topUpPresented() {
        topUpUserInteractionManagerDelegate?.topUpPresented()
    }
}

extension VFGTopUpStateManager {
    private func requestTopUp(value: Double, didPurchaseGift: Bool) {
        loadingTopUp(didPurchaseGift: didPurchaseGift)
        initialTopDelegate?.requestTopUp(
            topUpValue: value,
            withOffer: initialTopUpWithOffer) { [weak self] success, balance in
            guard
                let self = self,
                let success = success,
                let balance = balance else { return }

            if success && self.selectedPaymentCard != nil {
                self.pay(with: balance)
            } else {
                self.loadingTopupFinished(
                    success: success,
                    balance: balance)
            }
        }
    }
}
