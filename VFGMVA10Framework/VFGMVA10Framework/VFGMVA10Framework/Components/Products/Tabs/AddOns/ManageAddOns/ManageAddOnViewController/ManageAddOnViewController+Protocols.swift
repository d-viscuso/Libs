//
//  ManageAddOnViewController+Protocols.swift
//  VFGMVA10Framework
//
//  Created by Amr Koritem on 05/06/2022.
//

import VFGMVA10Foundation

// MARK: - VFGConfirmationAlertDelegate
extension ManageAddOnViewController: VFGTwoActionsViewProtocol {
    public func primaryButtonAction() {
        if manageAddOnVM?.actionType == .remove {
            removeAddOn()
        } else if manageAddOnVM?.actionType == .buy {
            buyAddOn()
        }
    }

    public func secondaryButtonAction() {
        manageAddOnVM?.closeQuickAction()
        dismissQuickActionVC()
    }

    func removeAddOn(completion: (() -> Void)? = nil) {
        manageAddOnVM?.quickActionsContentView.startLoadingAnimation(backgroundColor: .white)
        manageAddOnVM?.removeAddOn { [weak self] error in
            self?.manageAddOnVM?.quickActionsContentView.endLoadingAnimation()
            self?.removeAddOnCompletion(error)
            completion?()
        }
        guard uiDelegate?.customHandleForRemoveAddOn == nil else { return }
        manageAddOnVM?.closeQuickAction()
    }

    func buyAddOn(completion: (() -> Void)? = nil) {
        manageAddOnVM?.quickActionsContentView.startLoadingAnimation(backgroundColor: .white)
        manageAddOnVM?.buyAddOn { [weak self] error in
            self?.manageAddOnVM?.quickActionsContentView.endLoadingAnimation()
            self?.buyAddOnCompletion(error)
            completion?()
        }
        guard uiDelegate?.customHandleForBuyAddOn == nil else { return }
        manageAddOnVM?.closeQuickAction()
    }

    func removeAddOnCompletion(_ error: Error?) {
        guard let error = error else {
            handleRemoveAddonSuccess()
            return
        }
        VFGErrorLog(error.localizedDescription)
        guard uiDelegate?.customHandleForRemoveAddOn != nil else { return }
        manageAddOnVM?.activeResultViewType = .failure
        changeQuickActionContentView(to: manageAddOnVM?.resultFailureView)
    }

    func buyAddOnCompletion(_ error: Error?) {
        guard let error = error else {
            handleBuyAddonSuccess()
            return
        }
        VFGErrorLog(error.localizedDescription)
        guard uiDelegate?.customHandleForBuyAddOn != nil else { return }
        manageAddOnVM?.activeResultViewType = .failure
        changeQuickActionContentView(to: manageAddOnVM?.resultFailureView)
    }

    func handleRemoveAddonSuccess() {
        guard uiDelegate?.customHandleForRemoveAddOn != nil else {
            popAfterRemoveAddon()
            return
        }
        manageAddOnVM?.activeResultViewType = .success
        changeQuickActionContentView(to: manageAddOnVM?.resultSuccessView)
    }

    func handleBuyAddonSuccess() {
        guard uiDelegate?.customHandleForBuyAddOn != nil else {
            popAfterBuyAddon()
            return
        }
        manageAddOnVM?.activeResultViewType = .success
        changeQuickActionContentView(to: manageAddOnVM?.resultSuccessView)
    }

    func popAfterRemoveAddon() {
        let popAction = navigationDelegate?.popAfterRemoveAddOnAction(addOnIdentifier: addOnIdentifier ?? "")
        popAction?(self)
    }

    func popAfterBuyAddon() {
        let popAction = navigationDelegate?.popAfterBuyAddOnAction(addOnIdentifier: addOnIdentifier ?? "")
        popAction?(self)
    }

    func dismissQuickActionVC(_ completion: (() -> Void)? = nil) {
        let navigationController = UIApplication.topViewController()
        guard navigationController is VFQuickActionsViewController else {
            completion?()
            return
        }
        navigationController?.dismiss(animated: true, completion: completion)
    }
}

// MARK: - VFGResultViewProtocol
extension ManageAddOnViewController: VFGResultViewProtocol {
    public func resultViewPrimaryButtonAction() {
        switch manageAddOnVM?.activeResultViewType {
        case .success:
            manageAddOnVM?.closeQuickAction { [weak self] in
                self?.dismissQuickActionVC { [weak self] in
                    guard self?.manageAddOnVM?.actionType == .buy else {
                        self?.popAfterRemoveAddon()
                        self?.uiDelegate?.customHandleForRemoveAddOn?(self?.addOnIdentifier ?? "")
                        return
                    }
                    self?.popAfterBuyAddon()
                    self?.uiDelegate?.customHandleForBuyAddOn?(self?.addOnIdentifier ?? "")
                }
            }
        case .failure:
            primaryButtonAction()
        default:
            break
        }
    }
    public func resultViewSecondaryButtonAction() {
        manageAddOnVM?.closeQuickAction()
        dismissQuickActionVC()
    }
    public func quickActionsClose(isCloseButton: Bool) {}
}

// MARK: - VFGTrayContainerProtocol
extension ManageAddOnViewController: VFGTrayContainerProtocol {
    public var tobiKey: String {
        "\(ManageAddOnViewController.self)"
    }

    public var trayStyle: VFGTrayStyle {
        .TOBI
    }

    public var tobiContainerVC: UIViewController? {
        return VFGManagerFramework.tobiDelegate?.helpViewController(for:
            "\(ManageAddOnViewController.self)")
    }
}
