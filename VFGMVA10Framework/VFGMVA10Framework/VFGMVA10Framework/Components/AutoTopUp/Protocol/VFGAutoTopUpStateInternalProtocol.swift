//
//  VFGAutoTopUpStateInternalProtocol.swift
//  VFGMVA10Framework
//
//  Created by Moataz Akram on 08/09/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation
/// Internal protocol for auto top up quick action
protocol VFGAutoTopUpStateInternalProtocol: AnyObject {
    // MARK: - initial autoBill
    /// Initial auton top up quick action presentation
    func initialAutoTopUpPresent()
    /// Initial auto top up quick action method to be called after presentation
    /// - Parameters:
    ///    - autoTopUpType: Auto top up type
    ///    - exactOcurrence: Occurrence type
    func initialAutoTopUpFinished(autoTopUpType: String, exactOcurrence: String)

    // MARK: - topUp
    /// Present top up quick action
    func topUpPresent()
    /// Top up offer quick action method to be called after presentation
    /// - Parameters:
    ///    - amount: Selected amount to top up with
    ///    - paymentCard: Selected payment card to top up with
    func topUpFinished(amount: Double, paymentCard: PaymentModelProtocol?)

    // MARK: - loading
    /// Present auto top up loading screen
    func loadingAutoTopUpPresent()
    /// Actions to be done after auto top up loading screen with auto top up succeeded or failed
    /// - Parameters:
    ///    - success: Determine whether auto top up succeeded or failed
    func loadingAutoTopUpFinished(success: Bool)

    // MARK: - Success screen
    /// Present auto top up success screen
    func successAutoTopUpPresent()
    /// Actions to be done after auto top up loading screen with auto top up succeeds
    func finishAutoTopUp()

    // MARK: - Failure screen
    /// Present auto top up failure screen
    func presentFailureView()
    /// Try again button action
    func tryAgain()
}
