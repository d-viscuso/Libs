//
//  VFGPersonalAdvisorProtocol.swift
//  VFGMVA10PersonalAdvisor
//
//  Created by Vasiliki Trachani, Vodafone on 12/08/2022.
//

import Foundation

public enum VFGTextType {
    case phoneNumber
    case description
}

public enum ValidationTextResult {
    case success
    case failed(errorMessage: String, textField: VFGTextType?)
}
/// Types of actions
///     - previousStatus: user press previous status request button
///     - sendRequest: user send new request for asking personal advisor
public enum VFGPersonalAdvisorStatus: Equatable {
    case previousStatus(type: VFGStatusPreviousRequest)
    case sendRequest(type: Bool)
}

/// Types of previous request status result
///     - sent: previous request has been sent.
///     - completed: personal advisor has contacted with user.
///     - failed: failed to update previous request status
public enum VFGStatusPreviousRequest {
    case sent
    case completed
    case failed
}

public protocol VFGPersonalAdvisorProtocol: AnyObject {
    /// Max range of allowed characters to type in phone field
    var phoneMaxLength: Int { get }
    /// Allowed characters to type in phone field
    var phoneAllowedCharacters: String { get }
    /// Max range of allowed characters to type in description field
    var descriptionMaxLength: Int { get }
    /// Determines whether description bottom label should be hidden or not
    /// Tip or Error label
    var isDescriptionBottomLabelHidden: Bool? { get }
    /// Determines whether check previous status request button should be hidden or not
    var hasPreviousRequest: Bool? { get }
    /// Shows the name of user's personal advisor
    var personalAdvisorName: String? { get }
    /// Validates if the required fields for request are correct or not.
    /// - Parameters:
    ///     - honeNumber: Phone number the personal advisor will use to contact the user.
    ///     - descriptionOfRequest: Description of request.
    ///     - completion: Completion of type *ValidationTextResult* to let you know if the validation succeeded or failed.
    func validate(
        phoneNumber: String,
        descriptionOfRequest: String,
        completion: (ValidationTextResult) -> Void
    )
    /// Action that occures when you press on confirm button in Personal Advisor screen.
    /// - Parameters:
    ///     - phoneNumber: Phone number the personal advisor will use to contact the user.
    ///     - descriptionOfRequest: Description of request.
    ///     - Completion: Completion of a boolean that it's true if the request was sent or not.
    func confirmButtonAction(
        phoneNumber: String,
        descriptionOfRequest: String,
        completion: @escaping (Bool) -> Void
    )

    /// Action that occures when you finish the request for Personal Advisor
    /// - Parameters:
    ///     - isDismissed: Boolean to dermine if it should dismiss the screen or not.
    func didFinish(isDismissed: Bool)
    /// Action that occures when you press the previous request status button.
    /// - Parameters:
    ///     - completion: Completion of VFGStatusPreviousRequest.
    func checkPreviousRequestStatus(
        completion: (VFGStatusPreviousRequest) -> Void
    )
    /// Action that occures when you finish the previous status request for Personal Advisor
    /// - Parameters:
    ///     - isDismissed: Boolean to dermine if it should dismiss the screen or not.
    func didFinishAfterPreviousStatusRequest(isDismissed: Bool)
}

extension VFGPersonalAdvisorProtocol {
    public var phoneMaxLength: Int { 14 }
    public var descriptionMaxLength: Int { 255 }
    public var isDescriptionBottomLabelHidden: Bool? {
        false
    }
    public var personalAdvisorName: String? { nil }
    public var hasPreviousRequest: Bool? {
        false
    }
}
