//
//  VFGPayBillStateInternalProtocol.swift
//  VFGMVA10Framework
//
//  Created by Atta Ahmed on 11/17/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation

protocol VFGPayBillStateInternalProtocol: VFGQuickActionStateInternalProtocol {
    // MARK: - initial topUp
    func initialPayBillPresent()
    func initialPayBillFinished(with paymentCard: PaymentModelProtocol?)
    func initialPayBillFinished(selectedViewId: String?)

    // MARK: - loading
    func loadingPayBillPresent()
    func loadingPayBillFinished(success: Bool)

    // MARK: - Success screen
    func successPayBillPresent()
    func finishPayBill()

    // MARK: - Failure screen
    func presentFailureView()
    func tryAgain()
}
