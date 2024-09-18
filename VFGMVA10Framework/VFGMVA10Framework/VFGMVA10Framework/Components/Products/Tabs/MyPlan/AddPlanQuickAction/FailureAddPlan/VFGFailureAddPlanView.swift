//
//  VFGFailureAddPlanView.swift
//  VFGMVA10Framework
//
//  Created by Hamsa Hassan on 7/28/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

class VFGFailureAddPlanView: UIView {
    @IBOutlet weak var tryAgainButton: VFGButton!
    @IBOutlet weak var failureMainTitle: VFGLabel!
    @IBOutlet weak var failureSubTitle: VFGLabel!
    @IBOutlet weak var cancelButton: VFGButton!
    @IBOutlet weak var cancelButtonHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var cancelButtomBottomContraint: NSLayoutConstraint!

    weak var delegate: VFGAddPlanStateInternalProtocol?

    func configure(with titles: VFGFailureAddPlanModel?) {
        failureMainTitle.text = titles?.mainTitle
        failureSubTitle.text = titles?.subTitle
        tryAgainButton.setTitle(titles?.tryAgainButtonTitle, for: .normal)
        if let cancelButtonTitle = titles?.cancelButtonTitle {
            cancelButton.setTitle(
                cancelButtonTitle,
                for: .normal)
        } else {
            cancelButtonHeightConstraint.constant = 0
            cancelButtomBottomContraint.constant = 0
            cancelButton.isHidden = true
        }
    }

    @IBAction func cancelButtonTapped(_ sender: Any) {
        delegate?.dismissQuickAction()
    }

    @IBAction func tryAgainTapped(_ sender: Any) {
        delegate?.failureViewFinished()
    }
}
