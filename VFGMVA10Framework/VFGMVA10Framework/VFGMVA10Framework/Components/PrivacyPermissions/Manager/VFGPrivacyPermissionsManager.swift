//
//  VFGPrivacyPermissionsManager.swift
//  VFGMVA10Framework
//
//  Created by Moustafa Hegazy on 23/09/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

/// Privacy Permissions Manager
public class VFGPrivacyPermissionsManager {
    /// Network Object
    let networkClient = VFGNetworkClient(baseURL: "")
    /// Request Object
    var request = VFGRequest()
    /// Privacy Permissions Model
    static var model: PrivacyPermissionsModel?
    var privacyVC: VFGPrivacyPermissionViewController?
    var appErrorScreen: AppErrorScreenViewController?

    public init() {}

    /// *VFGPrivacyPermissionsManager* initializer
    /// - Parameters:
    ///    - filePath: Path for the Json model
    ///    - completion: Closure that contains *PrivacyPermissionsModel* and *Error* after initializing the Manager
    public init(filePath: String, completion: ((PrivacyPermissionsModel?, Error?) -> Void)?) {
        request.path = filePath
        networkClient.executeData(
            request: request,
            model: PrivacyPermissionsModel.self) { result in
            switch result {
            case .success(let model):
                VFGPrivacyPermissionsManager.model = model
                completion?(model, nil)
            case .failure(let error):
                VFGErrorLog(error.localizedDescription)
                completion?(nil, error)
            }
        }
    }

    /// *VFGPrivacyPermissionsManager* initializer
    /// - Parameters:
    ///    - model: Privacy Permissions Model
    ///    - delegate: Privacy Permissions Protocol Object
    public func presentPrivacyManager(model: PrivacyPermissionsModel, delegate: VFGPrivacyPermissionsProtocol) -> UIViewController {
        let privacyViewController = VFGPrivacyPermissionViewController
            .init(nibName: "VFGPrivacyPermissionViewController", bundle: .mva10Framework)
        privacyViewController.view.frame = CGRect(
            x: 0,
            y: 0,
            width: UIScreen.main.bounds.width,
            height: UIScreen.main.bounds.height)
        VFGPrivacyPermissionsManager.model = model
        privacyViewController.delegate = delegate
        privacyVC = privacyViewController
        return privacyViewController
    }

    public func showPrivacySettingsErrorView() {
        appErrorScreen = AppErrorScreenViewController
            .instance(from: "AppErrorScreen", with: "AppErrorScreenViewController", bundle: Bundle.foundation)

        guard let errorScreen = appErrorScreen, let privacyVC = privacyVC else { return }
        errorScreen.configure(
            title: "privacy_settings_accept_all_error_screen_title".localized(bundle: .mva10Framework),
            message: "privacy_settings_accept_all_error_screen_message".localized(bundle: .mva10Framework),
            buttonText: "privacy_settings_accept_all_error_screen_button".localized(bundle: .mva10Framework),
            titleFontSize: 24,
            messageFontSize: 16)

        errorScreen.appErrorButtonAction = {
            errorScreen.willMove(toParent: nil)
            errorScreen.view.removeFromSuperview()
            errorScreen.removeFromParent()
            privacyVC.privacySettingButtonPressed()
        }

        errorScreen.view.backgroundColor = .clear
        errorScreen.view.frame = privacyVC.view.frame
        privacyVC.addChild(errorScreen)
        privacyVC.view.addSubview(errorScreen.view)
        privacyVC.view.endLoadingAnimation()
        errorScreen.didMove(toParent: privacyVC)
    }
}
