//
//  VFGPersonalAdvisorResultProtocol.swift
//  VFGMVA10PersonalAdvisor
//
//  Created by Vasiliki Trachani, Vodafone on 16/08/2022.
//

import Foundation

public protocol VFGPersonalAdvisorResultProtocol: AnyObject {
    /// showing success view method.
    func showSuccessQuickResult()
    /// showing error view method.
    func showErrorQuickResult()
}
