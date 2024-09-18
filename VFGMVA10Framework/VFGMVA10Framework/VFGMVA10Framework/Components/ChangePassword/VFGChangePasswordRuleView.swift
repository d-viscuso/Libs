//
//  VFGChangePasswordRuleView.swift
//  VFGMVA10Framework
//
//  Created by Fafoutis, Athinodoros, Vodafone Greece on 08/12/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

final class VFGChangePasswordRuleView: UIView {
    let tickIcon: UIImageView
    let ruleDescription: VFGLabel
    let rule: NewPasswordRule

    init(with rule: NewPasswordRule) {
        self.rule = rule
        tickIcon = UIImageView()
        ruleDescription = VFGLabel()
        super.init(frame: .zero)
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupUI() {
        tickIcon.translatesAutoresizingMaskIntoConstraints = false
        tickIcon.image = VFGFrameworkAsset.Image.icTickGraySmall
        addSubview(tickIcon)
        ruleDescription.translatesAutoresizingMaskIntoConstraints = false
        ruleDescription.text = rule.description
        ruleDescription.numberOfLines = 0
        ruleDescription.font = .vodafoneRegular(14)
        ruleDescription.textColor = .VFGUnselectedText

        if UIApplication.isRightToLeft {
            ruleDescription.semanticContentAttribute = .forceRightToLeft
        } else {
            ruleDescription.semanticContentAttribute = .forceLeftToRight
        }
        addSubview(ruleDescription)

        NSLayoutConstraint.activate([
            tickIcon.heightAnchor.constraint(equalToConstant: 18),
            tickIcon.widthAnchor.constraint(equalToConstant: 18),
            tickIcon.leadingAnchor.constraint(equalTo: leadingAnchor),
            tickIcon.topAnchor.constraint(greaterThanOrEqualTo: topAnchor),
            tickIcon.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor),
            ruleDescription.trailingAnchor.constraint(equalTo: trailingAnchor),
            ruleDescription.leadingAnchor.constraint(equalTo: tickIcon.trailingAnchor, constant: 8),
            ruleDescription.topAnchor.constraint(greaterThanOrEqualTo: topAnchor),
            ruleDescription.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor),
            ruleDescription.centerYAnchor.constraint(equalTo: tickIcon.centerYAnchor)
        ])
    }

    func toggle(_ isValid: Bool) {
        tickIcon.image = isValid
            ? VFGFrameworkAsset.Image.icTickGreenSmall
        : VFGFrameworkAsset.Image.icTickGraySmall
        ruleDescription.textColor = isValid ? .VFGSecondaryText : .VFGUnselectedText
    }
}
