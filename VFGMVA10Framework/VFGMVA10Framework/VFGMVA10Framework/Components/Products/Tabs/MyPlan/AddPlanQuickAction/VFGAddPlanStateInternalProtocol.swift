//
//  VFGAddPlanStateInternalProtocol.swift
//  VFGMVA10Framework
//
//  Created by Hussein Kishk on 7/5/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation

/// Add plan state internal protocol.
public protocol VFGAddPlanStateInternalProtocol: VFGQuickActionStateInternalProtocol {
    // MARK: - Add Data screen
    /// Present add plan quick action.
    func presentAddPlanView()
    /// Method is called when the user confirms the selected plan.
    /// - Parameters:
    ///    - selectedPlanIndexPath: Index path of the selected plan.
    ///    - isRecurring: Boolean determines whether the selected plan is recurring or not.
    ///    - serviceType: Service type.
    ///    - paymentCard: The card which will be used in payment.
    ///    - amount: The amount that will be paid.
    func addPlanFinished(selectedPlanIndexPath: IndexPath, isRecurring: Bool, serviceType: String, with paymentCard: PaymentModelProtocol, amount: Double)

    // MARK: - loading
    /// This method is  called to start loading quick action.
    func presentLoadingView()
    /// Method is called when the loading is finished.
    /// - Parameters:
    ///    - success: Boolean determines whether adding plan succeeded or failed.
    ///    - selectedPlanIndexPath: Index path of the selected plan.
    ///    - isRecurring: Boolean determines whether the selected plan is recurring or not.
    func loadingViewFinished(success: Bool, selectedPlanIndexPath: IndexPath, isRecurring: Bool)

    // MARK: - Success screen
    /// This method is  called to present success view.
    func presentSucccessView()
    /// This method is  called to dismiss success view.
    func successViewFinished()

    // MARK: - Failure screen
    /// This method is  called to present failure view.
    func presentFailureView()
    /// This method is  called to dismiss failure view.
    func failureViewFinished()

    // MARK: - dismiss
    /// This method is  called to dismiss the quick action view.
    func dismissQuickAction()
}
