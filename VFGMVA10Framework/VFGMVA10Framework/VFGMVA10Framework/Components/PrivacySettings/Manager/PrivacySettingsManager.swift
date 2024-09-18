//
//  PrivacySettingsManager.swift
//  VFGMVA10Framework
//
//  Created by Ashraf Dewan on 13/01/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import VFGMVA10Foundation
import UIKit
/// Manager of privacy settings journey
public class PrivacySettingsManager {
    /// Static instance of *PrivacySettingsManager*
    public static var shared = PrivacySettingsManager()
    /// An instance of *PrivacySettingsDataProviderProtocol*
    public var dataProvider: PrivacySettingsDataProviderProtocol?
    /// *PrivacySettingsProtocol* delegate for *PrivacySettingsManager*
    public weak var delegate: PrivacySettingsProtocol?
    /// Navigation controller for privacy settings journey
    var navController: MVA10NavigationController?
    /// Present privacy settings main screen
    var privacyVC: VFGCustomizedPermissionsViewController?

    public func presentPrivacySettingsViewController() {
        let viewModel = PrivacySettingsViewModel(dataProvider: dataProvider)
        let privacySettingsViewController: PrivacySettingsViewController = UIViewController.instance(
            from: "PrivacySettingsViewController",
            with: "PrivacySettingsViewController",
            bundle: .mva10Framework
        )
        privacySettingsViewController.viewModel = viewModel
        privacySettingsViewController.delegate = delegate
        navController = MVA10NavigationController(rootViewController: privacySettingsViewController)
        guard let navController = navController else { return }
        navController.setTitle(
            title: "privacy_settings_title".localized(bundle: .mva10Framework),
            for: privacySettingsViewController
        )
        navController.modalPresentationStyle = .fullScreen
        UIApplication.topViewController()?.present(navController, animated: true, completion: nil)
    }
    /// Present privacy settings customized permissions screen
    public func navigateToCustomizedPermissions(with entryPoint: PermissionsEntryPoint = .personalizedRecommendations) {
        var title = ""
        switch entryPoint {
        case .personalizedRecommendations:
            title = "personal_preferences_title".localized(bundle: .mva10Framework)
        case .contactPreferences:
            title = "privacy_settings_contact_preferences_title".localized(bundle: .mva10Framework)
        case .thirdPartyAppTracking:
            title = "privacy_settings_third_party_apps_title".localized(bundle: .mva10Framework)
        }
        privacyVC = VFGCustomizedPermissionsViewController.init(
            nibName: String(describing: VFGCustomizedPermissionsViewController.self),
            bundle: .mva10Framework
        )
        privacyVC?.entryPoint = entryPoint
        let viewModel = VFGCustomizedPermissionsViewModel(dataProvider: dataProvider)
        privacyVC?.viewModel = viewModel
        guard let navController = self.navController,
            let privacyVC = privacyVC else { return }
        navController.pushViewController(privacyVC, animated: true)
        navController.setTitle(title: title, for: privacyVC)
    }
}
