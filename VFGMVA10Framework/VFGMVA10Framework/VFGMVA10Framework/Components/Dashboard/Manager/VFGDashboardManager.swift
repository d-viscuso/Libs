//
//  VFGDashboardManager.swift
//  VFGMVA10Group
//
//  Created by Mahmoud Amer on 8/7/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//
import Foundation
import VFGMVA10Foundation

/// Dashboard Manager.
open class VFGDashboardManager {
    /// Delegate of type *VFGDashboardNavigationProtocol* used to navigate to dashboard controller.
    public weak var delegate: VFGDashboardNavigationProtocol?
    /// Dashboard custom header.
    public var headerCustomViewController: UIViewController? {
        didSet {
            dashboardController.headerCustomViewController = headerCustomViewController
        }
    }
    /// Dashboard background color.
    public var dashboardBackgroundColor: UIColor? {
        didSet {
            dashboardController.collectionBackgroundView.backgroundColor = dashboardBackgroundColor
        }
    }
    /// Dashboard model.
    var dashboardModel: VFGDashboardItemsProtocol?
    /// MVA12 Header model
    var mva12HeaderViewModel: VFGMVA12HeaderViewModelProtocol?
    /// Dashboard controller.
    public let dashboardController = UIViewController.dashboardViewController
    /// EIO model.
    var eioModel: VFGEIOModelProtocol?
    /// Boolean determines if dashboard is finished or not tey, default is false. Turns to true when you call *dashboardItemsSetupFinished(error: Error?)*.
    open var dashboardFinished = false
    /// Boolean determines if tray is finished or not yet, default is false. Turns to true when you call *open(with controller: VFGTrayViewController?, error: Error?)*.
    open var trayFinished = false
    /// Boolean determines if EIO is finished or not yet, default is false. Turns to true when you call *EIOSetupFinished(error: Error?)*.
    open var EIOFinished = false
    /// Boolean determines if scrolling to discover section using threshold is enabled or not
    open var autoThresholdScrolling = true
    /// Dashboard navigation controller.
    var dashboardNavigation: UINavigationController?
    /// Tray view controller.
    public var trayController: VFGTrayViewController?
    /// Tray manager.
    var trayManager: VFGTrayManager?
    /// Boolean determines if the tray is presented or not.
    open var trayPresented = false
    /// Tobi message model.
    var tobiMessageModel: TobiMessageModel?
    /// Tobi animation.
    var tobiAnimation: VFGTOBIAnimation?
    /// Auto refresh interval.
    let autoRefreshIntervalInSeconds: Double
    /// Multiple accounts bannar interval.
    let multipleAccountsBannerInterval: Double
    /// Background image.
    public var backgroundImageName: String? {
        didSet {
            dashboardController.backgroundImageName = backgroundImageName
        }
    }
    /// Collection background round corner.
    public var collectionBackgroundRoundCorner: CGFloat? {
        didSet {
            dashboardController.collectionBackgroundRoundCorner = collectionBackgroundRoundCorner
        }
    }
    /// Status bar background color.
    public var statusBarBackgroundColor: UIColor? {
        didSet {
            dashboardController.statusBarBackgroundColor = statusBarBackgroundColor
        }
    }
    /// Collection background top extra constraint.
    public var collectionBackgroundExtraTop: CGFloat = 0
    /// Delegate to specify full screen loading
    public var fullScreenLoadingDelegate: VFDashboardFullScreenLoadingProviderProtocol? {
        didSet {
            dashboardController.fullScreenLoadingDelegate = fullScreenLoadingDelegate
        }
    }
    /// Custom header model.
    var customHeaderModel: VFGCustomHeaderModelProtocol?
    /// Dashboard side margins
    public var sideMargins: CGFloat = 8 {
        didSet {
            dashboardController.sideMargins = sideMargins
        }
    }
    /// user marginEdgeInsets property to set the convenient margin insets to dashboard collection container
    /// pre-condition: the right and left have the same value
    public var marginEdgeInsets: UIEdgeInsets? {
        didSet {
            dashboardController.marginEdgeInsets = marginEdgeInsets
        }
    }
    /// Analytics manager.
    public static var analyticsManager = VFGAnalyticsManager.self
    public private(set) var dashboardTheme: VFGDashboardThemeProtocol? = VFGMVA10DashboardTheme()
    /// *VFGDashboardManager* initializer
    /// - Parameters:
    ///    - dashboardModel: Dashboard model
    ///    - dashboardLifeCycleDelegate: Dashboard life cycle delegate methods
    ///    - pullToRefreshModel: optional *VFGPullToRefreshModel* to control pull to refresh UI, pull to refresh will be disabled if this model is nil
    ///    - trayModel: View controller of type *VFGTrayViewController*
    ///    - trayDelegate: Delegate that is responsible for Tray actions
    ///    - eioModel: EIO model
    ///    - autoRefreshIntervalInSeconds: Auto refresh interval
    ///    - multipleAccountsBannerInterval: Multiple accounts bannar interval
    public init(
        dashboardModel: VFGDashboardItemsProtocol?,
        dashboardLifeCycleDelegate: VFGDashboardLifeCycleProtocol? = nil,
        pullToRefreshModel: VFGPullToRefreshModel? = nil,
        trayModel: VFGTrayModelProtocol?,
        trayDelegate: VFGTrayDelegate? = nil,
        eioModel: VFGEIOModelProtocol?,
        autoRefreshIntervalInSeconds: Double = Constants.Dashboard.Interval.autoRefreshIntervalInSeconds,
        multipleAccountsBannerInterval: Double = Constants.Dashboard.Interval.multipleAccountsBannerInterval
    ) {
        self.dashboardModel = dashboardModel
        self.eioModel = eioModel
        self.autoRefreshIntervalInSeconds = autoRefreshIntervalInSeconds
        self.multipleAccountsBannerInterval = multipleAccountsBannerInterval
        trayManager = VFGTrayManager(trayModel: trayModel, delegate: trayDelegate)
        tobiAnimation = .angry
        tobiMessageModel = TobiMessageModel(
            message: "You used 5GB today. You may run out soon, I have some options...",
            tobiAnimation: tobiAnimation,
            tobiBadge: "!",
            tobiMessageTimer: 5.0)
        dashboardController.headerCustomViewController = headerCustomViewController
        dashboardController.lifeCycleDelegate = dashboardLifeCycleDelegate
        dashboardTheme?.dashboardManager = self
        dashboardController.pullToRefreshModel = pullToRefreshModel
    }
    /// *VFGDashboardManager* initializer
    /// - Parameters:
    ///    - dashboardModel: Dashboard model
    ///    - trayModel: View controller of type *VFGTrayViewController*
    ///    - trayDelegate: Delegate that is responsible for Tray actions
    ///    - customHeaderModel: Custom header model
    ///    - autoRefreshIntervalInSeconds: Auto refresh interval
    ///    - multipleAccountsBannerInterval: Multiple accounts bannar interval
    public init(
        dashboardModel: VFGDashboardItemsProtocol?,
        trayModel: VFGTrayModelProtocol?,
        pullToRefreshModel: VFGPullToRefreshModel? = nil,
        trayDelegate: VFGTrayDelegate? = nil,
        customHeaderModel: VFGCustomHeaderModelProtocol,
        autoRefreshIntervalInSeconds: Double = Constants.Dashboard.Interval.autoRefreshIntervalInSeconds,
        multipleAccountsBannerInterval: Double = Constants.Dashboard.Interval.multipleAccountsBannerInterval
    ) {
        self.dashboardModel = dashboardModel
        self.autoRefreshIntervalInSeconds = autoRefreshIntervalInSeconds
        self.multipleAccountsBannerInterval = multipleAccountsBannerInterval
        self.customHeaderModel = customHeaderModel
        trayManager = VFGTrayManager(trayModel: trayModel, delegate: trayDelegate)
        tobiAnimation = .angry
        tobiMessageModel = TobiMessageModel(
            message: "You used 5GB today. You may run out soon, I have some options...",
            tobiAnimation: tobiAnimation,
            tobiBadge: "!",
            tobiMessageTimer: 5.0)
        dashboardController.headerCustomViewController = headerCustomViewController
        self.eioModel = VFGDisableEIO()
        dashboardTheme?.dashboardManager = self
        dashboardController.pullToRefreshModel = pullToRefreshModel
    }

    /// *VFGDashboardManager* initializer
    /// - Parameters:
    ///    - dashboardModel: Dashboard model
    ///    - customHeaderModel: Custom header model
    ///    - tobiModel: Tobi model
    public init(
        dashboardModel: VFGDashboardItemsProtocol?,
        mva12HeaderViewModel: VFGMVA12HeaderViewModelProtocol,
        pullToRefreshModel: VFGPullToRefreshModel? = nil
    ) {
        self.dashboardModel = dashboardModel
        self.mva12HeaderViewModel = mva12HeaderViewModel
        customHeaderModel = mva12HeaderViewModel.getCustomHeaderModel(isLoading: true)
        autoRefreshIntervalInSeconds = Constants.Dashboard.Interval.autoRefreshIntervalInSeconds
        multipleAccountsBannerInterval = Constants.Dashboard.Interval.multipleAccountsBannerInterval
        trayManager = nil
        tobiAnimation = .angry
        tobiMessageModel = nil
        dashboardController.headerCustomViewController = nil
        dashboardController.pullToRefreshModel = pullToRefreshModel
        eioModel = VFGDisableEIO()
    }
    /// Custom header setup for handling shimmering
    /// - Parameters:
    ///     - isLoading: True if shimmering.
    public func setCustomHeaderModelForMVA12(isLoading: Bool) {
        customHeaderModel = mva12HeaderViewModel?.getCustomHeaderModel(isLoading: isLoading)
    }
    /// Build mva12 configuration
    public func buildMVA12() {
        dashboardTheme = VFGMVA12DashboardTheme()
        dashboardTheme?.dashboardManager = self
    }

    /// Action to show a full screen loading
    public func showFullScreenLoadingView(_ loadingView: UIView) {
        dashboardController.showFullScreenLoadingView(loadingView)
    }

    /// Action to hide full screen loading if present
    public func hideFullScreenLoadingView() {
        dashboardController.hideFullScreenLoadingView()
    }

    /// Action that is used to update dashboard models after it has been already initated.
    /// - Parameters:
    ///     - dashboardModel: Dashboard model.
    ///     - trayModel: Tray model.
    ///     - eioModel: EIO model.
    public func updateModels(
        dashboardModel: VFGDashboardItemsProtocol?,
        trayModel: VFGTrayModelProtocol?,
        eioModel: VFGEIOModelProtocol?
    ) {
        self.dashboardModel = dashboardModel
        self.eioModel = eioModel
        trayManager?.trayModel = trayModel
    }
    /// *VFGDashboardManager* configuration
    /// - Parameters:
    ///    - completion: A closure to hold data in case of request succeeded
    open func setup(completion: ((VFGTrayModelProtocol?) -> Void)?) {
        dashboardModel?.delegate = self
        eioModel?.EIOManagerDelegate = self
        eioModel?.dashboardManagerDelegate = self
        trayManager?.delegate = self
        trayManager?.setup(completion: completion)
        eioModel?.setup()
        dashboardModel?.setup()
    }
    /// Action to refresh the dashboard.
    /// - Parameters:
    ///     - completion: Completion that is called after updating the dashboard model.
    public func refetchDashboard(completion: (() -> Void)?) {
        (dashboardModel as? VFGDashboardModel)?.setup { [weak self] _ in
            self?.updateDashboardModels(error: nil)
            completion?()
        }
    }
    /// Action to remove a card form dashboard.
    /// - Parameters:
    ///     - index: The index of the card that you want to remove from the dashboard.
    public func removeCard(at index: IndexPath) {
        guard
            let collectionView = dashboardController.collectionView,
            collectionView.numberOfSections > index.section,
            collectionView.numberOfItems(inSection: index.section) > index.row else { return }

        collectionView.performBatchUpdates {
            dashboardController.dashboardDataSource?.removeItem(at: index) { isItemRemoved, isSectionRemoved in
                if isSectionRemoved {
                    collectionView.deleteSections([index.section])
                } else if isItemRemoved {
                    collectionView.deleteItems(at: [index])
                }
            }
        }
    }
    /// Reload *VFDashboardViewController* views layout
    public func reloadLayout() {
        dashboardController.collectionView?.collectionViewLayout.invalidateLayout()
        dashboardController.updateTilesBackgroundView()
        dashboardController.headerCustomViewController = headerCustomViewController
    }

    /// Reload *VFDashboardViewController* sections
    /// - Parameter indexSet: indexSet of sections to be refreshed
    public func reloadSections(at indexSet: IndexSet) {
        dashboardController.collectionView?.reloadSections(indexSet)
    }

    /// Reload *VFDashboardViewController* items
    /// - Parameter itemsIndices: *Array* of IndexPath of items to be refreshed
    public func reloadItems(at itemsIndices: [IndexPath]) {
        dashboardController.collectionView?.reloadItems(at: itemsIndices)
    }

    open func updateDashboardModels(error: Error?) {
        guard let sections = dashboardModel else { return }

        dashboardController.dashboardCardsModel = sections
        dashboardController.reloadDashboard()
        guard error != nil else { return }
        dashboardController.error = error
    }
    /// Determine whether to show tray or not
    /// - Parameters:
    ///    - error: Hold error type in case of showing tray failed
    func showTray(error: Error?) {
        trayController?.embedRootController(dashboardNavigation)
        guard let tobiMessageModel = tobiMessageModel else { return }
        trayController?.showTOBIMessage(tobiMessageModel: tobiMessageModel, from: "ProductsViewController")
        delegate?.open(with: trayController, error: error)
    }
    /// Shows dashboard if Tray model is nil
    /// - Parameters:
    ///    - error: Hold error type in case of showing tray failed
    func showDashboard(error: Error?) {
        delegate?.open(with: dashboardController, error: error)
    }
    /// Display another screen from dashboard screen
    /// - Parameters:
    ///    - viewController: View controller to display from dashboard screen
    ///    - animated: Determine whether to animate dasboard display or not
    ///    - completion: A closure to hold actions to be done after displaying view controller
    func dashboardPresent(
        _ viewController: UIViewController,
        animated: Bool = true,
        completion: (() -> Void)? = nil
    ) {
        dashboardController.present(viewController, animated: animated, completion: completion)
    }
}
