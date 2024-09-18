//
//  VFGTopupUserInteractionProtocol.swift
//  VFGMVA10Framework
//
//  Created by Ünal Öztürk on 1.04.2022.
//

import Foundation

/// TopUp user interaction protocol.
public protocol VFGTopupUserInteractionProtocol: AnyObject {
    /// topUp contact button press notify
    func contactButtonDidPress()
    /// topUp quick action header press notify
    func headerButtonDidPress()
    /// add new card button press notify
    func addNewCardDidPress()
    /// topUp presented main page notify
    func topUpPresented()
}

public extension VFGTopupUserInteractionProtocol {
    func contactButtonDidPress() {}
    func headerButtonDidPress() {}
    func addNewCardDidPress() {}
    func topUpPresented() {}
}
