//
//  VFGTwoActionsViewProtocol.swift
//  VFGMVA10Foundation
//
//  Created by Mohamed Abd ElNasser on 7/5/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//
/// two actions view protocol that used for action delegation 
public protocol VFGTwoActionsViewProtocol: AnyObject {
    /// Notify the delegate once the primary button is clicked.
    func primaryButtonAction()
    /// Notify the delegate once the secondary button is clicked.
    func secondaryButtonAction()
}
