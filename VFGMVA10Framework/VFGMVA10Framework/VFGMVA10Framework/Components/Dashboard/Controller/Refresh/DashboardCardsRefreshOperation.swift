//
//  DashboardCardsRefreshOperation.swift
//  VFGMVA10Framework
//
//  Created by Yahya Saddiq on 11/4/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//
/// Dashboard cards refresh operation
class DashboardCardsRefreshOperation: VFGOperation {
    /// Dashobard cards data
    var dashboardCardsModel: VFGDashboardItemsProtocol
    /// *DashboardCardsRefreshOperation* intializer
    /// - Parameters:
    ///    - dashboardCardsModel: Dashobard cards data
    init(_ dashboardCardsModel: VFGDashboardItemsProtocol) {
        self.dashboardCardsModel = dashboardCardsModel
        super.init()
    }

    override func start() {
        guard !isCancelled else { return }

        state = .isExecuting

        dashboardCardsModel.refresh { _ in
            self.state = .isFinished
        }
    }
}
