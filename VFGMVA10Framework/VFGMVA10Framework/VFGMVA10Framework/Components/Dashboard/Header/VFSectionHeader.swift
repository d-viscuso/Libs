//
//  VFSectionHeader.swift
//  StickyHeaders
//
//  Created by Bart Jacobs on 01/10/16.
//  Copyright © 2016 Cocoacasts. All rights reserved.
//

import UIKit
import VFGMVA10Foundation
/// Dashboard collection view section header types
enum SectionHeaderType: String {
    case mainSection
    case discoverySection
}
/// Dashboard collection view section header
class VFSectionHeader: UICollectionReusableView {
    /// Determine whether collection view section header animation finished or not
    static var finishedAnimation = false
    @IBOutlet var greetingMessageLabel: VFGLabel!
    @IBOutlet weak var titleLabel: VFGLabel!
    @IBOutlet var accountTitleLabel: VFGLabel!
    @IBOutlet var logoImageView: VFGImageView!
    @IBOutlet weak var logoTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var statusContainerView: UIView!
    @IBOutlet weak var iconsContainerView: UIView!
    @IBOutlet weak var iconsContainerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var myProductsButton: VFGButton!
    @IBOutlet weak var customView: UIView!
    @IBOutlet weak var dashboardHeaderButton: VFGButton!
    var customViewHeightAnchor: NSLayoutConstraint?
    /// Dashboard collection view section header press action
    var tapAction: (((() -> Void)?) -> Void)?
    /// Dashboard collection view section header my products data model
    var myProductsModel: VFGDashboardMyProductsHeaderModel? {
        didSet {
            myProductsButton.setImage(myProductsModel?.image, for: .normal)
        }
    }
    /// Dashboard collection view section header EIO timer
    var eiokTimer: Timer?
    /// Dashboard collection view section header EIO data model
    var eioModel: VFGEIOModelProtocol?
    /// Dashboard collection view section header list of items checks
    var checks: [CheckItem]? {
        return eioModel?.model?.checks
    }
    /// Animation first delay duration
    var firstDelayDuration: TimeInterval {
        let count = checks?.count ?? 0
        let const = (TimeInterval(count) * Constants.EIOAnimation.delayBetweenEachImage)
        return Constants.EIOAnimation.iconAnimationDuration
            + const
            + Constants.eiokWelcomeMessageDuration
    }
    /// Determine whether collection view section header animation started or not
    var isAnimated = false
    /// Determine if it is the first time user sign in
    var firstEnter = true
    /// Dashboard collection view section header message
    var headerMessage = ""
    /// Delegate for dashboard collection view section header height
    weak var delegate: UpdateDashboardSectionHeightDelegate?
    /// Control account title apperance
    var delayAccountTitle = true

    @IBAction func headerTapped(_ sender: Any) {
        if eioModel?.isEIOEnabled ?? true {
            tapAction? { [weak self] in
                guard let self = self else {
                    return
                }
                self.refreshTitleLabel()
            }
        }
    }

    private func invalidateTimer() {
        if let eiokTimer = self.eiokTimer {
            eiokTimer.invalidate()
        }
    }

    deinit {
        if eiokTimer != nil {
            eiokTimer?.invalidate()
            eiokTimer = nil
        }
        statusContainerView.removeGestures()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        logoImageView.enableDynamicDirection = false
        if UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft ||
            UIView.appearance().semanticContentAttribute == .forceRightToLeft {
            greetingMessageLabel.textAlignment = .left
        } else {
            greetingMessageLabel.textAlignment = .right
        }
        setupAccessibilityLabels()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        // Keep current alpha after reloading collection view
        alpha = Constants.DashboardSectionHeader.currentAlpha
    }

    override func prepareForReuse() {
        statusContainerView.removeGestures()
        super.prepareForReuse()
    }
    /// Dashboard collection view section header account title configuration
    func setupAccountTitle() {
        guard
            let status = eioModel?.eioStatus,
            status == .success,
            !VFGUser.shared.accounts.isEmpty,
            let selectedAccount = VFGUser.shared.selectedAccount() else {
                accountTitleLabel.isHidden = true
                return
        }

        if delayAccountTitle {
            accountTitleLabel.alpha = 0
            UIView.animate(
                withDuration: Constants.EIOAnimation.iconAnimationDuration,
                delay: Constants.eiokWelcomeMessageDelay,
                options: .curveEaseOut,
                animations: {
                    self.accountTitleLabel.alpha = 1
                },
                completion: nil)
            delayAccountTitle = false
        }
        accountTitleLabel.isHidden = false
        accountTitleLabel.text = selectedAccount.name
    }
    /// Dashboard collection view section header custom view controller configuration
    /// - Parameters:
    ///    - customViewController: View controller to configure
    ///    - height: Custom view controller height
    func setupCustomView(
        with customViewController: UIViewController?,
        height: CGFloat
    ) {
        // Remove old custom view if exist
        customView.subviews.forEach {
            $0.removeFromSuperview()
        }
        guard let newView = customViewController?.view else {
            customView.isHidden = true
            customViewHeightAnchor = customView.heightAnchor.constraint(equalToConstant: 0)
            customViewHeightAnchor?.isActive = true
            return
        }
        customView.isHidden = false
        customView.addSubview(newView)
        customViewHeightAnchor?.isActive = false
        customViewHeightAnchor = customView.heightAnchor.constraint(equalToConstant: height)
        customViewHeightAnchor?.isActive = true
        NSLayoutConstraint.activate([
            newView.topAnchor.constraint(equalTo: customView.topAnchor),
            newView.bottomAnchor.constraint(equalTo: customView.bottomAnchor),
            newView.leadingAnchor.constraint(equalTo: customView.leadingAnchor),
            newView.trailingAnchor.constraint(equalTo: customView.trailingAnchor)
        ])
    }
    /// Animate showing greeting message while data configuration is finished
    func blinkHeader() {
        let status = eioModel?.eioStatus
        if status == .inProgress {
            greetingMessageLabel.alpha = Constants.EIOAnimation.iconOpacity
            UIView.animate(
                withDuration: Constants.EIOAnimation.blinkingHeaderDuration,
                delay: 0,
                options: [.repeat, .autoreverse, .curveEaseIn]) {
                self.greetingMessageLabel.alpha = 1
            }
        }
    }
    /// Checks icons configuration
    func drawChecksIcons() {
        iconsContainerView.removeSubviews()
        guard let checks = checks,
            !checks.isEmpty,
            eioModel?.eioStatus != .success else {
                iconsContainerHeightConstraint.constant = 0
                return
        }
        iconsContainerHeightConstraint.constant = Constants.DashboardSectionHeader.iconsContainerHeight
        var x: CGFloat = -32
        var availableArea = UIScreen.main.bounds.width - Constants.dashboardHeaderIconsWidth
            - Constants.dashboardHeaderMargin
        let iconWithPaddingWidth = Constants.dashboardHeaderIconsWidth + Constants.dashboardHeaderIconsPadding
        for index in stride(from: checks.count - 1, through: 0, by: -1) {
            guard availableArea > iconWithPaddingWidth,
                let iconImageName = checks[index].icon else {
                    return
            }

            if UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft ||
                UIView.appearance().semanticContentAttribute == .forceRightToLeft {
                x += iconWithPaddingWidth
            } else {
                x = availableArea - Constants.dashboardHeaderIconsWidth
            }

            let icon = VFGImageView(frame: CGRect(
                x: x,
                y: 0,
                width: Constants.dashboardHeaderIconsWidth,
                height: Constants.dashboardHeaderIconsWidth))
            icon.image = VFGImage(named: iconImageName)
            iconsContainerView.addSubview(icon)
            availableArea -= iconWithPaddingWidth
            if let indexOfEachItem = checks.firstIndex(where: { $0.itemId == checks[index].itemId }) {
                icon.alpha = Constants.EIOAnimation.iconOpacity
                if !isAnimated {
                    animateImageViewsBeforeChecking(icon: icon, indexOfEachItem: indexOfEachItem)
                }
                switch checks[index].status {
                case .success?:
                    animateImageViews(icon: icon, indexOfEachItem: indexOfEachItem, firstDelay: !isAnimated)
                case .failed?:
                    animateBlinking(icon: icon, firstDelay: !isAnimated)
                default: break
                }
            }
        }
        isAnimated = true
    }
    /// Draw parallex effect animation
    /// - Parameters:
    ///    - offset: Parallex effect offset
    func parallexAnimation(offset: CGFloat) {
        guard !(eioModel is VFGDisableEIO) else { return }
        let alphaPercentage = offset * Constants.DashboardSectionHeader.parallexRatio /
            VFGUISetup.dashboardMainHeaderHeight
        Constants.DashboardSectionHeader.currentAlpha = 1 - alphaPercentage
        alpha = Constants.DashboardSectionHeader.currentAlpha
        if offset > 0 {
            logoTopConstraint.constant = Constants.DashboardSectionHeader.initialLogoTopMargin + (offset / 2)
        } else {
            logoTopConstraint.constant = Constants.DashboardSectionHeader.initialLogoTopMargin
        }
    }

    private func animateImageViews(icon: VFGImageView, indexOfEachItem: Int, firstDelay: Bool) {
        icon.alpha = Constants.EIOAnimation.iconOpacity
        let delay = firstDelay ? firstDelayDuration : 0
        let duration = firstDelay ? Constants.EIOAnimation.iconAnimationDuration : 0
        UIView.animate(
            withDuration: duration,
            delay: delay,
            options: .curveEaseOut) { icon.alpha = 1 }
    }

    private func animateImageViewsBeforeChecking(icon: VFGImageView, indexOfEachItem: Int) {
        icon.alpha = 0
        icon.transform = CGAffineTransform(translationX: 0, y: Constants.EIOAnimation.yOffset)
        UIView.animate(
            withDuration: Constants.EIOAnimation.iconAnimationDuration,
            delay: TimeInterval(indexOfEachItem) * Constants.EIOAnimation.delayBetweenEachImage,
            options: .curveEaseOut) {
            icon.alpha = Constants.EIOAnimation.iconOpacity
            icon.transform = CGAffineTransform(translationX: 0, y: 0)
        }
    }

    private func animateBlinking(icon: VFGImageView, firstDelay: Bool) {
        icon.alpha = 1
        if eioModel?.eioStatus == .failed {
            let delay = firstDelay ? firstDelayDuration : 0
            icon.blink(
                initialAlpha: Constants.EIOAnimation.iconOpacity,
                duration: Constants.EIOAnimation.blinkingIconDuration,
                delay: delay)
        }
    }

    @IBAction func myProductsButtonDidPress(_ sender: Any) {
        myProductsModel?.buttonAction?()
    }
}
// MARK: - Accessibility related logic
extension VFSectionHeader {
    func myProductsVoiceOverAction() -> UIAccessibilityCustomAction {
        let actionName = myProductsButton.titleLabel?.text ?? "My Products"
        return UIAccessibilityCustomAction(
            name: actionName,
            target: self,
            selector: #selector(myProductsButtonDidPress))
    }

    func dashboardHeaderVoiceOverAction() -> UIAccessibilityCustomAction {
        let actionName = myProductsButton.titleLabel?.text ?? "Expand Header"
        return UIAccessibilityCustomAction(name: actionName, target: self, selector: #selector(headerTapped))
    }

    private func setupAccessibilityLabels() {
        myProductsButton.isAccessibilityElement = myProductsButton.image(for: .normal) != nil
        myProductsButton.accessibilityValue = "Image of \(titleHeader)"
        myProductsButton.accessibilityCustomActions = [myProductsVoiceOverAction()]

        dashboardHeaderButton.isAccessibilityElement = true
        dashboardHeaderButton.accessibilityLabel = "Dashboard Header"
        dashboardHeaderButton.accessibilityCustomActions = [dashboardHeaderVoiceOverAction()]
        accessibilityElements = [
            greetingMessageLabel,
            dashboardHeaderButton,
            myProductsButton,
            customView
        ].compactMap { $0 }
    }
}

extension UIView {
    func fadeTransition(_ duration: CFTimeInterval) {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name:
            CAMediaTimingFunctionName.easeInEaseOut)
        animation.type = CATransitionType.fade
        animation.duration = duration
        layer.add(animation, forKey: CATransitionType.fade.rawValue)
    }
}
