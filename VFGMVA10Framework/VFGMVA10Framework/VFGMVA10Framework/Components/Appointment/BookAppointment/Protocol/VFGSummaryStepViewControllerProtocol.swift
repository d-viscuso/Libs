//
//  VFGSummaryStepViewControllerProtocol.swift
//  VFGMVA10Framework
//
//  Created by Yahya Saddiq on 2/12/21.
//  Copyright © 2021 Vodafone. All rights reserved.
//

/// Summary step view controller protocol.
public protocol VFGSummaryStepViewControllerProtocol: VFGBaseStepsViewControllerProtocol {
    /// Show the summary of the user's appointment before confirmation.
    /// - Parameters:
    ///    - VFGAppointmentModelProtocol: Appointment model.
    func summarize(with: VFGAppointmentModelProtocol)
}
