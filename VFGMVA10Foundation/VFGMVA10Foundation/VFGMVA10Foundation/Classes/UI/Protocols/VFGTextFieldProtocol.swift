//
//  VFGTextFieldProtocol.swift
//  VFGMVA10Foundation
//
//  Created by Esraa Eldaltony on 7/2/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import UIKit

/// A set of optional methods to manage the editing and validation of text in a text field object.
public protocol VFGTextFieldProtocol: AnyObject {
    /// Tells the delegate when editing begins in the specified text field.
    /// This method notifies the delegate that the specified text field just became the first responder. Use this method to update state information or perform other tasks. For example, you might use this method to show overlay views that are visible only while editing.
    /// - Parameters:
    ///   - vfgTextField: The text field containing the text
    func vfgTextFieldDidBeginEditing(_ vfgTextField: VFGTextField)

    /// Tells the delegate when editing stops for the specified text field.
    /// This method is called after the text field resigns its first responder status. You can use this method to update your delegate’s state information. For example, you might use this method to hide overlay views that should be visible only while editing.
    /// - Parameters:
    ///   - vfgTextField: The text field containing the text
    func vfgTextFieldDidEndEditing(_ vfgTextField: VFGTextField)

    /// Tells the delegate when change done in the specified text field.
    /// - Parameters:
    ///   - vfgTextField: The text field containing the text
    func vfgTextFieldDidChange(_ vfgTextField: VFGTextField, text: String)

    /// Tells the delegate when the right button icon in the specified text field clicked.
    /// - Parameters:
    ///   - vfgTextField: The text field containing the text
    func vfgTextFieldRightButtonClicked(_ vfgTextField: VFGTextField)

    /// Asks the delegate whether to change the specified text.
    /// The text field calls this method whenever user actions cause its text to change. Use this method to validate text as it is typed by the user. For example, you could use this method to prevent the user from entering anything but numerical values.
    /// - Parameters:
    ///   - vfgTextField: The text field containing the text
    ///   - shouldChangeCharactersIn: The range of characters to be replaced
    ///   - replacementString: The replacement string for the specified range. During typing, this parameter normally contains only the single new  character that was typed, but it may contain more characters if the user is pasting text. When the user deletes one or more characters, the replacement string is empty
    func vfgTextFieldShouldChange(
        _ vfgTextField: VFGTextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool

    /// Asks the delegate whether to begin editing in the specified text field.
    /// The text field calls this method when the user performs an action that would normally initiate the editing of the text field’s text. Implement this method if you want to prevent editing from happening in some situations.
    /// - Parameters:
    ///   - vfgTextField: The text field containing the text
    func vfgTextFieldShouldBeginEditing(_ vfgTextField: UITextField) -> Bool

    /// Asks the delegate whether to stop editing in the specified text field.
    /// The text field calls this method when it is asked to resign the first responder status. This can happen when the user selects another control or when you call the text field’s resignFirstResponder() method. Before the focus change occurs, however, the text field calls this method and gives you a chance to prevent the change from happening.
    /// - Parameters:
    ///   - vfgTextField: The text field containing the text
    func vfgTextFieldShouldEndEditing(_ vfgTextField: UITextField) -> Bool

    /// Tells the delegate when the text selection changes in the specified text field.
    /// - Parameters:
    ///   - vfgTextField: The text field containing the text
    func vfgTextFieldDidChangeSelection(_ vfgTextField: UITextField)

    /// Asks the delegate whether to remove the text field’s current contents.
    /// - Parameters:
    ///   - vfgTextField: The text field containing the text
    func vfgTextFieldShouldClear(_ vfgTextField: UITextField) -> Bool

    /// Asks the delegate whether to process the pressing of the Return button for the text field.
    /// - Parameters:
    ///   - vfgTextField: The text field containing the text
    func vfgTextFieldShouldReturn(_ vfgTextField: UITextField) -> Bool
}

public extension VFGTextFieldProtocol {
    func vfgTextFieldDidChange(_ vfgTextField: VFGTextField, text: String) {}
    func vfgTextFieldShouldChange(
        _ vfgTextField: VFGTextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        return true
    }
    func vfgTextFieldShouldBeginEditing(_ vfgTextField: UITextField) -> Bool { true }
    func vfgTextFieldShouldEndEditing(_ vfgTextField: UITextField) -> Bool { true }
    func vfgTextFieldDidChangeSelection(_ vfgTextField: UITextField) {}
    func vfgTextFieldShouldClear(_ vfgTextField: UITextField) -> Bool { false }
    func vfgTextFieldShouldReturn(_ vfgTextField: UITextField) -> Bool { false }
}
