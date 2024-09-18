//
//  VFGPaymentManager.swift
//  VFGMVA10Framework
//
//  Created by Atta Amed on 8/29/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

/// Payment manager.
public class VFGPaymentManager {
    /// Payment provider.
    public static var paymentProvider: PaymentProviderProtocol?
    /// Alternative payment provider.
    public static var alternativePaymentProvider: AlternativePaymentProviderProtocol?
    /// TopUp state manager.
    public static var topupStateManager: VFGTopUpStateManager?
    /// Pay bill state manager.
    public static var payBillStateManager: VFGPayBillStateManager?
    /// Add plan state manager.
    public static var addPlanStateManager: VFGAddPlanStateManager?
    /// Auto bill state manager.
    public static var autoBillStateManager: VFGAutoBillStateManager?
    /// Auto topUp state manager.
    public static var autoTopUpStateManager: VFGAutoTopUpStateManager?
    /// Payment indentifier.
    public static var paymentIdentifier: String?
    static var emptyCardsPreviewMode: EmptyCardsPreviewMode = .compact
    static var showDeleteButton = false

    private init() {}

    /// Method to configure custom cards style.
    /// - Parameters:
    ///    - emptyCardsPreviewMode: *EmptyCardsPreviewMode*. default is *compact*.
    ///    - showDeleteButton: Boolean determine whether to show or hide delete button, default is false.
    public class func configureCustomCardsStyle(
        emptyCardsPreviewMode: EmptyCardsPreviewMode = .compact,
        showDeleteButton: Bool = false
    ) {
        self.emptyCardsPreviewMode = emptyCardsPreviewMode
        self.showDeleteButton = showDeleteButton
    }
    // MARK: - Data provider
    /// Fetch payment cards.
    /// - Parameters:
    ///    - completion: *FetchPaymentCompletion* is a typealias for *(([PaymentModelProtocol]?, Error?) -> Void)?*.
    public class func fetchPaymentCards(completion: FetchPaymentCompletion) {
        paymentProvider?.fetchPaymentCards { cards, error in
            let sortedCards = swapPreferredPaymentCard(in: cards)
            let sortedCardsWithTemporary = setTemporaryPaymentCardsAtFirst(in: sortedCards)
            completion?(sortedCardsWithTemporary, error)
        }
    }

    /// Fetch alternative payment methods.
    /// - Parameters:
    ///    - completion: *(([AlternativePaymentMethod]?) -> Void)*.
    public class func fetchAlternativePaymentMethods(completion: ([AlternativePaymentMethod]?) -> Void) {
        alternativePaymentProvider?.paymentsMethods(completion: completion)
    }

    private class func swapPreferredPaymentCard(in cards: [PaymentModelProtocol]?) -> [PaymentModelProtocol]? {
        guard var sortedCards = cards else { return nil }
        guard let preferredCardIndex = sortedCards
            .firstIndex(where: { ($0.isPreferred ?? false) }),
            preferredCardIndex != 0  else { return cards }
        return [sortedCards.remove(at: preferredCardIndex)] + sortedCards
    }

    private class func setTemporaryPaymentCardsAtFirst(in cards: [PaymentModelProtocol]?) -> [PaymentModelProtocol]? {
        guard var sortedCards = cards else { return nil }
        guard let temporaryCardIndex = sortedCards
            .firstIndex(where: { ($0.isTempCard ?? false) }),
            temporaryCardIndex != 0  else { return cards }
        return [sortedCards.remove(at: temporaryCardIndex)] + sortedCards
    }

    /// Set a specific card as preferred payment card. Will be used in any transaction in case the user has more than one card.
    /// - Parameters:
    ///    - paymentId: Preferred card's Id.
    ///    - completion: *FetchPaymentCompletion* is a typealias for *(([PaymentModelProtocol]?, Error?) -> Void)?*.
    public class func setPreferred(at cardId: String, completion: FetchPaymentCompletion) {
        paymentProvider?.setPreferredPaymentCard(paymentId: cardId) { cards, error in
            let sortedCards = swapPreferredPaymentCard(in: cards)
            completion?(sortedCards, error)
        }
    }

    /// Add new payment card.
    /// - Parameters:
    ///    - paymentCard: New payment card details.
    ///    - completion: *ManagePaymentCompletion* is a typealias for *(AddPaymentErrorModel?) -> Void*.
    public class func add(
        paymentCard: PaymentCardDetails,
        completion: @escaping ManagePaymentCompletion
    ) {
        paymentProvider?.add(paymentCard: paymentCard) { error in
            completion(error)
        }
    }

    /// Fetch a specific payment card.
    /// - Parameters:
    ///    - cardId: Required card's Id.
    ///    - completion: *FetchCardCompletion* is a typealias for *((PaymentModelProtocol?, Error?) -> Void)?*.
    public class func fetchPaymentCard(
        by cardId: String,
        completion: FetchCardCompletion
    ) {
        paymentProvider?.fetchPaymentCard(by: cardId) { creditCard, error in
            completion?(creditCard, error)
        }
    }

    /// Update the card details when the cardId already exist in stored cards list.
    /// - Parameters:
    ///    - paymentCard: Updated payment card details but the cardId should be the same.
    ///    - completion: *ManagePaymentCompletion* is a typealias for *(AddPaymentErrorModel?) -> Void*.
    public class func update(
        paymentCard: PaymentCardDetails,
        completion: @escaping ManagePaymentCompletion
    ) {
        paymentProvider?.update(paymentCard: paymentCard) { error in
            completion(error)
        }
    }

    /// Delete a specific payment card.
    /// - Parameters:
    ///    - cardId: Required card's Id.
    ///    - completion: *ManagePaymentCompletion* is a typealias for *(AddPaymentErrorModel?) -> Void*.
    public class func deletePaymentCard(
        by cardId: String,
        completion: @escaping ManagePaymentCompletion
    ) {
        paymentProvider?.deletePaymentCard(by: cardId) { error in
            completion(error)
        }
    }

    /// Pay a specific payment amount.
    /// - Parameters:
    ///    - amount: Payment amount.
    ///    - paymentCard: Card model that will be used in this transaction.
    ///    - completion: *(Error?) -> Void*.
    public class func pay(
        amount: Double,
        with paymentCard: PaymentModelProtocol,
        completion: @escaping PaymentProcessCompletion
    ) {
        paymentProvider?.pay(
            amount: amount,
            with: paymentCard) { error in
            completion(error)
        }
    }

    /// Set auto bill.
    /// - Parameters:
    ///    - day: Day when the user will be charged for his/her bill.
    ///    - paymentCard: Card model that will be used in auto bill.
    ///    - completion: *(Error?) -> Void*.
    public class func autoBill(
        day: Int,
        with paymentCard: PaymentModelProtocol,
        completion: @escaping PaymentProcessCompletion
    ) {
        paymentProvider?.autoBill(
            day: day,
            with: paymentCard) { error in
            completion(error)
        }
    }

    /// Set auto topUp.
    /// - Parameters:
    ///    - activeAutoTopUpModel: Auto topUp model.
    ///    - completion: *(Error?) -> Void*.
    public class func autoTopUp(
        activeAutoTopUpModel: VFGActiveAutoTopUpProtocol,
        completion: @escaping PaymentProcessCompletion
    ) {
        paymentProvider?.autoTopUp(activeAutoTopUpModel: activeAutoTopUpModel) { error in
            completion(error)
        }
    }

    // MARK: - Setup
    /// Setup topUp journey.
    /// - Parameters:
    ///    - initialTopup: TopUp protocol.
    ///    - withOffer: Boolean determine whether there's an offer with topUp or not.
    ///    - withCustomAmount: Boolean determine whether there's a custom amount that the user can enter or not, default is false.
    ///    - entryPoint: TopUp entry point *topUpTile, autoTopUp, etc*.
    ///    - amountPickerAxis: Topup Amount Picker Axis *vertical, horizontal*, default is vertical.
    ///    - addPaymentCardCustomView: *AddPaymentCardCustomView?*, default is nil.
    ///    - quickActionCustomHeaderView: Quick action custom header view, default is nil.
    ///    - topUpSomeoneElseCustomView: TopUp someone else custom view, default is nil.
    public class func setupTopUpJourney(
        initialTopup: VFGTopUpProtocol,
        withOffer: Bool,
        withCustomAmount: Bool = false,
        entryPoint: TopUpEntryPoint,
        amountPickerAxis: TopupAmountPickerAxis = .vertical,
        addPaymentCardCustomView: AddPaymentCardCustomView? = nil,
        successCustomQuickActionModel: VFQuickActionsModel? = nil,
        quickActionCustomHeaderView: UIView? = nil,
        topUpSomeoneElseCustomView: UIView? = nil
    ) {
        VFGPaymentManager.topupStateManager = VFGTopUpStateManager(
            initialTopProtocol: initialTopup,
            withOffer: withOffer,
            withCustomAmount: withCustomAmount,
            entryPoint: entryPoint,
            amountPickerAxis: amountPickerAxis,
            addPaymentCardCustomView: addPaymentCardCustomView,
            successCustomQuickActionModel: successCustomQuickActionModel,
            quickActionCustomHeaderView: quickActionCustomHeaderView,
            topUpSomeoneElseCustomView: topUpSomeoneElseCustomView)
    }

    /// Setup pay bill journey.
    /// - Parameters:
    ///    - initialPayBill: pay bill protocol.
    public class func setupPayBillJourney(initialPayBill: VFGPayBillProtocol) {
        VFGPaymentManager.payBillStateManager = VFGPayBillStateManager(initialPayBillProtocol: initialPayBill)
    }

    /// Setup auto bill journey.
    /// - Parameters:
    ///    - initialAutoBill: Auto bill protocol.
    ///    - isEditingMode: Boolean determines if the user is setting auto bill for first time if false or editing the auto billing details if true.
    public class func setupAutoBillJourney(initialAutoBill: VFGAutoBillProtocol, isEditingMode: Bool) {
        VFGPaymentManager.autoBillStateManager =
            VFGAutoBillStateManager(
                initialAutoBillProtocol: initialAutoBill,
                isEditingMode: isEditingMode
            )
    }

    /// Setup add plan journey.
    /// - Parameters:
    ///    - dataProvider: Add plan protocol.
    ///    - planType: Add plan type if sms, data or calls.
    ///    - titles: Failure add plan model.
    public class func setupAddPlanJourney(dataProvider: VFGAddPlanProtocol?, planType: AddPlanType, titles: VFGFailureAddPlanModel?, quickActionViewTitle: String? = nil, successAddPlanStrings: VFGSuccessAddPlanModel? = nil) {
        VFGPaymentManager.addPlanStateManager = VFGAddPlanStateManager(
            with: dataProvider,
            titles: titles,
            quickActionViewTitle: quickActionViewTitle,
            successAddPlanStrings: successAddPlanStrings
        )
        VFGPaymentManager.addPlanStateManager?.setup(planType)
    }

    /// Setup auto topUp journey.
    /// - Parameters:
    ///    - autoTopUpDelegate: Auto topUp delegate.
    ///    - isEditingMode: Boolean determines if the user is setting auto topUp for first time if false or editing the auto topUp details if true, default is false.
    ///    - activeAutoTopUpModel: Auto topUp model, default is nil.
    public class func setupAutoTopUpJourney(
        autoTopUpDelegate: VFGAutoTopUpProtocol,
        isEditingMode: Bool = false,
        activeAutoTopUpModel: VFGActiveAutoTopUpProtocol? = nil
    ) {
        autoTopUpStateManager = VFGAutoTopUpStateManager(
            autoTopUpDelegate: autoTopUpDelegate,
            isEditingMode: isEditingMode,
            activeAutoTopUpModel: activeAutoTopUpModel
        )
    }

    // MARK: - Navigation
    public class func navigateToPaymentListViewController() {
        guard let paymentListViewController = paymentProvider?.paymentListViewController else {
            return
        }
        let navController = MVA10NavigationController(rootViewController: paymentListViewController)
        navController.setTitle(
            title: "payment_method_screen_title".localized(bundle: .mva10Framework),
            for: paymentListViewController
        )
        navController.modalPresentationStyle = .fullScreen
        UIApplication.topViewController()?.present(navController, animated: true, completion: nil)
    }

    public class func navigateToAddNewCard(navigation: MVA10NavigationController?) {
        guard let addPaymentViewController = paymentProvider?.addPaymentViewController else {
            return
        }
        navigation?.setTitle(
            title: "payment_add_new_card_screen_title".localized(bundle: .mva10Framework),
            for: addPaymentViewController
        )
        navigation?.pushViewController(addPaymentViewController, animated: true)
    }

    public class func navigateToEditCard(
        navigation: MVA10NavigationController?,
        cardID: String? = nil,
        cardName: String? = nil
    ) {
        guard let addPaymentViewController =
            paymentProvider?.editPaymentViewController as? AddPaymentCardViewController else {
                return
        }
        var pageTitle = "payment_add_new_card_screen_title".localized(bundle: .mva10Framework)
        if cardID != nil {
            addPaymentViewController.cardId = cardID
            addPaymentViewController.cardName = cardName
            addPaymentViewController.isEditable = true
            pageTitle = ""
        }
        navigation?.setTitle(
            title: pageTitle,
            for: addPaymentViewController
        )
        navigation?.pushViewController(addPaymentViewController, animated: true)
    }
}
