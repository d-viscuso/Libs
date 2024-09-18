//
//  VFGUpdateAccountManager.swift
//  VFGMVA10Framework
//
//  Created by Ayman Ata on 20/12/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

/// **VFGUpdateAccountManager** is the manger class responsible for edit account name journey.
public class VFGUpdateAccountManager {
    weak var quickActionDelegate: VFQuickActionsProtocol?
    weak var manageAccountDelegate: VFGManageAccountDelegate?
    var account: VFGAccount
    var isActionSuccess = false
    private let resultViewHeight: CGFloat = 550
    var resultViewHeightRatio: CGFloat {
        resultViewHeight / UIScreen.main.bounds.height
    }
    var state: VFQuickActionsModel?
    var accountActionType: AccountActionType = .rename

    enum AccountActionType {
        case rename
        case remove
    }
    /// Creates new instance of *VFGUpdateAccountManager* to manage edit account name journey.
    /// - Parameter account: The account that will be edited.
    required init(account: VFGAccount, accountActionType: AccountActionType = .rename) {
        self.account = account
        self.accountActionType = accountActionType
        presentActionView()
    }

    private func presentActionView() {
        switch accountActionType {
        case .remove:
            presentRemoveView()
        default:
            presentEditView()
        }
    }

    private func setState(state: VFQuickActionsModel) {
        self.state = state
        reloadView()
    }

    private func reloadView() {
        quickActionDelegate?.reloadQuickAction(model: self)
    }

    // MARK: - Satets of edit account name journey.
    var editingSate: VFGEditAccountNameView?
    func presentEditView() {
        editingSate = VFGEditAccountNameView.loadXib(bundle: .mva10Framework)
        editingSate?.setupWith(account: account)
        editingSate?.delegate = self
        setState(state: editingSate ?? self)
    }

    // MARK: - Satets of edit account name journey.
    var removingState: VFGRemoveAccountView?
    func presentRemoveView() {
        removingState = VFGRemoveAccountView.loadXib(bundle: .mva10Framework)
        removingState?.setup(delegate: self, account: account)
        setState(state: removingState ?? self)
    }

    var successState: VFGQuickActionsResultView?
    func presentSuccessView(_ model: VFGQuickActionsResultModel) {
        successState = VFGQuickActionsResultView(
            title: "",
            isCloseButtonHidden: false,
            model: model,
            maximumHeightRatio: resultViewHeightRatio
        )

        setState(state: successState ?? self)
    }

    var failureState: VFGQuickActionsResultView?
    func presentFailureView(_ model: VFGQuickActionsResultModel) {
        failureState = VFGQuickActionsResultView(
            title: "",
            isCloseButtonHidden: true,
            model: model,
            maximumHeightRatio: resultViewHeightRatio
        )

        setState(state: failureState ?? self)
    }

    var loadingState: VFGUpdateAccountLoadingView?
    func presentLoadingView(title: String? = nil) {
        loadingState = VFGUpdateAccountLoadingView.loadXib(bundle: .mva10Framework)
        loadingState?.setup(title: title)
        setState(state: loadingState ?? self)
    }

    private func removeAccountFailureModel() -> VFGQuickActionsResultModel {
        let description = "remove_account_quick_action_error_view_description".localized(bundle: .mva10Framework)
        return VFGQuickActionsResultModel(
            type: .customImage(VFGFrameworkAsset.Image.icProductSwitcherError),
            delegate: self,
            titleText: "remove_account_quick_action_error_view_title".localized(bundle: .mva10Framework),
            descriptionText: String(format: description, arguments: [account.name]),
            primaryButtonTitle: "remove_account_quick_action_back_button"
                .localized(bundle: .mva10Framework),
            titleFont: .vodafoneBold(24),
            descriptionFont: .vodafoneRegular(16)
        )
    }

    private func removeAccountSuccessModel() -> VFGQuickActionsResultModel {
        let description = "remove_account_quick_action_success_view_description".localized(bundle: .mva10Framework)
        return VFGQuickActionsResultModel(
            type: .success,
            delegate: self,
            titleText: "remove_account_quick_action_success_view_title".localized(bundle: .mva10Framework),
            descriptionText: String(format: description, arguments: [account.name]),
            primaryButtonTitle: "remove_account_quick_action_success_view_button_title"
                .localized(bundle: .mva10Framework),
            titleFont: .vodafoneBold(24),
            descriptionFont: .vodafoneRegular(16)
        )
    }

    private func editAccountNameFailureModel() -> VFGQuickActionsResultModel {
        let description = "edit_account_quick_action_error_view_description".localized(bundle: .mva10Framework)
        return VFGQuickActionsResultModel(
            type: .customImage(VFGFrameworkAsset.Image.icProductSwitcherError),
            delegate: self,
            titleText: "edit_account_quick_action_error_view_title".localized(bundle: .mva10Framework),
            descriptionText: String(format: description, arguments: [account.name]),
            primaryButtonTitle: "edit_account_name_back_button"
                .localized(bundle: .mva10Framework),
            titleFont: .vodafoneBold(24),
            descriptionFont: .vodafoneRegular(16)
        )
    }

    private func editAccountNameSuccessModel() -> VFGQuickActionsResultModel {
        let description = "edit_account_quick_action_success_view_description".localized(bundle: .mva10Framework)
        return VFGQuickActionsResultModel(
            type: .success,
            delegate: self,
            titleText: "edit_account_quick_action_success_view_title".localized(bundle: .mva10Framework),
            descriptionText: String(format: description, arguments: [account.name]),
            primaryButtonTitle: "edit_account_quick_action_success_view_button_title"
                .localized(bundle: .mva10Framework),
            titleFont: .vodafoneBold(24),
            descriptionFont: .vodafoneRegular(16)
        )
    }
}

extension VFGUpdateAccountManager: VFQuickActionsModel {
    public func quickActionsProtocol(delegate: VFQuickActionsProtocol) {
        quickActionDelegate = delegate
    }

    public func closeQuickAction() {
        quickActionDelegate?.closeQuickAction(completion: nil)
    }

    public var quickActionsContentView: UIView {
        state?.quickActionsContentView ?? UIView()
    }

    public var quickActionsTitle: String {
        state?.quickActionsTitle ?? ""
    }

    public var quickActionsStyle: VFQuickActionsStyle {
        state?.quickActionsStyle ?? .white
    }

    public var isCloseButtonHidden: Bool {
        state?.isCloseButtonHidden ?? false
    }

    public var shouldRaiseForKeyboard: Bool {
        state?.shouldRaiseForKeyboard ?? false
    }

    public var maximumHeightRatio: CGFloat {
        state?.maximumHeightRatio ?? self.resultViewHeightRatio
    }

    public var titleFont: UIFont {
        switch accountActionType {
        case .remove:
            return UIFont.vodafoneBold(24)
        default:
            return UIFont.vodafoneBold(16)
        }
    }
}

extension VFGUpdateAccountManager: VFGEditAccountNameViewDelegate {
    func saveButtonDidTap(withName name: String) {
        presentLoadingView(title: "edit_account_quick_action_loading_view_title".localized(bundle: .mva10Framework))
        let successStateModel = editAccountNameSuccessModel()
        let failureStateModel = editAccountNameFailureModel()
        manageAccountDelegate?.rename(account: account, newName: name) { [weak self] isSuccessEdit in
            self?.isActionSuccess = isSuccessEdit

            if isSuccessEdit {
                self?.presentSuccessView(successStateModel)
            } else {
                self?.presentFailureView(failureStateModel)
            }
        }
    }

    func backButtonDidTap() {
        quickActionDelegate?.closeQuickAction { [weak self] in
            self?.manageAccountDelegate?.representManageAccount()
        }
    }
}

extension VFGUpdateAccountManager: VFGRemoveAccountViewDelegate {
    func removeButtonDidPressed() {
        presentLoadingView(title: "remove_account_quick_action_loading_view_title".localized(bundle: .mva10Framework))
        let successStateModel = removeAccountSuccessModel()
        let failureStateModel = removeAccountFailureModel()
        manageAccountDelegate?.remove(account: account) { [weak self] isRemoved in
            self?.isActionSuccess = isRemoved

            if isRemoved {
                self?.presentSuccessView(successStateModel)
            } else {
                self?.presentFailureView(failureStateModel)
            }
        }
    }

    func backButtonDidPressed() {
        quickActionDelegate?.closeQuickAction { [weak self] in
            self?.manageAccountDelegate?.representManageAccount()
        }
    }
}

extension VFGUpdateAccountManager: VFGResultViewProtocol {
    public func resultViewPrimaryButtonAction() {
        switch isActionSuccess {
        case true:
            quickActionDelegate?.closeQuickAction { [weak self] in
                self?.manageAccountDelegate?.presentSwitchAccount(theme: .mva12)
            }
        default:
            presentActionView()
        }
    }

    public func quickActionsClose(isCloseButton: Bool) {
        quickActionDelegate?.closeQuickAction(completion: nil)
    }
}
