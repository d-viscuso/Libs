//
//  VFGConfirmationView.swift
//  VFGMVA10Framework
//
//  Created by AbdallahShaheen on 23/12/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

protocol VFGConfirmationViewDelegate: AnyObject {
    func closeButtonDidPressed()
    func primaryButtonDidPressed()
    func secondaryButtonDidPressed()
}

class VFGConfirmationView: UIView {
    @IBOutlet weak var titleLabel: VFGLabel!
    @IBOutlet weak var descriptionLabel: VFGLabel!
    @IBOutlet weak var primaryButton: VFGButton!
    @IBOutlet weak var secondaryButton: VFGButton!

    weak var delegate: VFGConfirmationViewDelegate?

    func setup(with model: VFGConfirmationViewModel, and delegate: VFGConfirmationViewDelegate? = nil) {
        titleLabel.text = model.title
        descriptionLabel.text = model.description
        primaryButton.setTitle(model.primaryButtonTitle, for: .normal)
        secondaryButton.setTitle(model.secondaryButtonTitle, for: .normal)
        self.delegate = delegate
        roundCorners([.layerMinXMinYCorner, .layerMaxXMinYCorner])
        dropShadow(color: .black)
    }

    @IBAction func closeButtonDidPressed(_ sender: Any) {
        delegate?.closeButtonDidPressed()
    }

    @IBAction func primaryButtonDidPressed(_ sender: Any) {
        delegate?.primaryButtonDidPressed()
    }

    @IBAction func secondaryButtonDidPressed(_ sender: Any) {
        delegate?.secondaryButtonDidPressed()
    }
}
