//
//  AppointmentRequirementsView.swift
//  VFGMVA10Framework
//
//  Created by Mohamed Abd ElNasser on 17/01/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import Foundation
import VFGMVA10Foundation
import UIKit

class AppointmentRequirementsView: UIView {
    @IBOutlet weak var iconImageView: VFGImageView!
    @IBOutlet weak var titleLabel: VFGLabel!
    @IBOutlet weak var requirementsStackView: UIStackView!

    init() {
        super.init(frame: CGRect.zero)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        commonInit()
    }

    private func commonInit() {
        guard let contentView = self.loadViewFromNib(nibName: className, in: .mva10Framework) else {
            return
        }

        xibSetup(contentView: contentView)
        configureUI()
    }

    func configureUI() {
        layer.borderWidth = 1
        layer.borderColor = UIColor.VFGGreyDividerOne.cgColor
        configureShadow()
        setupFonts()
    }

    func setupFonts() {
        titleLabel.font = .vodafoneBold(15)
    }

    func setup(with requirements: [String]) {
        requirementsStackView.removeAllArrangedSubviews()

        titleLabel.text = "book_appointments_requirements_card_title".localized( bundle: .mva10Framework)
        requirements.forEach { requirement in
            let label = VFGLabel()
            label.numberOfLines = 0
            label.setContentHuggingPriority(.defaultHigh, for: .vertical)
            label.font = .vodafoneRegular(15)
            label.textColor = .VFGPrimaryText
            label.text = requirement

            requirementsStackView.addArrangedSubview(label)
        }
    }
}
