//
//  VFGTrayViewController.swift
//  mva10
//
//  Created by Ahmed Hamdy Gomaa on 12/11/18.
//  Copyright © 2018 vodafone. All rights reserved.
//
import UIKit
import VFGMVA10Foundation
import Lottie

public enum TrayState {
    case executingAction
    case pushingScreen
    case expanded
    case collapsed
}

internal enum TOBiState: String {
    case minimized
    case expanded
}

/**
Controller type that can be presented via the controller that conforms *VFGTrayNavigationProtocol*.
*/
public class VFGTrayViewController: VFGBaseViewController {
    @IBOutlet weak var contentBGImageView: VFGImageView!
    @IBOutlet weak var tobiView: UIView!
    @IBOutlet public weak var tobiLessImageView: VFGImageView?
    @IBOutlet weak var mainTrayView: UIView!
    @IBOutlet weak var mainTrayViewBG: UIView!
    @IBOutlet weak var mainTrayBottomNotch: UIView!
    @IBOutlet weak var leftItemsStackView: UIStackView!
    @IBOutlet weak var rightItemsStackView: UIStackView!
    @IBOutlet weak var rightItemsView: UIView!
    @IBOutlet weak var subTrayLabel: VFGLabel!
    @IBOutlet weak var sheetView: UIView!
    @IBOutlet weak var closeButtonOutlet: VFGButton!
    @IBOutlet weak var tobiBackButton: VFGButton!
    @IBOutlet weak var tobiHelpTitleLable: VFGLabel!
    @IBOutlet weak var pillView: UIView!
    @IBOutlet weak var backgroundOverlay: UIView!
    @IBOutlet weak var animatedView: UIView!
    @IBOutlet weak var animatedViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var centerAnimatedView: AnimationView!
    @IBOutlet weak var centerShadowImageView: VFGImageView!
    @IBOutlet weak var animatedTrayBarContainer: UIView!
    @IBOutlet weak var trayContentView: UIView!
    @IBOutlet weak var trayContentHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerViewDashboard: UIView!
    @IBOutlet weak var bottomNotchTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomNotchBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var tobiFaceBottomConstraint: NSLayoutConstraint!
    @IBOutlet public weak var tobiFace: VFGTOBIFace!
    @IBOutlet weak var tobiViewWidth: NSLayoutConstraint!
    @IBOutlet public weak var tobiContainerTopBlurringView: UIView!
    @IBOutlet public weak var tobiContainerView: UIView!
    @IBOutlet weak var tobiContainerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tobiBadgeView: VFGBadgeView!
    @IBOutlet weak var closeBtn: VFGButton!
    @IBOutlet weak var sheetViewBottomArea: UIView!
    @IBOutlet weak var sheetViewBottomConstraintTrayContent: NSLayoutConstraint!
    @IBOutlet weak var tobiShimmerView: VFGShimmerView!
    let trayViewHeight: CGFloat = 86.0
    var leftSwipe: UISwipeGestureRecognizer?
    var rightSwipe: UISwipeGestureRecognizer?
    var sheetViewInitialY: CGFloat = 0
    var expandViewInitialY: CGFloat = 0
    var trayAnimation = "tray_center_animation"
    var trayItemsView: [TrayItemView] = []
    let leftShimmerView = TrayItemShimmerdView()
    let rightShimmerView = TrayItemShimmerdView()
    weak var contentView: VFGSubtrayViewProtocol? {
        didSet {
            contentView?.enableAutoSwitchToVerticalSubTray = trayModel?.enableAutoSwitchToVerticalSubTray
        }
    }
    var rootViewController: UIViewController?
    weak var tobiHelpNavController: UINavigationController?
    var minimizeTobiTimer: Timer?
    var tobiMessageTimer: Double?
    var remoteNotificationManager = VFGRemoteNotificationManager.shared
    public var state: TrayState = .collapsed {
        willSet { VFGDebugLog("The tray is \(newValue)") }
    }
    var tobiMessagesModel: [String: TobiMessageModel] = [:]
    var tobiBadgeModel: [String: BadgeModel] = [:]
    var isTobiMessageViewed = false
    var isTrayLoaded = false
    public var navigationDelegate: VFGTrayNavigationControlProtocol?
    public var tobiLessImage: UIImage? {
        didSet {
            tobiLessImageView?.image = tobiLessImage
        }
    }
    public lazy var titleLabel: VFGLabel? = {
        let label = VFGLabel(frame: CGRect(
            x: self.tobiFace.frame.maxX + 8,
            y: 0,
            width: 0,
            height: Constants.trayViewWidth))
        label.textColor = .VFGPrimaryText
        label.font = .vodafoneRegular(18)
        label.numberOfLines = 2
        label.isAccessibilityElement = true
        label.accessibilityIdentifier = "TBhelperLabel"
        return label
    }()
    var trayModel: VFGTrayModelProtocol? {
        didSet {
            if isTrayLoaded {
                subTrayItemScale = trayModel?.subTrayItemScale
                showTobi(trayModel?.isTobiEnabled ?? false)
                drawLeftTrays()
                drawRightTrays()
                removeShimmerdView()
            }
        }
    }
    var selectedItem: VFGTrayItemProtocol?
    var actions: VFGActions? = VFGManagerFramework.trayDelegate?.trayActions()
    var trayAnimator: VFGTrayAnimator?
    var trayHeight: CGFloat { return mainTrayView.bounds.height + mainTrayBottomNotch.bounds.height }
    var customeSafeArea = UIEdgeInsets()
    var extraBottomInset: CGFloat = 0
    var tobiState: TOBiState?
    var centerAnimationCurrentProgress: CGFloat = 0
    public var customPresentedTypes: [UIViewController.Type] = []
    weak var trayDelegate: VFGTrayDelegate? {
        didSet {
            trayDelegate?.trayActionsDelegate = self
        }
    }
    var subTrayItemScale: SubTrayItemScale?

    override public func viewDidLoad() {
        super.viewDidLoad()
        if trayModel == nil {
            loadShimmerdView()
        }
        isTrayLoaded = true
        leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tobiFaceTapped))
        tapGestureRecognizer.numberOfTapsRequired = 1
        tobiView.addGestureRecognizer(tapGestureRecognizer)
        view.bringSubviewToFront(tobiView)
        sheetViewInitialY = sheetView.frame.height
        view.isMultipleTouchEnabled = true
        tobiView.isMultipleTouchEnabled = true
        setupTrayAnimation()
        animatedViewHeightConstraint.constant = 0
        animatedView.layoutIfNeeded()
        drawLeftTrays()
        drawRightTrays()
        refreshTrayItemBadges()
        if rootViewController != nil {
            embedRootController(rootViewController)
        }
        trayAnimator = VFGTrayAnimator()
        extraBottomInset = mainTrayView.frame.height
        customeSafeArea = UIEdgeInsets()
        customeSafeArea.bottom = extraBottomInset
        additionalSafeAreaInsets = customeSafeArea
        bottomNotchTopConstraint.constant = extraBottomInset
        tobiFaceBottomConstraint.constant = -Constants.trayBottomPadding
        showTobi(trayModel?.isTobiEnabled ?? false)
        tobiContainerTopBlurringView.alpha = 0
        customPresentedTypes.append(contentsOf: [
            VFGCVMOverlayViewController.self,
            VFQuickActionsViewController.self
        ])
        tobiBadgeView.badgeModel = BadgeModel()
        tobiLessImageView?.image = tobiLessImage ?? trayModel?.tobiLessImage
        // For closing keyboard if it's opened
        addKeyboardDismissHandler()
    }

    override public var preferredStatusBarStyle: UIStatusBarStyle {
        if let navController = self.rootViewController,
            let topViewController = UIApplication.topViewController(base: navController) {
            return topViewController.preferredStatusBarStyle
        }
        return .default
    }

    public func embedRootController(_ root: UIViewController?) {
        self.rootViewController = root
        if let rootViewController = rootViewController, containerViewDashboard != nil {
            addChild(rootViewController)
            if let tabBar = rootViewController as? UITabBarController {
                tabBar.tabBar.isHidden = true
                trayModel = rootViewController as? VFGTrayModelProtocol
            }
            rootViewController.view.frame = containerViewDashboard.bounds
            containerViewDashboard.addSubview(rootViewController.view)
            rootViewController.didMove(toParent: self)
        }
    }

    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        sheetView.roundUpperCorners(cornerRadius: 10)
    }

    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resetSelectedTrayItems()
        addTOBIShadow()
        setupTOBIBadge()
        backgroundOverlay.alpha = 0
        sheetView.alpha = 0
        sheetViewBottomArea.alpha = 0
        pillView.alpha = 0
        sheetView.transform = CGAffineTransform(translationX: 0, y: sheetViewInitialY)
        pillView.transform = CGAffineTransform(translationX: 0, y: sheetViewInitialY)
        centerAnimatedView.stop()
        animatedTrayBarContainer.isHidden = true
        animatedViewHeightConstraint.constant = 0
        animatedView.layoutIfNeeded()
        state = .collapsed
    }

    func resetCorners(view: UIView) {
        view.layer.cornerRadius = 0
    }

    /// Find if any trayItem has a badge element,
    func refreshTrayItemBadges() {
        if trayModel?.trayItems.first(
            where: { $0.itemModel.badge == Constants.messageCenterBadgeID }) != nil {
            /// call notificationManager to retrieve unread messages count and notify listeners
            remoteNotificationManager.retrieveUnreadMessagesCountAndNotifyListeners()
        }
    }

    @IBAction func dismissSubTrayAction(_ sender: Any) {
        collapseTray()
    }

    func notifyTrayState(_ state: TrayState? = nil) {
        let trayState = (state == nil ? self.state : state) ?? .collapsed
        if let navController = self.rootViewController,
            let topViewController = UIApplication.topViewController(base: navController),
            let trayDelegate = topViewController as? VFGTrayContainerProtocol {
            trayDelegate.trayStateDidChange(to: trayState)
        }
    }

    override public func present(
        _ viewControllerToPresent: UIViewController,
        animated flag: Bool,
        completion: (
        () -> Void)? = nil
    ) {
        collapseTray()
        if customPresentedTypes.contains(where: { $0 == type(of: viewControllerToPresent) }) {
            super.present(viewControllerToPresent, animated: flag, completion: completion)
            return
        }
        if let navController = rootViewController,
            let topViewController = UIApplication.topViewController(base: navController) {
            viewControllerToPresent.modalPresentationStyle = .currentContext
            topViewController.present(viewControllerToPresent, animated: flag, completion: completion)
            setNeedsStatusBarAppearanceUpdate()
        }
        notifyTrayState()
    }

    @IBAction func tobiCloseBtn(_ sender: VFGButton) {
        tobiCloseButtonTapped()
    }

    @IBAction func tobiBackBtnClicked(_ sender: VFGButton) {
        tobiHelpNavController?.popViewController(animated: true)
    }
}

extension VFGTrayViewController {
    public override var childForStatusBarHidden: UIViewController? {
        return self.children.last
    }
}
