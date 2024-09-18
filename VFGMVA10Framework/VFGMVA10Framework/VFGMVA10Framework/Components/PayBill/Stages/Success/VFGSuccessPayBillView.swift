//
//  VFGSuccessPayBillView.swift
//  VFGMVA10Framework
//
//  Created by Atta Ahmed on 11/19/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import VFGMVA10Foundation
import Lottie

class VFGSuccessPayBillView: UIView {
    @IBOutlet weak var doneButton: VFGButton!
    @IBOutlet weak var payBillDescriptionLabel: VFGLabel!
    @IBOutlet weak var payBillLabel: VFGLabel!
    @IBOutlet weak var animationView: AnimationView!
    @IBAction func doneAction(_ sender: Any) {
        doneButtonPressed()
    }
    @objc func doneButtonPressed() {
        delegate?.finishPayBill()
    }
    func doneButtonVoiceOverAction() -> UIAccessibilityCustomAction {
        let actionName = doneButton.titleLabel?.text ?? ""
        return UIAccessibilityCustomAction(name: actionName, target: self, selector: #selector(doneButtonPressed))
    }
    weak var delegate: VFGPayBillStateInternalProtocol?

    func configure(with viewModel: VFGSuccessPayBillViewModel) {
        animationView.animation = Animation.tick
        animationView.play()
        payBillLabel.text = viewModel.sectionTitle
        payBillDescriptionLabel.text = viewModel.subTitle
        doneButton.setTitle(viewModel.buttonTitle, for: .normal)
        doneButton.accessibilityIdentifier = "PB\(viewModel.buttonTitle.lowercased())Button"
        setAccessibilityForVoiceOver()
    }

    func setAccessibilityForVoiceOver() {
        animationView.accessibilityLabel = "Check mark animated view"
        payBillLabel.accessibilityLabel = payBillLabel.text ?? ""
        payBillDescriptionLabel.accessibilityLabel = payBillDescriptionLabel.text ?? ""
        doneButton.accessibilityLabel = doneButton.titleLabel?.text ?? ""
        accessibilityCustomActions = [doneButtonVoiceOverAction()]
    }
}
