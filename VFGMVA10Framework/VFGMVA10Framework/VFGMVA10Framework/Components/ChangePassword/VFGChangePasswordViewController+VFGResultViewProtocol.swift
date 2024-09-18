//
//  VFGChangePasswordViewController+VFGResultViewProtocol.swift
//  VFGMVA10Framework
//
//  Created by Atta Ahmed on 15/05/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

// MARK: - QuickActions Logic
extension VFGChangePasswordViewController: VFGResultViewProtocol {
    public func resultViewPrimaryButtonAction() {
        guard let customAction = changePasswordConfig?.action
        else {
            handleDefaultAction()
            return
        }
        handleCustomAction(customAction)
    }

    private func handleDefaultAction() {
        quickActionsResultView?.closeQuickAction()
        if changePasswordStatus {
            self.delegate?.didFinish(isDismissed: false)
            dismiss(animated: true) {
                self.delegate?.didFinish(isDismissed: true)
            }
        } else {
            changePassword()
        }
    }

    private func handleCustomAction(_ customAction: ActionType) {
        switch customAction {
        case .dismiss:
            quickActionsResultView?.closeQuickAction()
            self.delegate?.didFinish(isDismissed: false)
            dismiss(animated: true) {
                self.delegate?.didFinish(isDismissed: true)
            }
        }
    }
}

// MARK: - VFGTrayContainerProtocol
extension VFGChangePasswordViewController: VFGTrayContainerProtocol {
    public var tobiKey: String {
        "\(VFGChangePasswordViewController.self)"
    }

    public var trayStyle: VFGTrayStyle {
        .TOBI
    }

    public var tobiContainerVC: UIViewController? {
        return VFGManagerFramework.tobiDelegate?
            .helpViewController(for: "\(VFGChangePasswordViewController.self)")
    }
}
// MARK: - Accessibility IDs
extension VFGChangePasswordViewController {
    func setupAccessibilityIDs() {
        currentPasswordTextField.setTextFieldIdentifier(with: "CPcurrentPasswordTextField")
        newPasswordTextField.setTextFieldIdentifier(with: "CPnewPasswordTextField")
        confirmPasswordTextField.setTextFieldIdentifier(with: "CPconfirmPasswordTextField")
        confirmPasswordTextField.setErrorHintLabelIdentifier(with: "CPconfirmPasswordError")
    }
}

// MARK: - Forgot password
extension VFGChangePasswordViewController {
    func setupForgotPasswordButton() {
        forgotPasswordButton.isHidden = delegate?.isForgottenPasswordButtonHidden ?? true
        forgotPasswordButton.setUnderlinedTitle(
            title: "change_password_forget_password_button_title".localized(bundle: .mva10Framework),
            font: .vodafoneRegular(14),
            color: .VFGPrimaryText,
            state: .normal
        )
        forgotPasswordButton.addTarget(self, action: #selector(forgottenPasswordTouchUpInside), for: .touchUpInside)
        updateForgotPasswordPosition()
    }

    @objc func forgottenPasswordTouchUpInside() {
        delegate?.forgotPasswordAction()
    }
    func forgotPasswordVoiceOverAction() -> UIAccessibilityCustomAction {
        let actionName = forgotPasswordButton.titleLabel?.text ?? ""
        return UIAccessibilityCustomAction(
            name: actionName,
            target: self,
            selector: #selector(forgottenPasswordTouchUpInside))
    }

    func updateForgotPasswordPosition() {
        forgotPasswordButtonTopConstraint.isActive = false
        forgotPasswordButtonTopConstraint = forgotPasswordButton.topAnchor.constraint(
            equalTo: currentPasswordTextField.bottomAnchor,
            constant: currentPasswordTextField.hasError ? 0 : -25)
        forgotPasswordButtonTopConstraint.isActive = true
    }
}

// MARK: - Password strength
extension VFGChangePasswordViewController {
    func addStrengthView() {
        // Check if we should show the strength indicator by checking if password returns a value
        guard delegate?.strength(ofPassword: "") != nil else {
            return
        }
        passwordStrengthViewHeightConstraint.isActive = false
        updateStrengthPosition()

        strengthLabel = VFGLabel()
        guard let strengthLabel = strengthLabel else { return }
        strengthLabel.translatesAutoresizingMaskIntoConstraints = false
        strengthLabel.font = .vodafoneRegular(14)
        strengthLabel.textColor = .VFGSecondaryText
        strengthLabel.text = "change_password_strength_title".localized(bundle: .mva10Framework)
        strengthLabel.textAlignment = .right
        passwordStrengthView.addSubview(strengthLabel)

        strengthStackView = UIStackView()
        guard let strengthStackView = strengthStackView else { return }
        strengthStackView.translatesAutoresizingMaskIntoConstraints = false
        strengthStackView.alignment = .center
        strengthStackView.distribution = .fillEqually
        strengthStackView.spacing = 8
        passwordStrengthView.addSubview(strengthStackView)

        (1...passwordStrengthBoxesCount).forEach { _ in
            let boxView = UIView()
            boxView.translatesAutoresizingMaskIntoConstraints = false
            boxView.backgroundColor = .VFGPasswordIndicatorDisabled
            boxView.heightAnchor.constraint(equalToConstant: 4).isActive = true
            strengthStackView.addArrangedSubview(boxView)
        }

        NSLayoutConstraint.activate([
            strengthLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 70),
            strengthLabel.trailingAnchor.constraint(equalTo: passwordStrengthView.trailingAnchor),
            strengthLabel.topAnchor.constraint(equalTo: passwordStrengthView.topAnchor),
            strengthLabel.bottomAnchor.constraint(equalTo: passwordStrengthView.bottomAnchor),
            strengthStackView.leadingAnchor.constraint(equalTo: passwordStrengthView.leadingAnchor),
            strengthStackView.topAnchor.constraint(equalTo: passwordStrengthView.topAnchor, constant: 2),
            strengthStackView.bottomAnchor.constraint(equalTo: passwordStrengthView.bottomAnchor),
            strengthStackView.trailingAnchor.constraint(equalTo: strengthLabel.leadingAnchor, constant: -4)
        ])
    }

    func updatePasswordStrengthBoxes() {
        strengthStackView?.arrangedSubviews.enumerated().forEach { index, view in
            view.backgroundColor = index < enabledPasswordStrengthBoxesCount
                ? .VFGPasswordIndicatorEnabled
                : .VFGPasswordIndicatorDisabled
        }
    }

    func updateStrengthPosition() {
        passwordStrengthTopConstraint.isActive = false
        passwordStrengthTopConstraint = passwordStrengthView.topAnchor.constraint(
            equalTo: newPasswordTextField.bottomAnchor,
            constant: newPasswordTextField.hasError ? 0 : -20)
        passwordStrengthTopConstraint.isActive = true
    }
}

// MARK: - New Password Rules
extension VFGChangePasswordViewController {
    func addRulesView() {
        guard let rules = delegate?.newPasswordRules, !rules.isEmpty else {
            return
        }
        rulesContainerViewHeightConstraint.isActive = false

        rulesStackView = UIStackView()
        guard let rulesStackView = rulesStackView else { return }
        rulesStackView.translatesAutoresizingMaskIntoConstraints = false
        rulesStackView.axis = .vertical
        rulesStackView.spacing = 4
        rulesStackView.alignment = .fill
        rulesStackView.distribution = .fill
        rulesContainerView.addSubview(rulesStackView)

        rules.forEach { rule in
            let ruleView = VFGChangePasswordRuleView(with: rule)
            ruleView.translatesAutoresizingMaskIntoConstraints = false
            rulesStackView.addArrangedSubview(ruleView)
        }

        NSLayoutConstraint.activate([
            rulesStackView.leadingAnchor.constraint(equalTo: rulesContainerView.leadingAnchor),
            rulesStackView.topAnchor.constraint(equalTo: rulesContainerView.topAnchor),
            rulesStackView.trailingAnchor.constraint(equalTo: rulesContainerView.trailingAnchor),
            rulesStackView.bottomAnchor.constraint(equalTo: rulesContainerView.bottomAnchor)
        ])
    }

    @discardableResult
    func checkPasswordRules(_ password: String) -> Bool {
        // if no delegate is provided then return always true
        guard let delegate = delegate else { return true }

        delegate.newPasswordRules.enumerated().forEach { index, rule in
            let isValid = rule.evaluate(password)
            guard let arrangedSubviews = rulesStackView?.arrangedSubviews,
                arrangedSubviews.count > index,
                let passwordRuleView = arrangedSubviews[index] as? VFGChangePasswordRuleView else {
                return
            }
            passwordRuleView.toggle(isValid)
        }

        let hasPendingMandatoryRule = delegate.newPasswordRules
            .filter { $0.isMandatory }
            .contains { !$0.evaluate(password) }
        return !hasPendingMandatoryRule
    }
}
