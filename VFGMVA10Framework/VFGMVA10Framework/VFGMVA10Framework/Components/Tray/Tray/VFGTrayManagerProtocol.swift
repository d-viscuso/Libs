//
//  VFGTrayManagerProtocol.swift
//  VFGMVA10Group
//
//  Created by Ehab Amer on 8/14/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import Foundation

/// Tray manager protocol.
public protocol VFGTrayManagerProtocol: AnyObject {
    /// Method that is called when tray finishes it's setup.
    /// - Parameters:
    ///     - error: Error if an error ocuured while setting up tray.
    func traySetupFinished(error: Error?)
    /// Method that is called to update tray image at a specific index.
    /// - Parameters:
    ///     - image: New *UIImage* that you want to show.
    ///     - index: Index of the tray.
    func updateTrayImage(with image: UIImage, at index: Int)
}
