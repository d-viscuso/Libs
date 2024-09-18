//
//  VFGDeviceExpandableSectionHeaderView.swift
//  VFGMVA10Framework
//
//  Created by SAMEH on 20/05/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

class VFGDeviceExpandableSectionHeaderView: UIView {
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var titleLabel: VFGLabel!
    @IBOutlet weak var optionLogoImageView: VFGImageView!
    @IBOutlet weak var chevronImageView: VFGImageView!

    let expandImageViewAnimationDuration = 0.7
    var expandableSectionDidPress: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        load()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        load()
    }

    private func load() {
        Bundle.mva10Framework.loadNibNamed(className, owner: self, options: nil)
        guard let contentView = contentView else { return }
        contentView.frame = self.bounds
        addSubview(contentView)
        addTapGestureToContentView()
    }

    private func setupAccessibilityLabels() {
        [titleLabel, optionLogoImageView, chevronImageView, self]
            .forEach { $0?.isAccessibilityElement = false }
        contentView.isAccessibilityElement = true
        contentView.accessibilityLabel = titleLabel.text
    }
}

extension VFGDeviceExpandableSectionHeaderView {
    func updateUI(with sectionModel: VFGDeviceSectionHeaderUIModel) {
        titleLabel.text = sectionModel.title
        optionLogoImageView.image = UIImage(named: sectionModel.logo, in: .mva10Framework)
        if !sectionModel.isCellsCollapsed {
            rotateChevronImageView(animated: false)
        }
        setupAccessibilityLabels()
    }

    func rotateChevronImageView(animated: Bool) {
        let animationDuration = animated ? expandImageViewAnimationDuration : 0
        UIView.animate(withDuration: animationDuration) { [weak self] in
            guard let self = self
                else { return }
            self.chevronImageView.transform = self.chevronImageView.transform.rotated(by: .pi)
        }
    }
}

extension VFGDeviceExpandableSectionHeaderView {
    private func addTapGestureToContentView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleContentViewDidPress))
        contentView.addGestureRecognizer(tap)
    }
}

extension VFGDeviceExpandableSectionHeaderView {
    @objc func handleContentViewDidPress() {
        expandableSectionDidPress?()
        rotateChevronImageView(animated: true)
    }
}
