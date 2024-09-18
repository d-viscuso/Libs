//
//  VFGAutoBillFailureView.swift
//  VFGMVA10Framework
//
//  Created by Hussein Kishk on 31/01/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import VFGMVA10Foundation
/// Auto bill failure state quick action view
class VFGAutoBillFailureView: UIView {
    @IBOutlet weak var tryAgainButton: VFGButton!
    @IBOutlet weak var failureMainTitle: VFGLabel!
    @IBOutlet weak var failureSubTitle: VFGLabel!
    @IBOutlet weak var failureImageView: VFGImageView!
    /// Payment method card
    var card: PaymentModelProtocol?
    /// Bill value to pay
    var billAmount: Double?
    /// An instance of *VFGAutoBillStateInternalProtocol*
    weak var delegate: VFGAutoBillStateInternalProtocol?
    /// *VFGAutoBillFailureView* configuration
    /// - Parameters:
    ///    - viewModel: *VFGAutoBillFailureView* view model data
    func configure(with viewModel: VFGAutoBillFailureViewModel) {
        failureMainTitle.text = viewModel.sectionTitle
        failureSubTitle.text = viewModel.subTitle
        tryAgainButton.setTitle(viewModel.buttonTitle, for: .normal)
        setAccessibilityForVoiceOver()
    }

    func setAccessibilityForVoiceOver() {
        failureImageView.accessibilityLabel = "Failure warning view"
        failureMainTitle.accessibilityLabel = failureMainTitle.text ?? ""
        failureSubTitle.accessibilityLabel = failureSubTitle.text ?? ""
        tryAgainButton.accessibilityLabel = tryAgainButton.titleLabel?.text ?? ""
        accessibilityCustomActions = [tryAgainVoiceOverAction()]
    }

    @IBAction func tryAgainButtonDidPress(_ sender: Any) {
        tryAgainButtonPressed()
    }
    @objc func tryAgainButtonPressed() {
        delegate?.tryAgain()
    }
    func tryAgainVoiceOverAction() -> UIAccessibilityCustomAction {
        let actionName = tryAgainButton.titleLabel?.text ?? ""
        return UIAccessibilityCustomAction(name: actionName, target: self, selector: #selector(tryAgainButtonPressed))
    }
}
