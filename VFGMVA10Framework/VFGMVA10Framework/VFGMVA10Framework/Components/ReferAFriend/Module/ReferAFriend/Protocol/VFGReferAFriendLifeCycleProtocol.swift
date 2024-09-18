//
//  VFGReferAFriendLifeCycleProtocol.swift
//  VFGMVA10Framework
//
//  Created by Mohamed Zaki on 29/09/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import Foundation

/// VFGReferAFriendLifeCycleProtocol
public protocol VFGReferAFriendLifeCycleProtocol: AnyObject {
    /// A method that is called when entering viewDidLoad
    func referAFriendViewDidLoad()
    /// A method that is called when the viewController will appear
    func referAFriendViewWillAppear(_ animated: Bool)
    /// A method that is called when the viewController did appear
    func referAFriendViewDidAppear(_ animated: Bool)
    /// A method that is called when the viewController did disappear
    func referAFriendViewDidDisappear(_ animated: Bool)
    /// A method that is called when clicking on share button
    func referAFriendShareButtonPressed()
    /// A method that is called when clicking on read terms button
    func referAFriendReadTermsButtonPressed()
    /// A method that is called when clicking on back button
    func referAFriendBackButtonPressed()
}
