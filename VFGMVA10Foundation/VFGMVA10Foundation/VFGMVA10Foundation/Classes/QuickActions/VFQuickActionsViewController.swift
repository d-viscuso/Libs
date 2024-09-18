//
//  VFQuickActionsViewController.swift
//  VFGMVA10Foundation
//
//  Created by Sandra Morcos on 7/25/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import UIKit

/// A view controller that allows the user to show quick action and interact with it in a various ways
/// You can customize header, content view and even style through providing your customizable model
public class VFQuickActionsViewController: UIViewController {
    @IBOutlet weak var quickActionsView: UIView!
    @IBOutlet weak var pillView: UIView!
    @IBOutlet weak var titleLabel: VFGLabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var originalProportionalHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var closeButton: VFGButton!
    @IBOutlet weak var backButton: VFGButton!
    @IBOutlet weak var headerButton: VFGButton!
    @IBOutlet weak var keyboardHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var customHeaderStackView: UIStackView!
    @IBOutlet weak var customHeaderViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerButtonHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerButtonWidthConstraint: NSLayoutConstraint!

    var proportionalHeight: NSLayoutConstraint?
    var model: VFQuickActionsModel?
    public weak var eventsDelegate: VFQuickActionsEventsProtocol?
    let maximumHeightRatio: CGFloat = 0.95
    let defaultHeaderViewHeight: CGFloat = 32
    let maxCustomHeaderViewHeight: CGFloat = 100
    let defaultUpperCornersRadius: CGFloat = 6
    var isPresented = false
    var statusBar: UIView?
    var contentView: UIView?

    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupStatusBar()
        model?.quickActionsProtocol(delegate: self)
        observeKeyboard()
    }

    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard !isPresented else { return }
        UIView.animate(withDuration: 0.1) {
            self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
            let transform = CGAffineTransform(translationX: 0, y: 0)
            self.pillView.transform = transform
            self.quickActionsView.transform = transform
            self.isPresented = true
        }
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard !isPresented else { return }

        view.backgroundColor = .clear

        let transform = CGAffineTransform(translationX: 0, y: quickActionsView.frame.height)
        pillView.transform = transform
        quickActionsView.transform = transform
    }

    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if #available(iOS 13.0, *) {
            if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
                if model?.quickActionsStyle == .red {
                    quickActionsView.layer.sublayers?.first?.removeFromSuperlayer()
                    quickActionsView.setGradientBackgroundColor(colors: UIColor.VFGRedGradientDynamic)
                }
            }
        }
    }

    func setupStatusBar() {
        if #available(iOS 13.0, *) {
            statusBar = UIView(frame: UIApplication.shared.windows.first(where:) {
                $0.isKeyWindow
            }?.windowScene?.statusBarManager?.statusBarFrame ?? .zero)
            UIApplication.shared.windows.first(where:) { $0.isKeyWindow }?.addSubview(statusBar ?? UIView())
        } else {
            statusBar = UIApplication.shared.value(forKeyPath: "statusBar") as? UIView
            statusBar?.backgroundColor = .clear
        }
    }

    @objc func viewControllerDragged(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        updateDragging(translation.y, state: gesture.state)
    }

    func updateDragging(_ yPosition: CGFloat, state: UIGestureRecognizer.State) {
        if yPosition > 0 {
            let transform = CGAffineTransform(translationX: 0, y: yPosition)
            pillView.transform = transform
            quickActionsView.transform = transform
        }
        guard state == .ended else { return }
        if yPosition >= quickActionsView.frame.height / 2 {
            model?.closeQuickAction()
        } else {
            UIView.animate(withDuration: 0.1) {
                let transform = CGAffineTransform(translationX: 0, y: 0)
                self.pillView.transform = transform
                self.quickActionsView.transform = transform
            }
        }
    }

    func updateHeightFor(_ contentView: UIView) {
        let actualHeight = (contentView.frame.height
            + self.quickActionsView.frame.height
            - self.scrollView.frame.height)
        var multiplier = actualHeight / self.view.frame.height

        multiplier = min(multiplier, model?.maximumHeightRatio ?? maximumHeightRatio)
        if self.originalProportionalHeightConstraint != nil {
            self.originalProportionalHeightConstraint.isActive = false
        }
        self.proportionalHeight = self.quickActionsView.heightAnchor.constraint(
            equalTo: self.view.heightAnchor,
            multiplier: multiplier,
            constant: 0
        )
        self.proportionalHeight?.isActive = true
    }

    @IBAction func dismissViewController(_ sender: VFGButton) {
        guard
            sender == closeButton ||
            model?.isUserInteractionEnabled ?? false else { return }
        model?.closeQuickAction()
        guard let dismissEvent = eventsDelegate?.getActionEvent(for: .dismiss) else { return }
        VFQuickActionsEventsManager.trackAction(
            journeyType: dismissEvent.journeyType,
            event: dismissEvent.event,
            eventLabel: dismissEvent.eventLabel)
    }

    @IBAction func backButtonTapped(_ sender: Any) {
        model?.backQuickAction()
        guard let backEvent = eventsDelegate?.getActionEvent(for: .back) else { return }
        VFQuickActionsEventsManager.trackAction(
            journeyType: backEvent.journeyType,
            event: backEvent.event,
            eventLabel: backEvent.eventLabel)
    }

    @objc func animatedDismiss(completion: (() -> Void)?) {
        UIView.animate(
            withDuration: 0.2,
            animations: {
                self.view.backgroundColor = .clear
                let transform = CGAffineTransform(translationX: 0, y: self.quickActionsView.frame.height)
                self.pillView.transform = transform
                self.quickActionsView.transform = transform
            }, completion: { [weak self] _ in
                guard let self = self else { return }
                self.resetsHeaderViewHeight()
                self.dismiss(animated: false) {
                    completion?()
                }
            })
    }
    func closeButtonVoiceOverAction() -> UIAccessibilityCustomAction {
        let actionName = "Close"
        return UIAccessibilityCustomAction(name: actionName, target: self, selector: #selector(animatedDismiss))
    }

    func backButtonVoiceOverAction() -> UIAccessibilityCustomAction {
        let actionName = "Back"
        return UIAccessibilityCustomAction(name: actionName, target: self, selector: #selector(backButtonTapped))
    }

    @IBAction func headerButtonTapped(_ sender: Any) {
        model?.headerButtonAction()
        guard let headerEvent = eventsDelegate?.getActionEvent(for: .header) else { return }
        VFQuickActionsEventsManager.trackAction(
            journeyType: headerEvent.journeyType,
            event: headerEvent.event,
            eventLabel: headerEvent.eventLabel)
    }

    static func viewController(with model: VFQuickActionsModel) -> VFQuickActionsViewController {
        let storyboard = UIStoryboard(name: "quickActions", bundle: Bundle.foundation)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "VFQuickActionsViewController")
            as? VFQuickActionsViewController else {
                return VFQuickActionsViewController()
        }
        viewController.model = model
        return viewController
    }

    /// To present QuickActionsViewController with a given model
    public static func presentQuickActionsViewController(
        with model: VFQuickActionsModel,
        presentationStyle: UIModalPresentationStyle? = nil,
        navigationController: UIViewController? = UIApplication.topViewController()
    ) {
        let viewController = VFQuickActionsViewController.viewController(with: model)
        if let modalPresentationStyle = presentationStyle {
            viewController.modalPresentationStyle = modalPresentationStyle
        }
        navigationController?.present(
            viewController,
            animated: false,
            completion: nil)
    }

    @objc func keyboardDidAppear (notification: NSNotification) {
        let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        keyboardHeightConstraint.constant = (model?.shouldRaiseForKeyboard ?? false) ? (keyboardFrame?.height ?? 0) : 0
    }

    @objc func keyboardDidDisappear() {
        keyboardHeightConstraint.constant = 0
    }

    func setAccessibilityForVoiceOver() {
        accessibilityElements = [quickActionsView as Any]
        titleLabel.accessibilityLabel = model?.quickActionsTitleAccessibilityLabel
        titleLabel.accessibilityTraits = .header
        let backVoiceOverAction = backButtonVoiceOverAction()
        let closeVoiceOverAction = closeButtonVoiceOverAction()
        if !(model?.isBackButtonHidden ?? true) {
            backButton.accessibilityLabel = model?.backButtonAccessibilityLabel
            accessibilityCustomActions?.append(backVoiceOverAction)
        }
        if !(model?.isCloseButtonHidden ?? true) {
            closeButton.accessibilityLabel = model?.closeButtonAccessibilityLabel
            accessibilityCustomActions?.append(closeVoiceOverAction)
        }
        UIAccessibility.post(notification: .screenChanged, argument: scrollView)
    }
}

// Mark :- private methods
extension VFQuickActionsViewController {
    private func setupUI() {
        titleLabel.text = model?.quickActionsTitle
        titleLabel.font = model?.titleFont
        titleLabel.numberOfLines = 0
        headerButton.titleLabel?.font = model?.titleFont
        switch model?.quickActionsStyle {
        case .white:
            quickActionsView.backgroundColor = .VFGWhiteBackground
            titleLabel.textColor = .VFGPrimaryText
            closeButton.tintColor = .VFGGreyTint
        case let .custom(backGroundColor: backgroundColor, textColor: textColor):
            quickActionsView.backgroundColor = backgroundColor
            titleLabel.textColor = textColor
            closeButton.tintColor = textColor
        default:
            quickActionsView.setGradientBackgroundColor(colors: UIColor.VFGRedGradientDynamic)
            titleLabel.textColor = .white
            closeButton.tintColor = .white
        }
        quickActionsView.roundUpperCorners(cornerRadius: model?.upperCornersRadius ?? defaultUpperCornersRadius)
        if model?.isUserInteractionEnabled ?? false {
            pillView.isHidden = false
            let panGestureRecognizer = UIPanGestureRecognizer(
                target: self,
                action: #selector(viewControllerDragged(_:)))
            view.addGestureRecognizer(panGestureRecognizer)
        }
        scrollView.isScrollEnabled = model?.isScrollEnabled ?? true
        addCustomHeaderViewIfAvailable()
        setupCustomTitleAttributeIfAvailable()
        setupContentView()
        setupAccessibilityIDs()
        setAccessibilityForVoiceOver()
    }

    private func setupCustomTitleAttributeIfAvailable() {
        guard let model = model,
        let quickActionAttributedTitle = model.quickActionAttributedTitle else {
            return
        }
        titleLabel.attributedText = quickActionAttributedTitle
    }

    private func setupContentView() {
        guard let model = model else {
            return
        }

        backButton.isHidden = model.isBackButtonHidden
        backButton.imageName = "icArrowLeft"

        headerButton.isHidden = model.isHeaderButtonHidden
        headerButton.setTitle(model.headerButtonTitle, for: .normal)
        let titleFont = model.titleFont
        let headerButtonTitle = headerButton.title(for: .normal)
        let headerButtonHeight = headerButtonHeightConstraint.constant
        let headerButtonWidth = headerButtonTitle?.width(withConstrainedHeight: headerButtonHeight, font: titleFont)
        headerButtonWidthConstraint.constant = headerButtonWidth ?? 0
        if let closeImage = model.closeButtonImage {
            closeButton.setImage(closeImage, for: .normal)
        }
        closeButton.isHidden = model.isCloseButtonHidden
        closeButton.alpha = model.isCloseButtonHidden ? 0 : 1

        let contentView = model.quickActionsContentView
        scrollView.embed(view: contentView)
        contentView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor).isActive = true
        contentView.layoutIfNeeded()
        updateHeightFor(contentView)
        self.contentView = contentView
        UIView.animate(withDuration: 0.2) { [weak self] in
            guard let self = self else { return }
            self.view.layoutSubviews()
            switch self.model?.quickActionsStyle {
            case .white:
                self.quickActionsView.backgroundColor = .VFGWhiteBackground
            case .custom(backGroundColor: let backgroundColor, textColor: _):
                self.quickActionsView.backgroundColor = backgroundColor
            default:
                self.quickActionsView.backgroundColor = .VFGRedGradientEnd
            }
            self.quickActionsView.layer.sublayers?.first?.frame = self.quickActionsView.bounds
            self.quickActionsView.layer.layoutSublayers()
        }
    }

    func addCustomHeaderViewIfAvailable() {
        guard let customView = model?.customHeaderView else { return }

        customHeaderStackView.isHidden = false
        customHeaderViewHeightConstraint.constant = maxCustomHeaderViewHeight
        view.layoutIfNeeded()
        customHeaderStackView.addArrangedSubview(customView)
        // hide default header views
        headerButton.isHidden = true
        backButton.isHidden = true
        titleLabel.isHidden = true
    }

    func resetsHeaderViewHeight() {
        customHeaderViewHeightConstraint.constant = defaultHeaderViewHeight
        view.layoutIfNeeded()
    }

    private func observeKeyboard() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardDidAppear),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardDidDisappear),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }

    private func reloadView() {
        contentView?.removeFromSuperview()
        proportionalHeight?.isActive = false
        titleLabel.text = model?.quickActionsTitle
        titleLabel.font = model?.titleFont
        headerButton.titleLabel?.font = model?.titleFont
        setupContentView()
        setAccessibilityForVoiceOver()
    }

    private func setupAccessibilityIDs() {
        let model = self.model?.accessibilityModel ?? VFQuickActionsAccessibilityModel()
        view.accessibilityIdentifier = model.mainView
        titleLabel.accessibilityIdentifier = model.title
        closeButton.accessibilityIdentifier = model.closeButton
        backButton.accessibilityIdentifier = model.backButton
        headerButton.accessibilityIdentifier = model.headerButton
        closeButton.accessibilityLabel = "close"
    }
}

extension VFQuickActionsViewController: VFQuickActionsProtocol {
    public func reloadQuickAction(model: VFQuickActionsModel?) {
        guard let newModel = model else { return }
        self.model = newModel
        self.model?.quickActionsProtocol(delegate: self)
        reloadView()
        setupCustomTitleAttributeIfAvailable()
    }

    public func closeQuickAction(completion: (() -> Void)?) {
        animatedDismiss(completion: completion)
    }

    public func shouldScroll(height: CGFloat) {
        scrollView.contentOffset = CGPoint(x: 0, y: height)
    }
}
