//
//  VFGChangePasswordViewController.swift
//  VFGMVA10Framework
//
//  Created by Mohamed Abd ElNasser on 12/28/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import VFGMVA10Foundation
import Lottie

public class VFGChangePasswordViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleLabel: VFGLabel!
    @IBOutlet weak var descriptionLabel: VFGLabel!
    @IBOutlet var cardView: UIView!
    @IBOutlet weak var currentPasswordTextField: VFGTextField!
    @IBOutlet weak var forgotPasswordButton: VFGButton!
    @IBOutlet weak var forgotPasswordButtonTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var passwordStrengthView: UIView!
    @IBOutlet weak var passwordStrengthViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var passwordStrengthTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var newPasswordTextField: VFGTextField!
    @IBOutlet weak var confirmPasswordTextField: VFGTextField!
    @IBOutlet var textFields: [VFGTextField]!
    @IBOutlet weak var rulesContainerView: UIView!
    @IBOutlet weak var rulesContainerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var confirmButton: VFGButton!
    var rulesStackView: UIStackView?
    var strengthStackView: UIStackView?
    var strengthLabel: VFGLabel?

    public weak var delegate: VFGChangePasswordProtocol?
    var changePasswordConfig: VFGChangePasswordResultConfig?
    var validationTimer = Timer()
    var changePasswordStatus = false
    var quickActionsResultView: VFGQuickActionsResultView?
    var passwordStrengthBoxesCount: Int = 7
    var enabledPasswordStrengthBoxesCount: Int = 0 {
        didSet {
            updatePasswordStrengthBoxes()
        }
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        addKeyboardDismissHandler()
        observeKeyboardNotifications()
        cardView.configureShadow()

        setupForgotPasswordButton()
        setupConfirmButton()
        setupLabels()
        setupTextFields()
        setupAccessibilityIDs()

        addStrengthView()
        addRulesView()
        setAccessibilityForVoiceOver()
    }

    func setupConfirmButton() {
        confirmButton.isEnabled = false
        confirmButton.setTitle(
            "change_password_confirm_button_title".localized(bundle: .mva10Framework),
            for: .normal
        )
    }

    func setupLabels() {
        titleLabel.text = "change_password_subtitle".localized(bundle: .mva10Framework)
        descriptionLabel.text = "change_password_description".localized(bundle: .mva10Framework)
    }

    func setupTextFields() {
        textFields.forEach {
            $0.resetTextField()
            $0.configureTextFieldStyle(textFont: .vodafoneRegular(18.7))
            $0.delegate = self
        }
        let currentPasswordHint =
            "change_password_current_password_placeholder".localized(bundle: .mva10Framework)
        currentPasswordTextField.configureTextField(
            topTitleText: currentPasswordHint,
            placeHolder: currentPasswordHint,
            rightIcon: UIImage.VFGPassword.show,
            secureTextEntry: true)

        let newPasswordHint =
            "change_password_new_password_placeholder".localized(bundle: .mva10Framework)
        newPasswordTextField.configureTextField(
            topTitleText: newPasswordHint,
            placeHolder: newPasswordHint,
            rightIcon: UIImage.VFGPassword.show,
            secureTextEntry: true)

        let confirmPasswordHint =
            "change_password_confirm_new_password_placeholder".localized(bundle: .mva10Framework)
        confirmPasswordTextField.configureTextField(
            topTitleText: confirmPasswordHint,
            placeHolder: confirmPasswordHint,
            rightIcon: UIImage.VFGPassword.show,
            secureTextEntry: true)
    }

    func setAccessibilityForVoiceOver() {
        titleLabel.accessibilityLabel = titleLabel.text ?? ""
        descriptionLabel.accessibilityLabel = descriptionLabel.text ?? ""
        currentPasswordTextField.setTopLabelAccessibilityLabel(
            with: currentPasswordTextField.textFieldTopTitleText)
        currentPasswordTextField.setRightButtonAccessibilityLabel(
            with: "Eye icon")
        currentPasswordTextField.setRightButtonAccessibilityHint(
            with: "Show entered password")
        forgotPasswordButton.accessibilityLabel = forgotPasswordButton.titleLabel?.text ?? ""
        newPasswordTextField.setTopLabelAccessibilityLabel(
            with: newPasswordTextField.textFieldTopTitleText)
        newPasswordTextField.setRightButtonAccessibilityLabel(
            with: "Eye icon")
        newPasswordTextField.setRightButtonAccessibilityHint(
            with: "Show entered password")
        strengthLabel?.accessibilityLabel = strengthLabel?.text
        confirmPasswordTextField.setTopLabelAccessibilityLabel(
            with: confirmPasswordTextField.textFieldTopTitleText)
        confirmPasswordTextField.setRightButtonAccessibilityLabel(
            with: "Eye icon")
        confirmPasswordTextField.setRightButtonAccessibilityHint(
            with: "Show entered password")
        confirmButton.accessibilityLabel = confirmButton.titleLabel?.text ?? ""
    }

    func checkAccessibilityCustomActions() {
        if forgotPasswordButton.isHidden && confirmButton.isEnabled {
            accessibilityCustomActions = [changePasswordVoiceOverAction()]
        } else if !forgotPasswordButton.isHidden && confirmButton.isEnabled {
            accessibilityCustomActions = [forgotPasswordVoiceOverAction(), changePasswordVoiceOverAction()]
        } else if !forgotPasswordButton.isHidden && !confirmButton.isEnabled {
            accessibilityCustomActions = [forgotPasswordVoiceOverAction()]
        } else {
            accessibilityCustomActions = []
        }
    }

    @IBAction func confirmButtonDidPress(_ sender: VFGButton) {
        changePassword()
    }
    @objc func changePassword() {
        validationTimer.invalidate()
        delegate?.confirmButtonAction(
            currentPassword: currentPasswordTextField.textFieldText,
            newPassword: newPasswordTextField.textFieldText) { [weak self] status, configModel in
            guard let self = self else { return }
            self.changePasswordConfig = configModel
            self.changePasswordStatus = status
            if status {
                self.presentQuickActionsSuccessView(configModel)
            } else {
                self.presentQuickActionsFailureView(configModel)
            }
        }
    }
    func changePasswordVoiceOverAction() -> UIAccessibilityCustomAction {
        let actionName = confirmButton.titleLabel?.text ?? ""
        return UIAccessibilityCustomAction(name: actionName, target: self, selector: #selector(changePassword))
    }

    func presentQuickActionsSuccessView(_ configModel: VFGChangePasswordResultConfig?) {
        let defaultTitle = "change_password_modal_success_title".localized(bundle: .mva10Framework)
        let defaultDescription = "change_password_modal_success_subtitle".localized(bundle: .mva10Framework)
        let defaultActionTitle = "change_password_modal_success_button_title".localized(bundle: .mva10Framework)

        let model = VFGQuickActionsResultModel(
            type: .success,
            delegate: self,
            titleText: configModel?.messageTitle ?? defaultTitle,
            descriptionText: configModel?.messageDescription ?? defaultDescription,
            primaryButtonTitle: configModel?.actionTitle ?? defaultActionTitle,
            titleFont: .vodafoneBold(25),
            descriptionFont: .vodafoneRegular(16.6))

        quickActionsResultView = VFGQuickActionsResultView(
            title: "change_password_modal_title".localized(bundle: .mva10Framework),
            isCloseButtonHidden: configModel?.isCloseButtonHidden ?? true,
            model: model,
            accessibilityVoiceOverModel: VFGResultViewAccessibilityVoiceOverModel(
                imageViewLabel: nil,
                animationViewLabel: "Check mark animated view")
        )

        guard let quickActionsResultView = quickActionsResultView else { return }

        VFQuickActionsViewController.presentQuickActionsViewController(with: quickActionsResultView)
    }

    func presentQuickActionsFailureView(_ configModel: VFGChangePasswordResultConfig?) {
        let defaultActionTitle = "change_password_modal_failure_button_title".localized(bundle: .mva10Framework)
        let defaultDescription = "change_password_modal_failure_subtitle".localized(bundle: .mva10Framework)
        let defaultTitle = "change_password_modal_failure_title".localized(bundle: .mva10Framework)
        let model = VFGQuickActionsResultModel(
            type: .failure,
            delegate: self,
            titleText: configModel?.messageTitle ?? defaultTitle,
            descriptionText: configModel?.messageDescription ?? defaultDescription,
            primaryButtonTitle: configModel?.actionTitle ?? defaultActionTitle,
            titleFont: .vodafoneBold(25),
            descriptionFont: .vodafoneRegular(16.6))
        quickActionsResultView = VFGQuickActionsResultView(
            title: "change_password_modal_title".localized(bundle: .mva10Framework),
            isCloseButtonHidden: configModel?.isCloseButtonHidden ?? false,
            model: model,
            accessibilityVoiceOverModel: VFGResultViewAccessibilityVoiceOverModel(
                imageViewLabel: "Failure warning view",
                animationViewLabel: nil)
        )
        guard let quickActionsResultView = quickActionsResultView else { return }
        VFQuickActionsViewController
            .presentQuickActionsViewController(with: quickActionsResultView)
    }

    public func setText(of textFieldType: VFGTextFieldType, to newText: String) {
        switch textFieldType {
        case .current:
            currentPasswordTextField.textFieldText = newText
        case .new:
            newPasswordTextField.textFieldText = newText
        case .confirm:
            confirmPasswordTextField.textFieldText = newText
        }
    }

    public func showError(on textFieldType: VFGTextFieldType, errorMessage newText: String) {
        switch textFieldType {
        case .current:
            currentPasswordTextField.showError(title: newText)
        case .new:
            newPasswordTextField.showError(title: newText)
        case .confirm:
            confirmPasswordTextField.showError(title: newText)
        }
        updateStrengthPosition()
        updateForgotPasswordPosition()
        checkAccessibilityCustomActions()
    }
}
