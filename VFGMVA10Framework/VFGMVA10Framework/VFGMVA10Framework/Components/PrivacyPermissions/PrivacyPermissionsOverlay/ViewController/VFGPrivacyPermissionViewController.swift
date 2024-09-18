//
//  VFGPrivacyPermissionViewController.swift
//  VFGMVA10Framework
//
//  Created by Moustafa Hegazy on 23/09/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation
import Lottie

/// Privacy Permissions View Controller 
public class VFGPrivacyPermissionViewController: UIViewController {
    @IBOutlet weak var readPrivacyPolicyButton: VFGButton!
    @IBOutlet weak var acceptAllButton: VFGButton!
    @IBOutlet weak var rejectAllButton: VFGButton!
    @IBOutlet weak var titleLabel: VFGLabel!
    @IBOutlet weak var privacyButton: VFGButton!
    @IBOutlet weak var benefitsStackView: UIStackView!
    @IBOutlet weak var descTextView: UITextView!
    @IBOutlet weak var textViewHeight: NSLayoutConstraint!
    @IBOutlet weak var closeButton: VFGButton!
    @IBOutlet weak var outerStackView: UIStackView!

    /// Model Object
    var model = VFGPrivacyPermissionsManager.model?.privacyPermissionsOverlay
    /// Delegate Object
    public weak var delegate: VFGPrivacyPermissionsProtocol?
    /// Expandability state
    var expandedTextView = false
    lazy var loadingLogoView: VFGLoadingLogoView? = VFGLoadingLogoView.loadXib(bundle: .foundation)


    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setAccessibilityForVoiceOver()
    }

    /// UI setup method
    func setupUI() {
        closeButton.setImage(VFGFrameworkAsset.Image.icClose, for: .normal)
        titleLabel.text = model?.infoSection.title
        readPrivacyPolicyButton.setUnderlinedTitle(
            title: "privacy_permissions_read_privacy_policy".localized(bundle: .mva10Framework),
            font: .vodafoneRegular(17),
            color: .VFGLinkDarkGreyText,
            state: .normal
        )
        acceptAllButton.setTitle(
            "privacy_permissions_accept_all_settings".localized(bundle: .mva10Framework),
            for: .normal
        )
        rejectAllButton.setTitle(
            "privacy_permissions_reject_all_settings".localized(bundle: .mva10Framework),
            for: .normal
        )
        privacyButton.setTitle("privacy_permissions_set_settings".localized(bundle: .mva10Framework), for: .normal)
        setupTextView(text: model?.infoSection.fullHTMLDesc ?? "")
        benefitsStackView.removeAllArrangedSubviews()
        setupBenefitsStackView()
    }

    func setAccessibilityForVoiceOver() {
        closeButton.accessibilityLabel = "Close"
        titleLabel.accessibilityLabel = titleLabel.text ?? ""
        descTextView.accessibilityLabel = descTextView.text ?? ""
        readPrivacyPolicyButton.accessibilityLabel = readPrivacyPolicyButton.titleLabel?.text ?? ""
        acceptAllButton.accessibilityLabel = acceptAllButton.titleLabel?.text ?? ""
        rejectAllButton.accessibilityLabel = rejectAllButton.titleLabel?.text ?? ""
        privacyButton.accessibilityLabel = privacyButton.titleLabel?.text ?? ""
        setupAccessibilityCustomActions()
    }

    func setupAccessibilityCustomActions() {
        accessibilityCustomActions = [
            closeButtonVoiceOverAction(),
            readPrivacyButtonVoiceOverAction(),
            acceptAllPermissionsButtonVoiceOverAction(),
            rejectAllButtonVoiceOverAction(),
            privacySettingButtonVoiceOverAction()
        ]
    }

    func removeAccessibilityCustomActions() {
        accessibilityCustomActions = []
    }

    /// Read More About Privacy Policy entry point button action
    @IBAction func readPrivacyDidPressed(_ sender: Any) {
        readPrivacyButtonPressed()
    }
    @objc func readPrivacyButtonPressed() {
        let privacyPolicyVC = VFGPrivacyPolicyViewController
            .init(
                nibName: "VFGPrivacyPolicyViewController",
                bundle: .mva10Framework
            )
        privacyPolicyVC.modalPresentationStyle = .fullScreen
        addChild(privacyPolicyVC)
        privacyPolicyVC.view.frame = view.frame
        view.addSubview(privacyPolicyVC.view)
        privacyPolicyVC.didMove(toParent: self)
        outerStackView.isHidden = true
        removeAccessibilityCustomActions()
    }
    func readPrivacyButtonVoiceOverAction() -> UIAccessibilityCustomAction {
        let actionName = readPrivacyPolicyButton.titleLabel?.text ?? ""
        return UIAccessibilityCustomAction(
            name: actionName,
            target: self,
            selector: #selector(readPrivacyButtonPressed)
        )
    }

    @IBAction func acceptAllPermissionsDidPressed(_ sender: Any) {
        acceptAllPermissionsButtonPressed()
    }
    @objc func acceptAllPermissionsButtonPressed() {
        outerStackView.isHidden = true
        removeAccessibilityCustomActions()
        view.startLoadingAnimation(
            backgroundColor: .VFGWhiteBackground,
            title: "privacy_settings_loading_screen_title".localized(bundle: .mva10Framework),
            titleFont: .vodafoneRegular(17),
            titleTextColor: .VFGRedWhiteText)
        delegate?.acceptAllButtonDidPressed(viewController: self)
    }
    func acceptAllPermissionsButtonVoiceOverAction() -> UIAccessibilityCustomAction {
        let actionName = acceptAllButton.titleLabel?.text ?? ""
        return UIAccessibilityCustomAction(
            name: actionName,
            target: self,
            selector: #selector(acceptAllPermissionsButtonPressed)
        )
    }

    @IBAction func rejectAllButtonDidPressed(_ sender: Any) {
        rejectAllButtonPressed()
    }
    @objc func rejectAllButtonPressed() {
        outerStackView.isHidden = true
        removeAccessibilityCustomActions()
        delegate?.rejectAllButtonDidPressed(viewController: self)
    }
    func rejectAllButtonVoiceOverAction() -> UIAccessibilityCustomAction {
        let actionName = rejectAllButton.titleLabel?.text ?? ""
        return UIAccessibilityCustomAction(name: actionName, target: self, selector: #selector(rejectAllButtonPressed))
    }

    /// Privacy Setting entry point button action
    @IBAction func privacySettingDidPressed(_ sender: Any) {
        privacySettingButtonPressed()
    }
    @objc func privacySettingButtonPressed() {
        let setPermissionsVC = VFGSetPrivacyPermissionsViewController
            .init(
                nibName: "VFGSetPrivacyPermissionsViewController",
                bundle: .mva10Framework
            )
        setPermissionsVC.modalPresentationStyle = .fullScreen
        setPermissionsVC.navigationDelegate = self
        addChild(setPermissionsVC)
        setPermissionsVC.view.frame = view.frame
        view.addSubview(setPermissionsVC.view)
        setPermissionsVC.didMove(toParent: self)
        outerStackView.isHidden = true
        removeAccessibilityCustomActions()
    }
    func privacySettingButtonVoiceOverAction() -> UIAccessibilityCustomAction {
        let actionName = privacyButton.titleLabel?.text ?? ""
        return UIAccessibilityCustomAction(
            name: actionName,
            target: self,
            selector: #selector(privacySettingButtonPressed)
        )
    }

    /// Close screen button action 
    @IBAction func closeButtonDidPressed(_ sender: Any) {
        closeAction()
    }
    @objc func closeAction() {
        toggleLoadingVisibility(true)
        DispatchQueue
            .main
            .asyncAfter(wallDeadline: .now() + .seconds(2)) { [weak self] in
                self?.delegate?.closeButtonDidPressed()
            }
    }
    func closeButtonVoiceOverAction() -> UIAccessibilityCustomAction {
        let actionName = "Close"
        return UIAccessibilityCustomAction(name: actionName, target: self, selector: #selector(closeAction))
    }
    /// Method that is used to configure loading state
    ///  - Parameters:
    ///     - state: Boolean to indicate if state is loading or not
    func toggleLoadingVisibility(_ state: Bool) {
        if state {
            guard let topView = UIApplication.topViewController()?.view else {
                return
            }
            loadingLogoView?.configure(
                style: .white,
                view: topView,
                backgroundColor: UIColor.black.withAlphaComponent(0.6)
            )
            loadingLogoView?.startLoading()
        } else {
            loadingLogoView?.endLoading()
        }
    }
    /// Method that is used to setup benefit view
    func setupBenefitsStackView() {
        for item in model?.benefits ?? [] {
            guard let benefitView: VFGBenefitsView = UIView
                .loadXib(bundle: .mva10Framework, nibName: "VFGBenefitsView")
            else { return }
            benefitView.imageView.image = VFGImage(named: item.image)
            benefitView.imageView.image?.accessibilityLabel = item.imageDesc
            benefitView.titleLabel.text = item.title
            benefitView.titleLabel.accessibilityLabel = item.title
            benefitsStackView.addArrangedSubview(benefitView)
        }
    }
    /// Method that is used to setup views
    ///  - Parameters:
    ///     - text: description of privacy permission
    ///     - fontSize: font size for description of privacy permission
    ///     - fontColor: font color for description of privacy permission
    func setupTextView(
        text: String,
        fontSize: CGFloat = 16.6,
        fontColor: UIColor = .VFGPrimaryText
    ) {
        descTextView.isUserInteractionEnabled = false
        descTextView.isScrollEnabled = true
        descTextView.attributedText = attributedTextFrom(
            htmlText: text,
            fontSize: fontSize,
            color: fontColor)
        textViewHeight.constant = descTextView.contentSize.height
        descTextView.backgroundColor = .clear
        descTextView.isScrollEnabled = false
    }
    /// Method that is used to format description
    ///  - Parameters:
    ///     - htmlText: html text
    ///     - fontSize: font size for description of privacy permission
    ///     - color: color for description of privacy permission
    ///  - Returns: attributed string for the html text
    private func attributedTextFrom(htmlText: String, fontSize: CGFloat, color: UIColor) -> NSMutableAttributedString? {
        let baseFont = UIFont.vodafoneRegular(fontSize)
        guard
            let fontName = baseFont.fontName as NSString?
        else {
            return nil
        }
        let modifiedFont = String(
            format: "<span style=\"font-family: '\(fontName)'; font-size: \(baseFont.pointSize)\">%@</span>", htmlText)

        do {
            guard let data = modifiedFont.data(using: .unicode, allowLossyConversion: true) else {
                return nil
            }
            let attributedText = try NSMutableAttributedString(
                data: data,
                options: [
                    .documentType: NSAttributedString.DocumentType.html,
                    .characterEncoding: String.Encoding.utf8.rawValue
                ],
                documentAttributes: nil
            )
            attributedText.addAttribute(textColor: color)
            return attributedText
        } catch {
            VFGDebugLog("Error getting attributed text from html: \(error)")
            return nil
        }
    }
}

extension VFGPrivacyPermissionViewController: PrivacyPermissionsNavigationProtocol {
    public func closeButtonDidPressed() {
        closeAction()
    }
}
