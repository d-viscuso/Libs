//
//  VFDashboardFullScreenLoadingProviderProtocol.swift
//  VFGMVA10Framework
//
//  Created by Amr Koritem on 26/07/2022.
//

import VFGMVA10Foundation

/// VFDashboardFullScreenLoadingTrigers are events that can trigger a full screen loading
public enum VFDashboardFullScreenLoadingTrigers {
    case viewDidLoad, viewWillAppear, viewDidAppear
    case contentLoading, contentPopulated, contentEmpty, contentError, contentFiltered

    static func getFrom(contentState: VFGContentState) -> VFDashboardFullScreenLoadingTrigers {
        switch contentState {
        case .loading:
            return .contentLoading
        case .populated:
            return .contentPopulated
        case .empty:
            return .contentEmpty
        case .error:
            return .contentError
        case .filtered:
            return .contentFiltered
        }
    }
}

/// VFDashboardFullScreenLoadingProviderProtocol to handle full screen loading
public protocol VFDashboardFullScreenLoadingProviderProtocol: AnyObject {
    /// used to specify the view to be shown as a loading view when a specific event takes place
    /// - Parameters:
    ///     - event: Determine the triggering event.
    /// - Returns:
    ///     - the loading view to be shown
    func getLoadingView(for event: VFDashboardFullScreenLoadingTrigers) -> UIView?
}
