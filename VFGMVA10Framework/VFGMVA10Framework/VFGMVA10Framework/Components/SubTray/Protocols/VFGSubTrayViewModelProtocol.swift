//
//  VFGSubTrayViewModelProtocol.swift
//  VFGMVA10Framework
//
//  Created by Ahmed Sultan on 2/20/20.
//

import Foundation
/// A closure for sub tray view data fetch whether it succeeded or not
public typealias SubTrayCompletion = (VFGSubTrayModel?, Error?) -> Void
/// Protocol for sub tray view view model with its initial properties and methods
public protocol VFGSubTrayViewModelProtocol: AnyObject {
    /// Protocol instance for fetching sub tray data
    var dataProvider: VFGSubTrayDataProviderProtocol? { get set }
    /// Sub tray view setup
    /// - Parameters:
    ///    - key: Sub tray id
    ///    - subtrayTitle: Sub tray title text
    ///    - trayConfigurations: Dictionary data for tray
    ///    - completion: A closure for sub tray view data fetch whether it succeeded or not
    /// - Returns: Sub tray view data model
    func setup(
        key subtrayId: String,
        subtrayTitle: String,
        trayConfigurations: [String: Any]?,
        completion: SubTrayCompletion?
    ) -> VFGSubTrayModel?
}
