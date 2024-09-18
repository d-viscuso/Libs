//
//  VFGCustomHeaderModel.swift
//  VFGMVA10Framework
//
//  Created by Moustafa Hegazy on 20/06/2021.
//

import Foundation
/// Dashboard custom header model
public class VFGCustomHeaderModel: VFGCustomHeaderModelProtocol {
    /// Dashboard custom header container header view
    public var headerViewContainer: UIView
    /// Dashboard custom header container floating view
    public var floatingViewContainer: UIView?
    /// Dashboard custom header container header view height
    public var headerContainerHeight: CGFloat
    /// Dashboard custom header container header view minimum height
    public var minHeaderContainerHeight: CGFloat
    /// Dashboard custom header container floating view height
    public var floatingContainerHeight: CGFloat?
    /// *VFGCustomHeaderModel* initializer
    /// - Parameters:
    ///    - headerViewContainer: Dashboard custom header container header view
    ///    - floatingViewContainer: Dashboard custom header container floating view
    ///    - headerContainerHeight: Dashboard custom header container header view height
    ///    - minHeaderContainerHeight: Dashboard custom header container header view minimum height
    ///    - floatingContainerHeight: Dashboard custom header container floating view height
    public init(
        headerViewContainer: UIView,
        floatingViewContainer: UIView?,
        headerContainerHeight: CGFloat,
        minHeaderContainerHeight: CGFloat,
        floatingContainerHeight: CGFloat?
    ) {
        self.headerViewContainer = headerViewContainer
        self.floatingViewContainer = floatingViewContainer
        self.headerContainerHeight = headerContainerHeight
        self.minHeaderContainerHeight = minHeaderContainerHeight
        self.floatingContainerHeight = floatingContainerHeight
    }
}
