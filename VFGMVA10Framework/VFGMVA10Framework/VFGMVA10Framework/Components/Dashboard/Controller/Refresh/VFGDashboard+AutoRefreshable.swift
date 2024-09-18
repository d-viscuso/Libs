//
//  VFGDashboard+AutoRefreshable.swift
//  MVA10Framework
//
//  Created by Yahya Saddiq on 10/22/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

extension VFDashboardViewController: AutoRefreshable {
    func refreshDashboard(_ sender: Any) {
        guard let dashboardCardsModel = dashboardCardsModel else {
            return
        }

        if let refreshControl = sender as? UIRefreshControl {
            self.refreshControl = refreshControl
        }

        let operationQueue = OperationQueue()
        operationQueue.maxConcurrentOperationCount = 3

        let dashboardContentRefreshOperation = DashboardContentRefreshOperation()
        let dashboardCardsRefreshOperation = DashboardCardsRefreshOperation(dashboardCardsModel)

        let refreshOperation = BlockOperation { [weak self] in
            DispatchQueue.main.async {
                self?.refreshControl?.endRefreshing()
                if self?.isMVA12Theme == true, self?.mva12RefreshControl != nil {
                    self?.endMVA12Refreshing()
                } else {
                    self?.reloadDashboard()
                }
                self?.scheduleAutoRefresh()
                self?.refreshControl = nil
                self?.collectionViewContentOffset = nil
            }
        }

        refreshOperation.addDependency(dashboardCardsRefreshOperation)
        refreshOperation.addDependency(dashboardContentRefreshOperation)

        operationQueue.addOperations(
            [
                dashboardCardsRefreshOperation,
                dashboardContentRefreshOperation,
                refreshOperation
            ],
            waitUntilFinished: false
        )

        trayViewController()?.refreshTrayItemBadges()
    }
    /// Refresh process to handle new data request
    /// - Parameters:
    ///    - model: Dashboard items new data
    func loadAgain(model: VFGDashboardItemsProtocol?) {
        model?.refresh { [weak self] error in
            self?.handleRefresh(error: error)
        }
    }

    private func handleRefresh(error: Error?) {
        guard error == nil else {
            dashboardDataSource = self.dashboardCardsModel
            self.error = error
            return
        }
        reloadDashboard()
    }
    /// Reload dashboard contents with the updated data
    func reloadDashboard() {
        guard collectionView != nil else {
            return
        }

        switch dashboardDataSource?.state {
        case .populated:
            dashboardDataSource = dashboardCardsModel
            collectionView.isScrollEnabled = true
            guard isMVA12Theme else { return }
            let dashboardManager = VFGManagerFramework.dashboardDelegate?.dashboardManager
            dashboardManager?.setCustomHeaderModelForMVA12(isLoading: false)
            setupTopHeaderView()
            if dashboardManager?
                .dashboardModel?.floatingTOBIModel != nil && !VFGFloatingTobiView.shared.isFloatingTobiShown {
                VFGFloatingTobiView.shared.showTOBI(
                    tobiContainer: self,
                    tobiModel: dashboardManager?.dashboardModel?.floatingTOBIModel)
            }
        default:
            collectionView.isScrollEnabled = false
        }
    }
    /// Show error card view in dashboard if fetching data failed
    internal func showDashboardError() {
        let errorDescription = Constants.ErrorCard.description
        let errorConfig = VFGErrorModel(
            title: error?.localizedDescription,
            description: errorDescription,
            tryAgainText: Constants.ErrorCard.tryAgainText
        )

        errorCardView = VFGErrorView(
            error: errorConfig,
            accessibilityIdInitial: "DBerror"
        )

        guard let collectionView = self.collectionView,
            let errorCardView = errorCardView else { return }

        errorCardView.refreshingClosure = { [weak self] in
            guard let self = self else { return }
            self.removeDashboardError()
            self.setupShimmerModel()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.loadAgain(model: self.dashboardCardsModel)
            }
        }

        errorCardView.alpha = 0
        collectionView.addSubview(errorCardView)

        errorCardView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            errorCardView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorCardView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            errorCardView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            errorCardView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
        UIView.animate(withDuration: Constants.ErrorCard.visibilityDuration) {
            errorCardView.alpha = 1
        }
    }
    /// Handle removing error card view from dashboard
    func removeDashboardError() {
        error = nil
        errorCardView?.removeFromSuperview()
        errorCardView = nil
    }
    /// Dashboard shimming configuration
    func setupShimmerModel() {
        if isMVA12Theme {
            dashboardDataSource = shimmerModelMVA12
        } else {
            dashboardDataSource = shimmerModel
        }
        // to be enhancement keep this comments
        //        shimmerModel = VFGDashboardShimmerModel()
        //        shimmerModel?.refresh(completionForRefresh: { _, _ in
        //            self.dashBoardDataSource = self.shimmerModel
        //        })
    }
}
