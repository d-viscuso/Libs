//
//  VFGPersonalAdvisorPreviousRequestResultProtocol.swift
//  VFGMVA10PersonalAdvisor
//
//  Created by Vasiliki Trachani, Vodafone on 17/08/2022.
//

import Foundation

public protocol VFGPersonalAdvisorPreviousRequestResultProtocol: AnyObject {
    /// create quick action view.
    func createPreviousRequestStatusView(type: VFGStatusPreviousRequest) -> VFGPersonalAdvisorStatusRequestViewModel?
}
