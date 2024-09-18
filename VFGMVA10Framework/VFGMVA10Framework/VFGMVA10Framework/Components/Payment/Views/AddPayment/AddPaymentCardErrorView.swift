//
//  AddPaymentCardErrorView.swift
//  VFGMVA10Framework
//
//  Created by Yahya Saddiq on 9/24/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//
import VFGMVA10Foundation

class AddPaymentCardErrorView: VFQuickActionsModel {
    var error: AddPaymentErrorModel
    weak var quickActionsDelegate: VFQuickActionsProtocol?
    weak var delegate: AddPaymentErrorDelegate?

    public var quickActionsTitle: String { "" }
    public var quickActionsStyle: VFQuickActionsStyle {
        return .white
    }
    var isUserInteractionEnabled: Bool { true }

    public init(error: AddPaymentErrorModel) {
        self.error = error
    }

    public var quickActionsContentView: UIView {
        guard let errorView: VFGInfoConfirmationAlert = UIView.loadXib(bundle: Bundle.foundation) else {
            return UIView()
        }
        errorView.delegate = self
        configureErrorView(errorView)
        return errorView
    }

    func configureErrorView(_ errorView: VFGInfoConfirmationAlert) {
        errorView.model =
            VFGInfoConfirmationAlertModel(
                infoIcon: UIImage.VFGWarning.medium,
                infoIconSize: CGSize(width: 50, height: 50),
                infoQuestion: error.title,
                infoAnswer: error.desc,
                confirmButtonTitle: error.buttonTitle)
    }

    public func quickActionsProtocol(delegate: VFQuickActionsProtocol) {
        self.quickActionsDelegate = delegate
    }

    public func closeQuickAction() {
        disableActionButton()
        quickActionsDelegate?.closeQuickAction(completion: nil)
    }

    private func disableActionButton() {
        if !error.shouldRetryAction {
            self.delegate?.disableActionButton()
        }
    }
}

extension AddPaymentCardErrorView: VFGInfoConfirmationAlertDelegate {
    func confirmActionPressed(completion: (() -> Void)?) {
        disableActionButton()
        quickActionsDelegate?.closeQuickAction { [weak self] in
            guard let self = self else { return }
            if self.error.shouldRetryAction {
                self.delegate?.retryAddCard()
            }
        }
    }
}

protocol AddPaymentErrorDelegate: NSObjectProtocol {
    func retryAddCard()
    func disableActionButton()
}
