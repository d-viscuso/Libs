//
//  VFGTopUpStateInternalProtocol.swift
//  VFGMVA10Framework
//
//  Created by Esraa Eldaltony on 1/6/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation
import VFGMVA10Foundation
/// Internal protocol for payment quick actions
public protocol VFGQuickActionStateInternalProtocol: AnyObject {
    // MARK: - dismiss
    /// Close auto bill quick action
    func dismiss()

    // MARK: - Add new card screen
    /// A method to be called after adding new card
    /// - Parameters:
    ///    - withGift: Determine whether payment has gift or not
    ///    - completion: A closure to perform actions after adding new card
    func addNewCardDidFinish(withGift: Bool, completion: (() -> Void)?)
    /// Auto bill quick action back button action
    func backQuickAction()
    /// Quick action back button and reload action
    func backAndReloadAction()
}

extension VFGQuickActionStateInternalProtocol {
    public func backAndReloadAction() {}
}
/// Top up quick action internal protocol
protocol VFGTopUpStateInternalProtocol: VFGQuickActionStateInternalProtocol {
    // MARK: - initial topUp
    /// Initial top up quick action presentation
    func initialTopupPresent()
    /// Initial top up quick action method to be called after presentation
    /// - Parameters:
    ///    - withGift: Determine whether initial top up has gift or not
    ///    - selectedRow: Default value selected for initial top up
    ///    - paymentCard: Default payment card selected for initial top up
    func initialTopupFinished(withGift: Bool, selectedRow: Double, paymentCard: PaymentModelProtocol?)
    /// Reload initial top up quick action view
    func reloadTopUp()
    /// Try again button action
    func tryAgain()

    // MARK: - loading
    /// Present top up loading screen
    func loadingTopUpPresent()
    /// Handle top up status after loading is finished
    /// - Parameters:
    ///    - success: Determine whether top up succeeded or not
    ///    - balance: Current balance value after top up
    func loadingTopupFinished(success: Bool, balance: Int)

    // MARK: - Add Data screen
    /// Present add data quick action
    func addDataViewDidPresent()
    /// Accept data button action
    /// - Parameters:
    ///    - topUpValue: Selected amount to top up with
    ///    - withOffer: Determine if the selected amount comes with an offer gift or not
    func acceptDataButtonDidPress(topUpValue: Double?, withOffer: Bool)
    /// Decline data button action
    /// - Parameters:
    ///    - topUpValue: Selected amount to top up with
    ///    - withOffer: Determine if the selected amount comes with an offer gift or not
    func declineDataButtonDidPress(topUpValue: Double?, withOffer: Bool)
    /// Top up quick action back button action
    func backButtonDidPress()

    // MARK: - TopUp Offer screen
    /// Present top up offer quick action
    func topUpOfferDidPresent()
    /// Top up offer quick action method to be called after presentation
    /// - Parameters:
    ///    - topUpValue: Selected amount to top up with
    ///    - withOffer: Determine if the selected amount comes with an offer gift or not
    func topUpOfferDidFinish(topUpValue: Double?, withOffer: Bool)
    /// Top up with no offer quick action method to be called after presentation
    /// - Parameters:
    ///    - topUpValue: Selected amount to top up with
    ///    - withOffer: Determine if the selected amount comes with an offer gift or not
    func noOfferDidFinish(topUpValue: Double?, withOffer: Bool)

    // MARK: - TopUpSomeoneElse
    /// Present top up someone else quick action
    func topUpSomeoneElse()
    /// present initial top up quick action
    /// - Parameters:
    ///    - childAccount: List of child accounts under parent account
    ///    - topUpStatus: Determine whether top up is for current account or someone else
    func navigateToInitialTopUp(childAccount: VFGAccount, topUpStatus: TopUpStatus)
    /// present initial top up quick action
    /// - Parameters:
    ///    - contactNumber: Current account contact number
    func navigateToInitialTopUp(contactNumber: String)
    /// Determine whether to enable quick action scrolling or not
    /// - Parameters:
    ///    - height: Quick action height to enable or disable scrolling
    func shouldScrollContent(height: CGFloat)
    /// topUp contact button press notify
    func contactButtonDidPress()
    /// topUp notify presented main page
    func topUpPresented()
}
