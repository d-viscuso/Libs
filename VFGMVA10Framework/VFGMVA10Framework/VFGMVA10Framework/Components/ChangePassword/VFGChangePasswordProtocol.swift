//
//  VFGChangePasswordProtocol.swift
//  VFGMVA10Framework
//
//  Created by Mohamed Abd ElNasser on 12/31/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation

public enum VFGTextFieldType {
    case current
    case new
    case confirm
}

public enum ValidationResult {
    case success
    case failed(errorMessage: String, textField: VFGTextFieldType?)
}

public protocol VFGChangePasswordResultConfig {
    var action: ActionType? { get set }
    var actionTitle: String? { get set }
    var messageTitle: String? { get set }
    var messageDescription: String? { get set }
    var isCloseButtonHidden: Bool? { get set }
}

public enum ActionType {
    case dismiss
}

public struct NewPasswordRule {
    let description: String
    let isMandatory: Bool
    let evaluate: (String) -> Bool

    /// Creates a rule for the new password.
    /// - Parameters:
    ///   - description: The rule's description that will be visible to the user
    ///   - isMandatory: If the rule should be evaluated as true in order to enable the change password button
    ///   - evaluate: A function that indicates whether the password is compliant to the rule
    public init(description: String, isMandatory: Bool, evaluate: @escaping (String) -> Bool) {
        self.description = description
        self.isMandatory = isMandatory
        self.evaluate = evaluate
    }
}

/// Change password protocol.
public protocol VFGChangePasswordProtocol: AnyObject {
    /// Provide a default algorithm that calculates the PasswordStrength
    /// - Parameter password: the password we need to calculate its strength
    /// - Returns: returns a PasswordStrength indicator which is an integer in range 1...7. If the return value is nil then the strength indicator is hidden
    func strength(ofPassword password: String) -> PasswordStrength?

    /// Password rules that will appear in change password screen under the confirmation textfield. Also, if rule is mandatory then its evaluation method
    /// should be valid in order to show the confirm button enabled
    var newPasswordRules: [NewPasswordRule] { get }

    /// If its false, then the forgot password button will be shown otherwise it will be hidden
    var isForgottenPasswordButtonHidden: Bool { get }

    /// The action will be executed when forgot password button is touchedUpInside
    func forgotPasswordAction()

    /// Validates if current password is correct or not, if the new password matches the it's confirmation and if it's a valid password or not.
    /// - Parameters:
    ///     - currentPassword: Current password.
    ///     - newPassword: New password.
    ///     - confirmedPassword: New password confirmation.
    ///     - completion: Completion of type *ValidationResult* to let you know if the validation succeeded or failed.
    func validate(
        currentPassword: String,
        newPassword: String,
        confirmedPassword: String,
        completion: (ValidationResult) -> Void
    )

    /// Action that occures when you press on confirm button in change password screen.
    /// - Parameters:
    ///     - currentPassword: Current password.
    ///     - newPassword: New password.
    ///     - completion: Completion of a boolean and string
    ///     boolean value is true if the change succeeded and false if it didn't.
    ///     string value descripes the change password action status.
    ///     Example: (true, " Succeeded to change the password! ")
    func confirmButtonAction(
        currentPassword: String,
        newPassword: String,
        completion: @escaping (Bool, VFGChangePasswordResultConfig?) -> Void
    )

    /// Action that occures when you finish the change password journey
    /// - Parameters:
    ///     - isDismissed: Boolean to dermine if it should dismiss the screen or not.
    func didFinish(isDismissed: Bool)
}

public extension VFGChangePasswordProtocol {
    /// Use default algorithm for passwordStrength if its not provided explicitly
    func strength(ofPassword password: String) -> PasswordStrength? {
        Navajo.strength(ofPassword: password)
    }

    /// Forgot password button is hidden by default
    var isForgottenPasswordButtonHidden: Bool {
        true
    }

    /// New password rules default
    var newPasswordRules: [NewPasswordRule] {
        []
    }

    /// Forgot password button feature is optional, so is the forgotPasswordAction
    func forgotPasswordAction() {}
}
