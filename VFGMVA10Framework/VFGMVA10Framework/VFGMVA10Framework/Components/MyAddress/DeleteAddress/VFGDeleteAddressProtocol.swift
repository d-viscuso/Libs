//
//  VFGDeleteAddressProtocol.swift
//  VFGMVA10Framework
//
//  Created by Ahmed Ramzy on 18/01/2022.
//

import Foundation

/// Delete address protocol
public protocol VFGDeleteAddressProtocol: AnyObject {
    /// Delete address confirm button action 
    func didTapDeleteAddressConfirmButton(completion: @escaping (Bool) -> Void)
}
