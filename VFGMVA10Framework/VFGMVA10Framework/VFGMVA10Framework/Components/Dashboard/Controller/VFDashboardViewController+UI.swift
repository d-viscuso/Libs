//
//  VFDashboardViewController+UI.swift
//  VFGMVA10Framework
//
//  Created by Amr Koritem on 03/10/2022.
//

import VFGMVA10Foundation

extension VFDashboardViewController {
    public func setupPullToRefresh(isMva12: Bool) {
        let isPullToRefreshEnabled = pullToRefreshModel?.isEnabled ?? false
        guard isPullToRefreshEnabled else { return }

        let refreshControl = UIRefreshControl()
        var tintColor: UIColor = .clear

        if isMva12 {
            mva12RefreshControl = DashboardRefreshControl()
            guard let mva12RefreshControl else {return}
            mva12RefreshControl.frame = refreshControl.bounds
            refreshControl.addSubview(mva12RefreshControl)
            mva12RefreshControl.scrollView = collectionView
            mva12RefreshControl.refreshControl = refreshControl
            mva12RefreshControl.refreshAction = { [weak self] in
                guard let self = self else { return }
                    self.refreshDashboard(mva12RefreshControl)
                }
            } else {
            refreshControl.addTarget(self, action: #selector(refreshDashboard(_:)), for: .valueChanged)
            tintColor = pullToRefreshModel?.tintColor ?? .VFGLightGreyBackground
            refreshControl.backgroundColor = pullToRefreshModel?.backgroundColor ?? .clear
        }
        refreshControl.tintColor = tintColor
        collectionView.alwaysBounceVertical = true
        collectionView.addSubview(refreshControl)
    }

    /// Update *VFDashboardViewController* background color
    /// - Parameters:
    ///    - eioStatus: EIO current status
    func updateBackground(_ eioStatus: EIOStatus?) {
        let startPoint = CGPoint(x: 1.0, y: 0.0)
        backgroundView.layer.sublayers?.removeAll()
        guard eioStatus == .success else {
            backgroundView.setGradientBackgroundColor(colors: UIColor.VFGDiscoverRedGradient, startPoint: startPoint)
            return
        }
        guard #available(iOS 12.0, *) else { return }
        backgroundView.backgroundColor = .VFGDarkGreyBackground
    }

    /// Update *VFDashboardViewController* background layer frame
    func updateBackgroundGradientLayerFrame() {
        backgroundView.layer.sublayers?.first?.frame = backgroundView.bounds
    }

    func updateBackgroundImage() {
        backgroundImageView?.isHidden = backgroundImageName == nil || backgroundImageName?.isEmpty == true
        guard let backgroundImageName = backgroundImageName else { return }
        backgroundImageView?.image = VFGImage(named: backgroundImageName)
    }

    func updateCollectionBackgroundRoundCorner() {
        guard let roundCorner = collectionBackgroundRoundCorner else { return }
        collectionBackgroundView?.roundCorners(cornerRadius: roundCorner)
    }

    func checkForFullScreenLoading(for event: VFDashboardFullScreenLoadingTrigers) {
        guard let loadingView = fullScreenLoadingDelegate?.getLoadingView(for: event) else { return }
        showFullScreenLoadingView(loadingView)
    }

    func showFullScreenLoadingView(_ loadingView: UIView) {
        view.embed(view: loadingView)
        fullScreenLoadingView = loadingView
    }

    func hideFullScreenLoadingView() {
        fullScreenLoadingView?.removeFromSuperview()
        fullScreenLoadingView = nil
    }

    /// Status bar view configuration
    func setupStatusBarView() {
        /* Height is zero in all iPhones without notches,
        so we add fixed value 20 which is the height of the status bar
        in all iPhones without notches */
        let statusBarHeight = view.safeAreaInsets.top
        statusBarView = UIView(frame: CGRect(
            origin: .zero,
            size: CGSize(
                width: UIScreen.main.bounds.size.width,
                height: statusBarHeight)))
        statusBarView?.alpha = 0
        statusBarView?.backgroundColor = isMVA12Theme ? .black : statusBarBackgroundColor ?? .VFGLightGreyBackground
        guard let statusBarView = statusBarView else { return }
        view.addSubview(statusBarView)
    }

    /// Dashboard screen custom header view controller configuration
    /// - Parameters:
    ///    - headerCustomViewController: Header view controller displayed when pressing on custom header view
    func setupCustomHeader(_ headerCustomViewController: UIViewController?) {
        guard let customViewController = headerCustomViewController else { return }
        addChild(customViewController)
        customViewController.didMove(toParent: self)
        VFGEIOManager.shared.headerCustomViewController = customViewController
    }

    /// Dashboard screen custom header configuration
    func setupTopHeaderView() {
        guard let topViewModel =
            VFGManagerFramework.dashboardDelegate?.dashboardManager?.customHeaderModel else {
            topView.isHidden = true
            topViewHeightConstraint.constant = 0
            minTopViewHeight = 0
            return }
        if topView.subviews.count > 1 { return }
        topView.embed(view: topViewModel.headerViewContainer)
        topViewHeightConstraint.constant = topViewModel.headerContainerHeight
        minTopViewHeight = topViewModel.minHeaderContainerHeight
        guard isMVA12Theme else { return }
        headerMVA12View = topViewModel.headerViewContainer as? VFGMVA12HeaderView
        let dashboardBackgroundMinY = Constants.mva12DashboardBackgroundMinY
        collectionBackgroundTop.constant = topViewModel.headerContainerHeight + dashboardBackgroundMinY
        view.insertSubview(topView, belowSubview: collectionBackgroundView)
    }

    /// Dashboard screen floating view configuration
    func setupFloatingView() {
        guard let floatingViewModel =
            VFGManagerFramework.dashboardDelegate?.dashboardManager?.customHeaderModel else {
            floatingView.isHidden = true
            floatingViewHeight.constant = 0
            return }
        floatingView.embed(view: floatingViewModel.floatingViewContainer ?? UIView())
        floatingViewHeight.constant = floatingViewModel.floatingContainerHeight ?? 0
    }

    /// Dashboard screen accessibility identifier configuration
    func setupAccessibilityIdentifier() {
        collectionView.accessibilityIdentifier = "DashboardCollection"
    }

    /// Visible cells display mode notification
    public func notifyVisibleCells() {
        guard let visibleCells = collectionView?.visibleCells,
        let trayViewController = self.trayViewController() else { return }
        visibleCells.forEach { cell in
            guard let dashboardCell = cell as? VFDashboardCell else { return }
            if trayViewController.state == .collapsed {
                dashboardCell.viewComponentEntry?.willDisplay()
            } else {
                dashboardCell.viewComponentEntry?.didEndDisplay()
            }
        }
    }

    /// Track tray state change
    /// - Parameters:
    ///    - state: Current state for tray
    public func trayStateDidChangeDefaultAction(with state: TrayState) {
        guard let trayViewController = trayViewController() else { return }
        trayViewController.state = state
        trayState = state
        notifyVisibleCells()
    }
}
