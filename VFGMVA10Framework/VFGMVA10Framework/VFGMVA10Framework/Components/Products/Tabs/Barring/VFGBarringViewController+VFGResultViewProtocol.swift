//
//  VFGBarringViewController+VFGResultViewProtocol.swift
//  VFGMVA10Framework
//
//  Created by Trachani, Vasiliki, Vodafone on 22/5/22.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

// MARK: - VFGResultViewProtocol
extension VFGBarringViewController: VFGResultViewProtocol {
    public func resultViewPrimaryButtonAction() {
        quickActionsResultView?.closeQuickAction()
        if barringAskChangesStatus {
            /// 'isPermissionsListRefreshing' decides if the permissions list will be refreshed
            if let isPermissionsListRefreshing = barringViewModel?.viewDetails?.isBarringListRefreshing,
                isPermissionsListRefreshing {
                self.refresh()
            }
            self.barringViewModel?.viewDetails?.didFinish(isDismissed: false)
            self.dismiss(animated: true) {
                self.barringViewModel?.viewDetails?.didFinish(isDismissed: true)
            }
        } else {
            /// try again to ask permissions changes
            guard let currentModel = currentBarringItemModel else { return }
            confirmPermissionAskChangesAction(permissionViewModel: currentModel)
            currentBarringItemModel = nil
        }
    }
}
