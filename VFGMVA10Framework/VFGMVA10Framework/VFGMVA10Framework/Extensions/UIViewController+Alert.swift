//
//  UIViewController+Alert.swift
//  VFGMVA10Group
//
//  Created by Hamsa Hassan on 9/4/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import UIKit

public extension UIViewController {
    /// Method used to present *UIAlertController* with title and message.
    /// - Parameters:
    ///    - title: Alert title.
    ///    - message: Alert message.
    func presentAlert(
        title: String = "alert_warning_title".localized(bundle: Bundle.mva10Framework),
        message: String
    ) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertTitle = "alert_action_ok_button_title".localized(bundle: Bundle.mva10Framework)
        alertController.addAction(UIAlertAction(
            title: alertTitle,
            style: .default))
        present(alertController, animated: true, completion: nil)
    }

    /// Method used to present *UIAlertController* with title and message.
    /// - Parameters:
    ///    - title: Alert title.
    ///    - message: Alert message.
    ///    - modalPresentationStyle: Presentation style *UIModalPresentationStyle* of *UIAlertController*.
    ///    - modalTransitionStyle: Presentation style *UIModalTransitionStyle* of *UIAlertController*.
    func presentAlert(
        title: String = "alert_warning_title".localized(bundle: Bundle.mva10Framework),
        message: String,
        modalPresentationStyle: UIModalPresentationStyle,
        modalTransitionStyle: UIModalTransitionStyle
    ) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.modalTransitionStyle = modalTransitionStyle
        alertController.modalPresentationStyle = modalPresentationStyle
        let actionTitle = "alert_action_ok_button_title".localized(bundle: Bundle.mva10Framework)
        alertController.addAction(UIAlertAction(
            title: actionTitle,
            style: .default))
        present(alertController, animated: true, completion: nil)
    }

    /// Method used to present *UIAlertController* with title, message, confirm action and cancel action.
    /// - Parameters:
    ///    - title: Alert title.
    ///    - message: Alert message.
    ///    - actionTitle: Confirm action Button title.
    ///    - cancelTitle: Cancel action Button title.
    ///    - confirmAction: Confirm action completion.
    ///    - cancelAction: Cancel action completion.
    func presentAlert(
        title: String,
        message: String,
        actionTitle: String,
        cancelTitle: String,
        confirmAction: @escaping (UIAlertAction) -> Void,
        cancelAction: ((UIAlertAction) -> Void)? = nil
    ) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(
            title: cancelTitle,
            style: .cancel,
            handler: cancelAction))
        alertController.addAction(UIAlertAction(
            title: actionTitle,
            style: .default,
            handler: confirmAction))
        present(alertController, animated: true, completion: nil)
    }
}
