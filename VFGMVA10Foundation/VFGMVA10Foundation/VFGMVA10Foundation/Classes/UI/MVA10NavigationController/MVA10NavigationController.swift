//
//  MVA10NavigationController.swift
//  VFGMVA10Foundation
//
//  Created by Mohamed Abd ElNasser on 12/10/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import UIKit
/// Custom *UINavigationController* for MVA10
open class MVA10NavigationController: UINavigationController {
    // MARK: - private properties
    private(set) lazy var navigationView: MVA10NavigationView = {
        MVA10NavigationView.loadXib(bundle: Bundle.foundation) ?? MVA10NavigationView()
    }()
    private(set) var titles: [UIViewController: String] = [:]
    private(set) var accessibilityIDs: [UIViewController: String] = [:]
    private let statusBarHeight = UIApplication.shared.statusBarFrame.height
    private var extraSafeArea: CGFloat {
        16.0 + navigationBar.frame.height
    }
    private var topVC: UIViewController {
        topViewController ?? UIViewController()
    }

    // MARK: - public properties
    /// Delegation protocol for *VFGNavigationController* actions
    public weak var navigationDelegate: VFGNavigationControllerProtocol?
    /// Determine if *navigationView* is transparent or not and whether to add extra space or not
    public var isTranslucent = false {
        didSet {
            isTransparentBackground = isTranslucent
            additionalSafeAreaInsets.top = isTranslucent ? 0 : extraSafeArea
        }
    }
    /// Determine transparency status for the background of *navigationView*
    public var isTransparentBackground = false {
        didSet {
            navigationView.isTransparentBackground = isTransparentBackground
        }
    }
    /// Determine if the *bottomDivider* of the *navigationView* is shown or not
    public var hasDivider = false {
        didSet {
            navigationView.hasDivider = hasDivider
        }
    }
    /// Determine *navigationView* visibility and calculate safe area
    public var isNavigationViewHidden = false {
        willSet {
            navigationView.isHidden = newValue
            if newValue == true {
                resetSafeArea()
            } else if isNavigationViewHidden == true && newValue == false {
                increaseSafeArea()
            }
        }
    }
    /// Determine if *closeButton* in *navigationView* is hidden or not
    public var isCloseButtonHidden = false {
        didSet {
            navigationView.closeButton.isHidden = isCloseButtonHidden
        }
    }
    /// Determine if *backButton* in *navigationView* is hidden or not
    public var isBackButtonHidden = false {
        didSet {
            navigationView.backButton.isHidden = isBackButtonHidden
        }
    }
    /// configure *bottomDivider* background color  * in *navigationView*
    public var bottomDividerColor = UIColor.VFGGreyDividerOne {
        didSet {
            navigationView.bottomDivider.backgroundColor = bottomDividerColor
        }
    }
    // MARK: - lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()

        setNavigationViewFrame()
        setNavigationViewTitle()
        addNavigationViewButtons()
        increaseSafeArea()

        view.addSubview(navigationView)
        navigationBar.isHidden = true
    }

    // MARK: - private methods
    private func setNavigationViewFrame() {
        var height = extraSafeArea
        if UIScreen.screenHasNotch {
            height += (UIApplication.shared.keyWindow?.safeAreaInsets.top ?? statusBarHeight)
        } else {
            height += statusBarHeight
        }
        navigationView.frame = CGRect(
            x: navigationBar.frame.origin.x,
            y: navigationBar.frame.origin.y,
            width: navigationBar.frame.width,
            height: height)
    }

    private func addNavigationViewButtons() {
        navigationView.backButton.addTarget(
            self,
            action: #selector(backTapped),
            for: .touchUpInside)
        navigationView.closeButton.addTarget(
            self,
            action: #selector(closeTapped),
            for: .touchUpInside)
        navigationView.backButton.isHidden = viewControllers.count < 2
    }

    private func setNavigationViewTitle() {
        navigationView.setTitle(
            title: titles[topVC] ?? "",
            accessibilityIdentifier: accessibilityIDs[topVC] ?? ""
        )
    }

    private func increaseSafeArea() {
        additionalSafeAreaInsets.top += extraSafeArea
    }

    private func resetSafeArea() {
        additionalSafeAreaInsets.top -= extraSafeArea
    }

    private func adjustBackButtonVisibility() {
        navigationView.backButton.isHidden = viewControllers.count < 2
    }

    private func executePopAction(_ poppedViewControllers: [UIViewController]) -> [UIViewController] {
        DispatchQueue.main.async { [weak self] in
            self?.adjustBackButtonVisibility()
        }
        let oldTitle = titles[topVC]
        let oldID = accessibilityIDs[topVC]
        poppedViewControllers.forEach {
            titles.removeValue(forKey: $0)
            accessibilityIDs.removeValue(forKey: $0)
            navigationView.setTitle(
                title: oldTitle ?? "",
                accessibilityIdentifier: oldID ?? "")
        }

        return poppedViewControllers
    }

    // MARK: - public methods
    /// Set the title text for *titleLabel* in *navigationView* attached to the view controller
    /// - Parameters:
    ///    - title: *titleLabel* text value
    ///    - accessibilityID: *titleLabel*  accessibility identifier
    ///    - viewController: View controller to attach *navigationView* to it
    public func setTitle(
        title: String,
        accessibilityID: String = "",
        for viewController: UIViewController
    ) {
        titles[viewController] = title
        accessibilityIDs[viewController] = accessibilityID
        navigationView.setTitle(
            title: title,
            accessibilityIdentifier: accessibilityID)
    }
    /// Set colors for *MVA10NavigationView* and its components
    /// - Parameters:
    ///    - backgroundColor: Set background color for *navigationView*
    ///    - titleColor: Set title color for *titleLabel* in *navigationView*
    ///    - closeButtonColor: Set tint color for *closeButton* in *navigationView*
    ///    - backButtonColor: Set tint color for *backButton* in *navigationView*
    public func setupCustomColors(
        backgroundColor: UIColor = .lightBackground ?? .VFGWhiteBackground,
        titleColor: UIColor = .primaryTextColor ?? .VFGGreyTint,
        closeButtonColor: UIColor = .linksDark ?? .VFGGreyTint,
        backButtonColor: UIColor = .linksDark ?? .VFGGreyTint
    ) {
        navigationView.setupColors(
            backgroundColor: backgroundColor,
            titleColor: titleColor,
            closeButtonColor: closeButtonColor,
            backButtonColor: backButtonColor)
    }
    /// set accessibility identifiers for back and close buttons in *navigationView*
    /// - Parameters:
    ///    - closeButtonID: Set accessibility identifier for *closeButton* in *navigationView*
    ///    - backButtonID: Set accessibility identifier for *backButton* in *navigationView*
    public func setAccessibilityIDs(closeButtonID: String = "", backButtonID: String = "") {
        navigationView.setAccessibilityIDs(closeButtonID: closeButtonID, backButtonID: backButtonID)
    }
    /// Set accessibility label for title label & close and back buttons in *navigationView*
    /// - Parameters:
    ///    - closeButtonLabel: Set accessibility label for *closeButton* in *navigationView*
    ///    - backButtonLabel: Set accessibility label for *backButton* in *navigationView*
    ///    - titleAccessibilityLabel: Set accessibility label for *titleLabel* in *navigationView*
    public func setAccessibilityLabels(
        closeButtonLabel: String? = nil,
        backButtonLabel: String? = nil,
        titleAccessibilityLabel: String? = nil
    ) {
        guard !navigationView.isHidden else { return }
        navigationView.setAccessibilityLabels(
            closeButtonLabel: closeButtonLabel,
            backButtonLabel: backButtonLabel,
            titleAccessibilityLabel: titleAccessibilityLabel)
        accessibilityCustomActions = []
        if !navigationView.backButton.isHidden {
            accessibilityCustomActions?.append(backButtonVoiceoverAction())
        }
        if !navigationView.closeButton.isHidden {
            accessibilityCustomActions?.append(closeButtonVoiceoverAction())
        }
    }
    /// Overridden to set full screen presentation & handle *navigationView* title and push view controller
    /// - Parameters:
    ///    - viewController: Given view controller to be pushed onto the stack
    ///    - animated: Determine if pushing view controller will be done with animations or not
    public override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        modalPresentationStyle = .fullScreen
        super.pushViewController(viewController, animated: animated)
        adjustBackButtonVisibility()
        let title = titles[topVC]
        let accessibilityID = accessibilityIDs[topVC]
        navigationView.setTitle(
            title: title ?? "",
            accessibilityIdentifier: accessibilityID ?? "")
    }
    /// Overridden to clear all view controllers in stack & set new view controller in stack and
    /// pops the top view controller from the navigation stack and updates the display
    /// - Parameters:
    ///    - animated: Determine if popping view controller will be done with animations or not
    /// - Returns: The view controller that was popped from the stack
    public override func popViewController(animated: Bool) -> UIViewController? {
        guard let poppedViewController = super.popViewController(animated: animated) else {
            return nil
        }
        return executePopAction([poppedViewController]).first
    }
    /// Overridden to clear all view controllers in stack & set new view controller in stack and
    /// pops all the view controllers on the stack except the root view controller and updates the display
    /// - Parameters:
    ///    - animated: Determine if popping view controller will be done with animations or not
    /// - Returns: An array of view controllers representing the items that were popped from the stack
    public override func popToRootViewController(animated: Bool) -> [UIViewController]? {
        guard let poppedViewControllers = super.popToRootViewController(animated: animated) else {
            return nil
        }
        return executePopAction(poppedViewControllers)
    }
    /// Overridden to clear all view controllers in stack & set new view controller in stack and
    /// pops view controllers until the specified view controller is at the top of the navigation stack
    /// - Parameters:
    ///    - viewController: Given view controller to be at the top of the stack
    ///    - animated: Determine if popping to view controller will be done with animations or not
    /// - Returns: An array of view controllers representing the items that were popped from the stack
    public override func popToViewController(
        _ viewController: UIViewController,
        animated: Bool
    ) -> [UIViewController]? {
        guard let poppedViewControllers = super.popToViewController(
            viewController,
            animated: animated) else {
            return nil
        }

        return executePopAction(poppedViewControllers)
    }
    /// Handle close button pressing action & dismiss current navigation controller & clear all title and accessibilityIDs
    @objc public func closeTapped() {
        if let delegate = navigationDelegate {
            delegate.closeButtonDidPress()
            return
        }
        guard let navigationController = navigationController else {
            dismiss(animated: true) {  [weak self] in
                guard let self = self else {
                    return
                }

                self.viewControllers.forEach { $0.dismiss(animated: false, completion: nil) }
                self.titles = [:]
                self.accessibilityIDs = [:]
            }
            return
        }
        navigationController.dismiss(animated: true) { [weak self] in
            guard let self = self else {
                return
            }
            self.viewControllers.forEach { $0.dismiss(animated: false, completion: nil) }
            self.titles = [:]
            self.accessibilityIDs = [:]
        }
    }
    func closeButtonVoiceoverAction() -> UIAccessibilityCustomAction {
        UIAccessibilityCustomAction(
            name: "Close",
            target: self,
            selector: #selector(closeTapped))
    }
    /// Handle back button pressing action and pop view controller with animations
    @objc public func backTapped() {
        if let delegate = navigationDelegate {
            delegate.backButtonDidPress()
            return
        }
        _ = popViewController(animated: true)
    }
    func backButtonVoiceoverAction() -> UIAccessibilityCustomAction {
        UIAccessibilityCustomAction(
            name: "Back",
            target: self,
            selector: #selector(backTapped))
    }
}
