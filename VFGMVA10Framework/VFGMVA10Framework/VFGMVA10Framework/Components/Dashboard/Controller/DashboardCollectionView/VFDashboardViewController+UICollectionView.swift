//
//  VFDashboardViewController+UICollectionView.swift
//  VFGMVA10Group
//
//  Created by Mahmoud Amer on 8/8/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import VFGMVA10Foundation
import UIKit

extension VFDashboardViewController: UICollectionViewDataSource {
    /// *VFDashboardViewController* collection view configuration
    func setupCollectionView() {
        let mva10ConstraintPriority = isMVA12Theme ? UILayoutPriority.defaultLow : UILayoutPriority(rawValue: 999)
        collectionTopConstraintMva10.priority = mva10ConstraintPriority
        let mva12ConstraintPriority = isMVA12Theme ? UILayoutPriority(rawValue: 999) : UILayoutPriority.defaultLow
        collectionTopConstraintMva12.priority = mva12ConstraintPriority
        let layout = VFDashboardItemLayout()
        layout.topInset = isMVA12Theme ?
        collectionBackgroundTop.constant + mva12DashboardTopInsetExtraPadding : 0

        layout.delegate = self
        collectionView.collectionViewLayout = layout
        registerViews()
    }
    /// *VFDashboardViewController* collection views registeration
    func registerViews() {
        let discoverHeaderXib = UINib(nibName: Constants.Dashboard.View.discoverHeader, bundle: .mva10Framework)
        let refreshFooterXib = UINib(nibName: Constants.Dashboard.View.refreshView, bundle: .mva10Framework)

        collectionView.register(
            refreshFooterXib,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: Constants.Dashboard.Identifier.refreshFooter)
        collectionView.register(
            discoverHeaderXib,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: Constants.Dashboard.Identifier.discoverHeader)
        collectionView.register(
            UICollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: Constants.Dashboard.Identifier.defaultReusableView)
        collectionView.register(
            UICollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: Constants.Dashboard.Identifier.defaultEIOHeaderView)
    }
    /// Add empty footer view to collection view
    /// - Parameters:
    ///    - indexPath: Current index for empty footer view
    func emptyReusableView(for indexPath: IndexPath) -> UICollectionReusableView {
        collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: Constants.Dashboard.Identifier.defaultReusableView,
            for: indexPath
        )
    }
    /// Empty header view for EIO
    /// - Parameters:
    ///    - indexPath: Current index for empty header view
    func emptyEIOView(for indexPath: IndexPath) -> UICollectionReusableView {
        let reusableHeader = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: Constants.Dashboard.Identifier.defaultEIOHeaderView,
            for: indexPath
        )
        return reusableHeader
    }

    // MARK: - Collection View Data Source Methods
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard let dataSource = dashboardDataSource, error == nil else { return 1 }
        if dataSource.state == .loading && fullScreenLoadingDelegate != nil {
            return 0
        }

        return dataSource.numberOfSections()
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let dataSource = dashboardDataSource, error == nil else { return 0 }

        return dataSource.numberOfItemsAtSection(section: section)
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: Constants.Dashboard.Identifier.cell,
            for: indexPath)
        guard let itemCell = cell as? VFDashboardCell else {
            return cell
        }
        let itemModel = dashboardDataSource?.cardAtIndex(indexPath: indexPath)
        (itemModel as? VFGDashboardItemViewModel)?.delegate = self
        guard let item = itemModel?.componentEntry else {
            return cell
        }

        itemCell.viewComponentEntry = item
        if itemModel?.isShadowEnabled == true {
            itemCell.addShadow()
        } else {
            itemCell.removeShadow()
        }
        if !(item is DashboardFunFactComponentEntry) {
            cellDidScroll(dashboardCell: itemCell)
        }
        return itemCell
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        let isRefreshHidden = dashboardCardsModel?.isRefreshViewHidden ?? false
        let isFirstSection = indexPath.section == 0
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard dashboardDataSource?.enableHeaderForSection(at: indexPath.section) ?? true else {
                return emptyCollectionHeaderView(indexPath)
            }
            if indexPath.section == 0 {
                if VFGManagerFramework.dashboardDelegate?.dashboardManager?.customHeaderModel != nil {
                    return discoverHeader(indexPath)
                } else {
                    return VFGEIOManager.shared.dashboardHeader(
                        oldStatus: oldStatus,
                        isFromSplash: dashboardFromSplash
                    )
                }
            }

            return discoverHeader(indexPath)
        case UICollectionView.elementKindSectionFooter
            where isFirstSection && !isRefreshHidden && error == nil && !isMVA12Theme:
            return refreshFooter(indexPath)
        default:
            return emptyReusableView(for: indexPath)
        }
    }
    /// Handle refreshing collection view footer
    /// - Parameters:
    ///    - indexPath: Current index for footer view to refresh
    func refreshFooter(_ indexPath: IndexPath) -> UICollectionReusableView {
        collectionView?.collectionViewLayout.invalidateLayout()
        guard
            let refreshManager = refreshManager,
            refreshManager.refreshView == nil,
            let refreshFooterView = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionFooter,
                withReuseIdentifier: Constants.Dashboard.Identifier.refreshFooter,
                for: indexPath) as? VFGRefreshFooterView else {
            if let refreshView = refreshManager?.refreshView as? UICollectionReusableView {
                return refreshView
            }

            return emptyReusableView(for: indexPath)
        }

        refreshFooterView.delegate = self
        refreshManager.refreshView = refreshFooterView
        switch dashboardDataSource?.state {
        case .loading:
            refreshFooterView.applyShimmer()
            refreshManager.refreshWillStart()
        case .error:
            refreshManager.refreshDidFail()
            refreshFooterView.stopShimmer()
        case .populated:
            refreshManager.refreshDidSucceed()
            refreshFooterView.stopShimmer()
        default:
            break
        }
        return refreshFooterView
    }
    /// Return discover section header view
    /// - Parameters:
    ///    - indexPath: Current index for discover section header view
    func discoverHeader(_ indexPath: IndexPath) -> UICollectionReusableView {
        if isMVA12Theme && dashboardDataSource?.state == .loading {
            if dashboardDataSource as? VFGMVA12DashboardShimmerModel != nil {
                return discoverHeaderShimmer(indexPath)
            }
        }
        let headerView = collectionView
            .dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: Constants.Dashboard.Identifier.discoverHeader,
                for: indexPath)
        guard let discoverHeader = headerView as? VFDiscoverHeader else {
            return headerView
        }
        let componentEntry = dashboardDataSource?.cardAtIndex(indexPath: indexPath)?.componentEntry
        showSeeAllInHorizontalDiscover(with: discoverHeader, componentEntry: componentEntry)
        let discoverIndex = dashboardDataSource?.discoverIndexInSections()
        let titleFont: UIFont = indexPath.section == discoverIndex ? .vodafoneBold(29) : .vodafoneBold(25)
        let titleText = dashboardDataSource?
            .titleForSection(at: indexPath.section)
            .localized(bundle: Bundle.mva10Framework)
        discoverHeader.setupTitleLabel(with: titleText, and: titleFont)
        return discoverHeader
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        dashboardDataSource?.didSelectCardAtIndex(indexPath: indexPath)
    }

    func discoverHeaderShimmer(_ indexPath: IndexPath) -> UICollectionReusableView {
        let discoverHeaderShimmerXib = UINib(
            nibName: Constants.Dashboard.View.discoverHeaderShimmer,
            bundle: .mva10Framework
        )
        collectionView.register(
            discoverHeaderShimmerXib,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: Constants.Dashboard.Identifier.discoverHeaderShimmer)
        let headerShimmerView = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: Constants.Dashboard.Identifier.discoverHeaderShimmer,
            for: indexPath)
        guard let discoverHeaderShimmer = headerShimmerView as? VFGDiscoverHeaderShimmer else {
            return headerShimmerView
        }
        discoverHeaderShimmer.startShimmer()
        return discoverHeaderShimmer
    }

    func showSeeAllInHorizontalDiscover(with discoverHeader: VFDiscoverHeader, componentEntry: VFGComponentEntry?) {
        if let cardView = componentEntry?.cardView as? VFGSeeAllProtocol, cardView.shouldShowSeeAll {
            discoverHeader.isSeeAllShow = true
            discoverHeader.seeAllAction = { [weak self] in
                guard let self = self else { return }
                switch cardView {
                case let horizontalDiscoverView as HorizontalDiscoverView:
                    if let action = horizontalDiscoverView.showSeeAllAction {
                        action()
                    } else {
                        self.showDiscoverView(
                            with: horizontalDiscoverView.viewModel?.discoverList,
                            delegate: horizontalDiscoverView
                        )
                    }
                case let marketplaceView as VFGMarketplaceView:
                    if let action = marketplaceView.showSeeAllAction {
                        action()
                    } else {
                        self.showMarketplaceView(with: marketplaceView.viewModel?.products)
                    }
                default:
                    cardView.showSeeAllAction?()
                }
            }

            if let seeAllButtonTitle = cardView.title, let seeAllButtonColor = cardView.color {
                discoverHeader.setupSeeAllButton(title: seeAllButtonTitle, color: seeAllButtonColor)
            }
        } else {
            discoverHeader.isSeeAllShow = false
        }
    }

    func showDiscoverView(with discoverList: [HorizontalDiscoverItemModel]?, delegate: VFGDiscoverListViewControllerDelegate? = nil) {
        let discoverListVC = VFGDiscoverListViewController(discoverList ?? [])
        discoverListVC.delegate = delegate
        let navController = MVA10NavigationController(rootViewController: discoverListVC)
        navController.isCloseButtonHidden = false
        navController.hasDivider = false
        let title = "dashboard_discovery_label".localized(bundle: .mva10Framework)
        navController.setTitle(title: title, for: discoverListVC)
        present(navController, animated: true)
    }

    func showMarketplaceView(with products: [VFGMarketplaceProductModel]?) { }
}

extension VFDashboardViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForFooterInSection section: Int
    ) -> CGSize {
        return .zero
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        guard let dashboardCell = cell as? VFDashboardCell else {
            return
        }
        if dashboardDataSource?.state != .loading && refreshManager?.isRefreshing == true {
            cell.alpha = 0
            cell.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            UIView.animate(
                withDuration: 0.2,
                delay: 0.1,
                options: .curveEaseInOut,
                animations: {
                    cell.alpha = 1.0
                    cell.transform = .identity
                }, completion: nil)
        }
        dashboardCell.viewComponentEntry?.willDisplay()
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        didEndDisplaying cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        guard let dashboardCell = cell as? VFDashboardCell else {
            return
        }
        dashboardCell.viewComponentEntry?.didEndDisplay()
    }
    /// Check discover section boundaries and position
    func checkDiscoverThreshold() {
        guard isMVA12Theme == false else { return }
        guard let collectionView = collectionView,
            let stickyHeaderY = discoverSnapThreshold else {
            return
        }
        let contentOffsetY = collectionView.contentOffset.y
        let topBoundary = stickyHeaderY - Constants.DashboardDiscoverSnap.discoverSnappingTopThreshold
        let bottomBoundary = stickyHeaderY + Constants.DashboardDiscoverSnap.discoverSnappingBottomThreshold
        let aboveThreshold = contentOffsetY >= topBoundary
        let bellowThreshold = contentOffsetY <= bottomBoundary
        if aboveThreshold && bellowThreshold {
            scrollToDiscover()
        }
    }
    /// Animation process to scroll to discover section
    func scrollToDiscover() {
        UIView.animate(withDuration: 0.2) {
            let newOffset = (self.discoverSnapThreshold ?? 0) -
            Constants.DashboardDiscoverSnap.discoverTopMargin
            self.collectionView?.contentOffset.y = newOffset
        }
    }
    /// Empty header view for collection sections
    /// - Parameters:
    ///    - indexPath: Current index for empty header view
    private func emptyCollectionHeaderView(_ indexPath: IndexPath) -> UICollectionReusableView {
        collectionView.register(
            VFGDefaultSectionHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: Constants.Dashboard.Identifier.defaultSectionHeader)

        let emptyHeader = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: Constants.Dashboard.Identifier.defaultSectionHeader,
            for: indexPath)
        return emptyHeader
    }
}

extension VFDashboardViewController: VFGRefreshViewDelegate {
    public func refreshButtonDidPress() {
        refreshDashboard(self)
        if let refreshStatusModel = dashboardDataSource?.refreshStatusModel {
            refreshManager?.refreshStatusModel = refreshStatusModel
        }
    }
}

extension VFDashboardViewController: VFGDashboardItemViewModelDelegate {
    func reloadDashboardCollectionView() {
        collectionView.reloadData()
        if checkIfLastItemIsFunFact() {
            updateLastItem(height: latestBouncedHeight)
        }
    }
}
