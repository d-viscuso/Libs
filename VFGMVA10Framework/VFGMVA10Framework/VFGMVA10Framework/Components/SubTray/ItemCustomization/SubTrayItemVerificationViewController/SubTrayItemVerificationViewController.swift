//
//  SubTrayItemVerificationViewController.swift
//  VFGMVA10Framework
//
//  Created by Mohamed Abd ElNasser on 21/09/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import VFGMVA10Foundation
/// Sub tray customization code verification screen
class SubTrayItemVerificationViewController: UIViewController {
    @IBOutlet weak var mainImageView: VFGImageView!
    @IBOutlet weak var mainTitleLabel: VFGLabel!
    @IBOutlet weak var enterCodeLabel: VFGLabel!
    @IBOutlet weak var pinCodeView: VFGPinCodeView!
    @IBOutlet weak var pinCodeHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var primaryButton: VFGButton!
    @IBOutlet weak var secondaryButton: VFGButton!
    /// Number of pin code digits
    var pinCodeLength = 6
    /// *mainTitleLabel* text
    var verificationText = ""
    /// Delegation protocol for *SubTrayCustomizationManager* actions
    weak var delegate: SubTrayItemVerificationDelegate?
    /// Delegation protocol for *SubTrayCustomizationManager* navigation actions
    weak var navigationDelegate: SubTrayCustomizationManagerNavigationDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupText()
        setupFonts()
        setupPinView()
        primaryButton.isEnabled = false
        mainImageView.image = VFGFrameworkAsset.Image.icSms
        pinCodeView.pinLength = pinCodeLength
        let pinCodeInnerMargin: CGFloat = 8
        let sideMargins: CGFloat = 33
        let totalMargins: CGFloat = (CGFloat(pinCodeLength - 1) * pinCodeInnerMargin) + sideMargins
        let pinCodeDimension = (UIScreen.main.bounds.width - totalMargins) / CGFloat(pinCodeLength)
        pinCodeHeightConstraint.constant = pinCodeDimension
    }
    /// UI texts configuration
    func setupText() {
        mainTitleLabel.text = verificationText
        enterCodeLabel.text = "sub_tray_verification_enter_sms".localized(bundle: .mva10Framework)
        primaryButton.setTitle(
            "sub_tray_verification_set_default_primary_button".localized(bundle: .mva10Framework),
            for: .normal)
        secondaryButton.setTitle(
            "sub_tray_verification_set_default_secondary_button".localized(bundle: .mva10Framework),
            for: .normal)
    }
    /// UI fonts configuration
    func setupFonts() {
        mainTitleLabel.font = .vodafoneBold(25)
        enterCodeLabel.font = .vodafoneRegular(16.6)
        primaryButton.titleLabel?.font = .vodafoneRegular(18.7)
        secondaryButton.titleLabel?.font = .vodafoneRegular(18.7)
    }
    /// *pinCodeView* actions configuration
    func setupPinView() {
        pinCodeView.didFinishCallback = { [weak self] code in
            guard let self = self else { return }
            self.checkPinCodeValidation(code: code)
        }
        pinCodeView.didChangeCallback = { [weak self] code in
            guard let self = self else { return }
            self.checkPinCodeValidation(code: code)
        }
    }
    /// Check if entered code is valid
    /// - Parameters:
    ///    - code: Entered pin code for verification
    func checkPinCodeValidation(code: String) {
        guard code.count == pinCodeLength else {
            primaryButton.isEnabled = false
            return
        }
        if delegate?.checkPinCodeValidation(with: code) ?? false {
            primaryButton.isEnabled = true
        } else {
            // Error handling will be implemented in upcoming stories
        }
    }
    /// *SubTrayItemVerificationViewController* configuration
    /// - Parameters:
    ///    - pinCodeLength: Number of pin code digits
    ///    - verificationText: *mainTitleLabel*  text
    ///    - delegate: Delegation protocol for *SubTrayCustomizationManager* actions
    ///    - navigationDelegate: Delegation protocol for *SubTrayCustomizationManager* navigation actions
    func configure(
        pinCodeLength: Int,
        verificationText: String,
        delegate: SubTrayItemVerificationDelegate?,
        navigationDelegate: SubTrayCustomizationManagerNavigationDelegate?
    ) {
        self.pinCodeLength = pinCodeLength
        self.verificationText = verificationText
        self.delegate = delegate
        self.navigationDelegate = navigationDelegate
    }

    @IBAction func primaryButtonDidPress(_ sender: VFGButton) {
        navigationDelegate?.finish(state: .verification)
    }

    @IBAction func secondaryButtonDidPress(_ sender: VFGButton) {
        navigationDelegate?.terminate(state: .verification)
    }
}
