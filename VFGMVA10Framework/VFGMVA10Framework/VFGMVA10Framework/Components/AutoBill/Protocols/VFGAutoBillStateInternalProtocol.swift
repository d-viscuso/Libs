//
//  VFGAutoBillStateInternalProtocol.swift
//  VFGMVA10Framework
//
//  Created by Hussein Kishk on 31/01/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation
/// Internal protocol for auto bill quick actions
protocol VFGAutoBillStateInternalProtocol: VFGQuickActionStateInternalProtocol {
    // MARK: - initial autoBill
    /// Initial auto bill quick action presentation
    func initialAutoBillPresent()
    /// Initial auto bill quick action method to be called after presentation
    /// - Parameters:
    ///    - paymentCard: Default payment card selected for initial top up
    ///    - selectedDay: Selected day for auto bill payment
    func initialAutoBillFinished(with paymentCard: PaymentModelProtocol?, selectedDay: Int?)

    // MARK: - loading
    /// Present auto bill loading screen
    func loadingAutoBillPresent()
    /// Handle auto bill status after loading is finished
    /// - Parameters:
    ///    - success: Determine whether auto bill succeeded or not
    func loadingAutoBillFinished(success: Bool)

    // MARK: - Success screen
    /// Present auto bill success screen
    func successAutoBillPresent()
    /// Actions to be done after auto bill is finished
    func finishAutoBill()

    // MARK: - Failure screen
    /// Present auto bill failure screen
    func presentFailureView()
    /// Try again button action
    func tryAgain()
}
