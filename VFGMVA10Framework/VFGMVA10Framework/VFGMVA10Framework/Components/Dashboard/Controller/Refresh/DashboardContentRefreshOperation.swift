//
//  DashboardContentRefreshOperation.swift
//  VFGMVA10Framework
//
//  Created by Yahya Saddiq on 11/4/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//
/// Dashboard contents refresh operation
class DashboardContentRefreshOperation: VFGOperation {
    override func start() {
        guard !isCancelled else { return }

        state = .isExecuting

        VFGManagerFramework.dashboardDelegate?.refreshContent {
            self.state = .isFinished
        }
    }
}
