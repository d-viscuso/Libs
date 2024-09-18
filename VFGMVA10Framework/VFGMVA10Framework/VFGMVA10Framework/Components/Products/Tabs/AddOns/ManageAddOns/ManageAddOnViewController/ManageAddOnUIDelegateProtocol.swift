//
//  ManageAddOnUIDelegateProtocol.swift
//  VFGMVA10Framework
//
//  Created by Amr Koritem on 18/05/2022.
//

import VFGMVA10Foundation

public typealias ManageAddOnActionHandler = (_ addOnIdentifier: String) -> Void

/// ManageAddOnUIDelegateProtocol to handle custom ui and texts
public protocol ManageAddOnUIDelegateProtocol: AnyObject {
    /// used to specify the custom handler for buying a specific addOn successfully.
    /// if a value is returned, then a result view will appear showing wether the buying is successful or not. In case it's successfull, the handler logic will be called.
    /// if nil is returned, then the default implementation will take place.
    var customHandleForBuyAddOn: ManageAddOnActionHandler? { get }
    /// used to specify the custom handler for removing a specific addOn successfully.
    /// if a value is returned, then a result view will appear showing wether the removing is successful or not. In case it's successfull, the handler logic will be called.
    /// if nil is returned, then the default implementation will take place.
    var customHandleForRemoveAddOn: ManageAddOnActionHandler? { get }
    /// used to specify whether the header view is scrollabe or not
    var isScrollableHeaderView: Bool? { get }
    /// used to specify whether the buy addons button * in  AddOnsViewController * is hidden or not 
    var isBuyAddOnsButtonHidden: Bool? { get }
    /// A string that represents the more details messege for the confirmation view
    var confirmationViewMessageText: String? { get }
    /// used to specify a custom view to appear at the bottom of the screen ui elements but above the action button.
    @available(*, deprecated, message: "please use `infoView(of:mode:)` instead")
    func infoView(of addOnIdentifier: String) -> UIView?
    /// used to specify a custom view to appear at the bottom of the screen ui elements but above the action button.
    /// - Parameters:
    ///     - addOnIdentifier: Determine addon identifier.
    ///     - mode: Determine the screen mode
    /// - Returns:
    ///     - info view. If a value is returned, then it will be used as info view. If nil is returned, then nothing will be displayed as as an info view.
    func infoView(of addOnIdentifier: String, mode: ManageAddOnActions) -> UIView?
    /// used to specify a custom view to appear at the bottom of the screen ui elements but above the action button.
    @available(*, deprecated, message: "please use `getDescription(of:autoRenewSwitch:mode:)` instead")
    func getDescription(of addOnIdentifier: String, autoRenewSwitch autoRenewIsOn: Bool) -> String?
    /// used to specify a custom view to appear at the bottom of the screen ui elements but above the action button.
    /// - Parameters:
    ///     - addOnIdentifier: Determine addon identifier.
    ///     - autoRenewSwitch: Determine the auto renew switch value
    ///     - mode: Determine the screen mode
    /// - Returns:
    ///     - addon description. If a value is returned, then it will be used as description. If nil is returned, then the default description specified in the model will be used.
    func getDescription(of addOnIdentifier: String, autoRenewSwitch autoRenewIsOn: Bool, mode: ManageAddOnActions) -> String?
    /// used to specify the auto renew title of a specific addOn
    @available(*, deprecated, message: "please use `autoRenewTitle(of:mode:)` instead")
    func autoRenewTitle(of addOnIdentifier: String) -> String
    /// used to specify the auto renew title of a specific addOn
    /// - Parameters:
    ///     - addOnIdentifier: Determine addon identifier.
    ///     - mode: Determine the screen mode
    func autoRenewTitle(of addOnIdentifier: String, mode: ManageAddOnActions) -> String
    /// used to specify the date title of a specific addOn
    @available(*, deprecated, message: "please use `dateLabelTitle(of:mode:)` instead")
    func dateLabelTitle(of addOnIdentifier: String) -> String
    /// used to specify the date title of a specific addOn
    /// - Parameters:
    ///     - addOnIdentifier: Determine addon identifier.
    ///     - mode: Determine the screen mode
    func dateLabelTitle(of addOnIdentifier: String, mode: ManageAddOnActions) -> String
    /// used to specify the action button style of a specific addOn
    @available(*, deprecated, message: "please use `actionButtonStyle(of:mode:)` instead")
    func actionButtonStyle(of addOnIdentifier: String) -> VFGButton.ButtonStyle
    /// used to specify the action button style of a specific addOn
    /// - Parameters:
    ///     - addOnIdentifier: Determine addon identifier.
    ///     - mode: Determine the screen mode
    func actionButtonStyle(of addOnIdentifier: String, mode: ManageAddOnActions) -> VFGButton.ButtonStyle
}

public extension ManageAddOnUIDelegateProtocol {
    var isScrollableHeaderView: Bool? {
        false
    }

    var isBuyAddOnsButtonHidden: Bool? {
        false
    }
    var confirmationViewMessageText: String? {
        nil
    }
    func infoView(of addOnIdentifier: String) -> UIView? {
        nil
    }

    func infoView(of addOnIdentifier: String, mode: ManageAddOnActions) -> UIView? {
        infoView(of: addOnIdentifier)
    }

    var customHandleForBuyAddOn: ManageAddOnActionHandler? {
        nil
    }

    var customHandleForRemoveAddOn: ManageAddOnActionHandler? {
        nil
    }

    func getDescription(of addOnIdentifier: String, autoRenewSwitch autoRenewIsOn: Bool) -> String? {
        nil
    }

    func getDescription(of addOnIdentifier: String, autoRenewSwitch autoRenewIsOn: Bool, mode: ManageAddOnActions) -> String? {
        getDescription(of: addOnIdentifier, autoRenewSwitch: autoRenewIsOn)
    }

    func autoRenewTitle(of addOnIdentifier: String) -> String {
        ""
    }

    func autoRenewTitle(of addOnIdentifier: String, mode: ManageAddOnActions) -> String {
        autoRenewTitle(of: addOnIdentifier)
    }

    func dateLabelTitle(of addOnIdentifier: String) -> String {
        ""
    }

    func dateLabelTitle(of addOnIdentifier: String, mode: ManageAddOnActions) -> String {
        dateLabelTitle(of: addOnIdentifier)
    }

    func actionButtonStyle(of addOnIdentifier: String) -> VFGButton.ButtonStyle {
        .primary
    }

    func actionButtonStyle(of addOnIdentifier: String, mode: ManageAddOnActions) -> VFGButton.ButtonStyle {
        actionButtonStyle(of: addOnIdentifier)
    }
}
