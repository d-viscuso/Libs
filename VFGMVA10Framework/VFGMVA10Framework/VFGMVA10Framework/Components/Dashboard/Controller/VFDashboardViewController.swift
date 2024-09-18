//
//  VFDashBoardViewController.swift
//  mva10
//
//  Created by Tomasz Czyżak on 20/12/2018.
//  Copyright © 2018 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

/// Dashboard screen view controller
public class VFDashboardViewController: VFGBaseViewController {
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var backgroundImageView: VFGImageView!
    @IBOutlet weak var collectionBackgroundView: UIView!
    @IBOutlet weak var collectionBackgroundTop: NSLayoutConstraint!
    @IBOutlet weak var collectionTopConstraintMva10: NSLayoutConstraint!
    @IBOutlet weak var collectionTopConstraintMva12: NSLayoutConstraint!
    @IBOutlet weak var collectionView: VFGCollectionView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var topViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var floatingView: UIView!
    @IBOutlet weak var floatingViewHeight: NSLayoutConstraint!

    weak var headerMVA12View: VFGMVA12HeaderView?
    var mva12RefreshControl: DashboardRefreshControl?
    var minTopViewHeight: CGFloat = 0
    var autoRefreshIntervalInSeconds: Double = 0
    var multipleAccountsBannerInterval: Double = 0
    var mva12DashboardTopInsetExtraPadding: CGFloat = 20
    var userDefaults = UserDefaults.standard
    var refreshControl: UIRefreshControl?
    var collectionViewContentOffset: CGPoint?
    /// Dashboard screen view controller cards data model
    var dashboardCardsModel: VFGDashboardItemsProtocol? {
        didSet {
            dashboardDataSource = dashboardCardsModel
        }
    }
    /// Dashboard screen view controller cards data source
    var dashboardDataSource: VFGDashboardItemsProtocol? {
        didSet {
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
                guard let dashboardDataSource = self.dashboardDataSource else { return }
                let event = VFDashboardFullScreenLoadingTrigers.getFrom(contentState: dashboardDataSource.state)
                self.checkForFullScreenLoading(for: event)
            }
        }
    }
    /// This model is responsible for all data of the Tray & Sub-Tray elements
    var trayModel: VFGTrayModelProtocol?
    /// EIO model
    var eioModel: VFGEIOModelProtocol?
    /// Determine whether dashboard is displayed directly after splash screen or not
    var dashboardFromSplash = false
    var lastScrollOffset: CGFloat = 0
    var oldTopInset: CGFloat = 0
    let trayViewHeight: CGFloat = 86.0
    var discoverSnapThreshold: CGFloat?
    var refreshStatusModel: VFGRefreshStatusModel? {
        didSet {
            guard let refreshStatusModel = refreshStatusModel else { return }
            refreshManager?.refreshStatusModel = refreshStatusModel
        }
    }
    /// Dashboard refresh manager
    var refreshManager: VFGRefreshManager? {
        dashboardDataSource?.refreshManager
    }
    /// Dashboard status bar view
    var statusBarView: UIView?
    /// EIO current status
    var oldStatus: EIOStatus?
    // Dashboard+AutoRefreshable Variables
    var timer: Timer?
    var nextRefreshDate: Date?
    // var used for Unit Testing
    /// Dashboard tray current status
    public var trayState = TrayState.collapsed
    /// Error type in case dashboard didn't load successfully
    var error: Error? {
        didSet {
            guard error != nil && errorCardView == nil else { return }
            showDashboardError()
        }
    }
    /// Card view to display error in case dashboard didn't load successfully
    var errorCardView: VFGErrorView?
    /// Dashboard screen shimmer model
    var shimmerModel: VFGDashboardShimmerModel? = VFGDashboardShimmerModel()
    /// Dashboard screen shimmer model for MVA12
    var shimmerModelMVA12: VFGMVA12DashboardShimmerModel? = VFGMVA12DashboardShimmerModel()
    /// Dashboard screen view controller custom header
    var headerCustomViewController: UIViewController? {
        didSet {
            if oldValue?.parent != nil { // Remove old custom view controller if exist
                oldValue?.willMove(toParent: nil)
                oldValue?.removeFromParent()
            }
            setupCustomHeader(headerCustomViewController)
        }
    }
    /// Life cycle delegate methods
    public weak var lifeCycleDelegate: VFGDashboardLifeCycleProtocol?
    var pullToRefreshModel: VFGPullToRefreshModel?
    var isFunFactLoading = false
    var latestBouncedHeight: CGFloat = 0
    var sideMargins: CGFloat = 8 {
        didSet {
            collectionView?.contentInset.left = sideMargins
            collectionView?.contentInset.right = sideMargins
            Constants.dashboardCollectionPadding = sideMargins
        }
    }
    var marginEdgeInsets: UIEdgeInsets? {
        didSet {
            guard let marginEdgeInsets = marginEdgeInsets else { return }
            collectionView?.contentInset = marginEdgeInsets
            Constants.dashboardCollectionPadding = marginEdgeInsets.left
        }
    }
    var backgroundImageName: String? {
        didSet {
            updateBackgroundImage()
        }
    }
    var collectionBackgroundRoundCorner: CGFloat? {
        didSet {
            updateCollectionBackgroundRoundCorner()
        }
    }
    var statusBarBackgroundColor: UIColor? {
        didSet {
            statusBarView?.backgroundColor = statusBarBackgroundColor ?? .VFGLightGreyBackground
        }
    }
    weak var fullScreenLoadingDelegate: VFDashboardFullScreenLoadingProviderProtocol?
    var fullScreenLoadingView: UIView?
    var isMVA12Theme: Bool {
        let dashboardManager = VFGManagerFramework.dashboardDelegate?.dashboardManager
        return dashboardManager?.dashboardTheme is VFGMVA12DashboardTheme
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        collectionBackgroundView.backgroundColor = .VFGDarkGreyBackground
        backgroundView.backgroundColor = .VFGDarkGreyBackground
        updateCollectionBackgroundRoundCorner()
        VFGEIOManager.shared = VFGEIOManager(
            dashboardVC: self,
            collectionView: collectionView,
            backgroundView: backgroundView,
            eioModel: eioModel)
        collectionView.keyboardDismissMode = .onDrag
        collectionView.isScrollEnabled = false
        setupAccessibilityIdentifier()
        setupTopHeaderView()
        setupFloatingView()
        setupCollectionView()
        setupStatusBarView()
        setupShimmerModel()
        updateTilesBackgroundView()
        updateEIOKStatus()
        view.backgroundColor = .clear
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(willResignActive),
            name: UIApplication.willResignActiveNotification,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(willEnterForeground),
            name: UIApplication.willEnterForegroundNotification,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didBecomeActive),
            name: UIApplication.didBecomeActiveNotification,
            object: nil)
        if !userDefaults.isMultipleAccountBannerShown, !VFGUser.shared.accounts.isEmpty {
            showMultipleAccountsBanner()
        }
        setupPullToRefresh(isMva12: isMVA12Theme)
        updateBackgroundImage()
        lifeCycleDelegate?.dashboardViewDidLoad()
        checkForFullScreenLoading(for: .viewDidLoad)
    }

    public override var preferredStatusBarStyle: UIStatusBarStyle {
        guard let statusBarView = statusBarView else { return .default }
        let preferredStyle: UIStatusBarStyle = statusBarView.alpha == 0 ? .lightContent : .default
        return eioModel?.eioStatus == .success ? .default : preferredStyle
    }

    /// Actions excuted when app resign active state
    @objc func willResignActive() {
        endRefreshControlRefreshing()
        descheduleAutoRefresh()
        refreshManager?.didMoveToForeground()
    }

    /// Actions excuted when app enter foreground state
    @objc func willEnterForeground() {
        beginRefreshControlRefreshing()
        updateEIOKStatus()
        scheduleAutoRefresh()
        notifyVisibleCells()
        refreshManager?.didMoveToForeground()
    }

    /// Actions excuted when app become active
    @objc func didBecomeActive() {
        reloadMVA12RefreshControl()
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadRefreshControl()
        navigationController?.isNavigationBarHidden = true
        VFGEIOManager.shared.dashboardWillAppear()
        scheduleAutoRefresh()
        playVideo()
        lifeCycleDelegate?.dashboardViewWillAppear(animated)
        checkForFullScreenLoading(for: .viewWillAppear)
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        notifyViewWillDisappear()
        descheduleAutoRefresh()
        pauseVideo()
        lifeCycleDelegate?.dashboardViewWillDisappear(animated)
    }

    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        lifeCycleDelegate?.dashboardViewDidDisappear(animated)
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        notifyVisibleCells()
        view.layoutSubviews()
        VFGEIOManager.shared.dashboardDidAppear()
        setNeedsStatusBarAppearanceUpdate()
        lifeCycleDelegate?.dashboardViewDidAppear(animated)
        checkForFullScreenLoading(for: .viewDidAppear)
    }

    public override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        guard var frame = statusBarView?.frame else { return }
        frame.size.height = view.safeAreaInsets.top
        statusBarView?.frame = frame
    }

    private func reloadMVA12RefreshControl() {
        guard mva12RefreshControl != nil else {return}
        reloadMVA12RefreshControlWithUpdatingStatus()
        reloadMVA12RefreshControlWithUpdatedStatus()
    }

    private func reloadMVA12RefreshControlWithUpdatingStatus() {
        if mva12RefreshControlStatus() == .updating {
            mva12RefreshControl?.reloadAnimation()
        }
    }

    private func reloadMVA12RefreshControlWithUpdatedStatus() {
        if mva12RefreshControlStatus() == .updated {
            mva12RefreshControl?.isRefreshingFromNavigation = true
            endMVA12Refreshing()
        }
    }

    func endMVA12Refreshing() {
        mva12RefreshControl?.endRefresh { [weak self] in
            guard let self else {return}
            self.reloadDashboard()
            self.mva12RefreshControl?.isRefreshingFromNavigation = false
        }
    }

    private func mva12RefreshControlStatus() -> PullRefreshStatus {
        mva12RefreshControl?.status ?? .pull
    }

    private func reloadRefreshControl() {
        reloadMVA12RefreshControl()
        endRefreshControlRefreshing()
        beginRefreshControlRefreshing()
    }

    private func endRefreshControlRefreshing() {
        if isRefreshControlRefreshing() {
            collectionViewContentOffset = collectionView.contentOffset
            refreshControl?.endRefreshing()
        }
    }

    private func isRefreshControlRefreshing() -> Bool {
        refreshControl?.isRefreshing ?? false
    }

    private func beginRefreshControlRefreshing() {
        guard let collectionViewContentOffset = collectionViewContentOffset else {return}
            collectionView.contentOffset = collectionViewContentOffset
            refreshControl?.beginRefreshing()
    }

    private func notifyViewWillDisappear() {
        NotificationCenter.default.post(name: .DashboardWillDisappear, object: nil)
    }
}

extension VFDashboardViewController {
    /// Dashboard screen accessibility identifier configuration
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let topInset = view.safeAreaInsets.top
        let bottomInset = abs(view.safeAreaInsets.bottom)
        guard oldTopInset != topInset else { return }
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.contentInset = UIEdgeInsets(
            top: VFGManagerFramework
                .dashboardDelegate?
                .dashboardManager?
                .customHeaderModel != nil ? 8 : marginEdgeInsets?.top ?? topInset,
            left: marginEdgeInsets?.left ?? sideMargins,
            bottom: marginEdgeInsets?.bottom ?? bottomInset,
            right: marginEdgeInsets?.right ?? sideMargins)
        oldTopInset = topInset
        updateBackgroundGradientLayerFrame()
    }
}
