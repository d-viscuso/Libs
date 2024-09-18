//
//  DeleteAddressView.swift
//  lottie-ios
//
//  Created by Ahmed Ramzy on 16/01/2022.
//

import VFGMVA10Foundation

class VFGDeleteAddressView: VFQuickActionsModel {
    var quickActionsTitle = "delete_address_quick_action_header".localized(bundle: .mva10Framework)
    var quickActionsStyle: VFQuickActionsStyle = .white
    var quickActionsContentView: UIView {
        guard let blockingView: VFGTwoActionsView = UIView.loadXib(bundle: .foundation) else {
            return UIView()
        }
        blockingView.delegate = self // To handle buttons actions
        configureBlockingView(blockingView: blockingView)
        return blockingView
    }
    weak var twoActionsDelegate: VFGTwoActionsViewProtocol?
    weak var delegate: VFQuickActionsProtocol?
    weak var delegateDeleteAddress: VFGDeleteAddressProtocol?
    public weak var delegateListAddress: VFGListAddressProtocol?
    lazy var loadingLogoView: VFGLoadingLogoView? = VFGLoadingLogoView.loadXib(bundle: .foundation)
    func quickActionsProtocol(delegate: VFQuickActionsProtocol) {
        self.delegate = delegate
    }

    func closeQuickAction() {
        delegate?.closeQuickAction(completion: nil)
    }

    func configureBlockingView(blockingView: VFGTwoActionsView) {
        let primaryButtonTitle = "delete_address_quick_action_confirm_button_text".localized(bundle: .mva10Framework)
        let secondaryButtonTitle = "delete_address_quick_action_cancel_button_text".localized(bundle: .mva10Framework)
        let titlesModel = VFGTitlesModel(
            title: nil,
            description: "delete_address_quick_action_title".localized(bundle: .mva10Framework),
            descriptionAttributedString: nil,
            moreDetails: "delete_address_quick_action_subtitle".localized(bundle: .mva10Framework),
            primaryButtonTitle: primaryButtonTitle,
            secondaryButtonTitle: secondaryButtonTitle)
        let titlesFont = VFGTitlesFontModel(
            descriptionFont: .vodafoneLite(25),
            moreDetailsFont: .vodafoneRegular(15))
        let accessibilityIDsModel = VFGTwoActionsAccessibilityModel(
            title: "deleteAddressTitle",
            primaryButton: "confirmDeleteAddressButton",
            secondaryButton: "cancelDeleteAddressButton")
        let textAlignment: NSTextAlignment = VFGContentManager.shared.languageIdentifier == "ar" ? .right : .left
        let alignmentModel = VFGTitlesAlignmentModel(
            titleAlignment: .natural,
            descriptionAlignment: textAlignment,
            moreDetailsAlignment: textAlignment
        )
        blockingView.configure(
            viewStyle: .white,
            titlesModel: titlesModel,
            titlesFontModel: titlesFont,
            titlesAlignmentModel: alignmentModel,
            accessibilityIDsModel: accessibilityIDsModel)
    }
}

extension VFGDeleteAddressView: VFGTwoActionsViewProtocol {
    func primaryButtonAction() {
        toggleLoadingVisibility(true)
        delegateDeleteAddress?.didTapDeleteAddressConfirmButton { [weak self] isCompleted in
            guard let self = self else { return }
            self.delegate?.closeQuickAction {
                isCompleted ? self.delegateListAddress?.showSuccessView() : self.delegateListAddress?.showErrorView()
            }
            self.toggleLoadingVisibility(false)
        }
    }
    func secondaryButtonAction() {
        delegate?.closeQuickAction(completion: nil)
    }
    func toggleLoadingVisibility(_ state: Bool) {
        if state {
            guard let topView = UIApplication.topViewController()?.view else {
                return
            }
            loadingLogoView?.configure(
                style: .white,
                view: topView,
                backgroundColor: UIColor.black.withAlphaComponent(0.6)
            )
            loadingLogoView?.startLoading()
        } else {
            loadingLogoView?.endLoading()
        }
    }
}
