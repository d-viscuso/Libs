//
//  SubTrayCustomizationManager.swift
//  VFGMVA10Framework
//
//  Created by Mohamed Abd ElNasser on 23/09/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import VFGMVA10Foundation
/// Sub tray customization journey manager
public class SubTrayCustomizationManager {
    /// Sub tray customization navigation controller
    public var navigationController: MVA10NavigationController
    /// Sub tray customization view controller
    var customizationViewController: SubTrayItemCustomizationViewController
    /// Sub tray verification view controller
    var verificationViewController: SubTrayItemVerificationViewController?
    /// Result view that display to declare that operation succeeded
    var successResultView: VFGResultView?
    /// Delegation for *SubTrayCustomizationManager* actions
    weak var delegate: SubTrayCustomizationManagerDelegate?
    /// Delegation for *SubTrayCustomizationManager* data source
    var dataSource: SubTrayCustomizationManagerDataSource?
    /// Quick action with confirmation message of the operation process
    var confirmationQuickActionModel: SubTrayCustomizationQuickActionsModel?
    /// View to show and hide loading
    var topView: UIView?
    /// Determine whether loading screen is presented or not
    var isLoadingPresented = false
    /// Sub tray customization item
    var subTrayItem: VFGSubTrayItem
    /// Current sub tray default item
    var currentDefaultItem: VFGSubTrayItem?
    /// Set the new title for current sub tray item device
    var newDeviceTitle = ""
    /// Determine if current sub tray item is the new default item or not
    var newDefaultState = false
    /// *SubTrayCustomizationManager* initializer
    /// - Parameters:
    ///    - subTrayItem: Sub tray customization item
    ///    - currentDefaultItem: Current sub tray default item
    ///    - delegate: Delegation for *SubTrayCustomizationManager* actions
    ///    - dataSource: Delegation for *SubTrayCustomizationManager* data source
    public init(
        subTrayItem: VFGSubTrayItem,
        currentDefaultItem: VFGSubTrayItem?,
        delegate: SubTrayCustomizationManagerDelegate?,
        dataSource: SubTrayCustomizationManagerDataSource? = nil
    ) {
        self.delegate = delegate
        self.dataSource = dataSource
        self.subTrayItem = subTrayItem
        self.currentDefaultItem = currentDefaultItem
        customizationViewController = SubTrayItemCustomizationViewController.instance()
            as SubTrayItemCustomizationViewController
        navigationController = MVA10NavigationController(
            rootViewController: customizationViewController)
        configureNavigationController()
        configureCustomizationController(with: subTrayItem)
    }
    /// Handle presenting *SubTrayItemCustomizationViewController*
    public func presentCustomizationViewController() {
        UIApplication.topViewController()?.present(navigationController, animated: true)
    }
    /// Handle dismissing the top view controller
    public func dismiss() {
        navigationController.dismiss(animated: true)
    }
    /// Sub tray customization navigation controller configuration
    func configureNavigationController() {
        navigationController.setTitle(
            title: "sub_tray_customization_customize_title".localized(bundle: .mva10Framework),
            for: customizationViewController)
        navigationController.hasDivider = false
    }
    /// *SubTrayItemCustomizationViewController* configuration
    /// - Parameters:
    ///    - subTrayItem: Sub tray customization item
    func configureCustomizationController(with subTrayItem: VFGSubTrayItem) {
        customizationViewController.configure(
            subTrayItem: subTrayItem,
            deviceNameTextFieldMaxLength: dataSource?.deviceNameMaxLength ?? 17,
            navigationDelegate: self)
    }
    /// *successResultView* presentation
    func presentSuccessView() {
        navigationController.isBackButtonHidden = true
        navigationController.isCloseButtonHidden = true
        navigationController.setTitle(
            title: "sub_tray_verification_confirmation_title".localized(bundle: .mva10Framework),
            for: UIViewController())
        successResultView = UIView.loadXib(bundle: .foundation)
        guard
            let resultView = successResultView,
            let topView = navigationController.viewControllers.last?.view else { return }
        let model = VFGQuickActionsResultModel(
            type: .success,
            delegate: self,
            titleText: "sub_tray_verification_transaction_successful".localized(bundle: .mva10Framework),
            descriptionText: "sub_tray_verification_change_default".localized(bundle: .mva10Framework),
            primaryButtonTitle: "sub_tray_verification_return_to_dashboard".localized(bundle: .mva10Framework),
            titleFont: .vodafoneBold(29.1),
            descriptionFont: .vodafoneRegular(18.7))
        resultView.configure(
            model: model,
            style: .fullScreen,
            backgroundColor: .VFGWhiteBackground)
        topView.embed(view: resultView)
    }
}


// MARK: - SubTrayCustomizationManagerNavigationDelegate
extension SubTrayCustomizationManager: SubTrayCustomizationManagerNavigationDelegate {
    func finish(state: SubTrayCustomizationManagerState) {
        if isLoadingPresented {
            hideLoading()
        }
        switch state {
        case let .customization(newName, isDefault):
            newDeviceTitle = newName
            newDefaultState = isDefault
            if !isDefault || subTrayItem.isDefault ?? false {
                updateItemData()
            } else {
                presentQuickAction()
            }
        case .verification:
            updateItemData()
        case .quickActionsConfirmation:
            presentVerificationViewController()
        case .loading(let status):
            if status {
                presentSuccessView()
            }
        case .success:
            presentSuccessView()
        default: break
        }
    }
    /// Handle updating sub tray customization item data
    func updateItemData() {
        presentLoadingView()
        delegate?.updateItemData(
            item: subTrayItem,
            newTitle: newDeviceTitle,
            isDefault: newDefaultState) { [weak self] status in
            guard let self = self else { return }
            self.finish(state: .loading(status: status))
        }
    }

    func terminate(state: SubTrayCustomizationManagerState) {
        switch state {
        case .customization:
            delegate?.customizationViewControllerCancelAction()
        case .verification:
            delegate?.verificationViewControllerCancelAction()
        default:
            dismiss()
        }
    }
}

// MARK: - VFGTwoActionsViewProtocol
extension SubTrayCustomizationManager: SubTrayItemVerificationDelegate {
    func checkPinCodeValidation(with code: String) -> Bool {
        delegate?.checkPinCodeValidation(with: code) ?? false
    }
}
