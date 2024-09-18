//
//  VFGDeviceMoreInfoHeaderView.swift
//  VFGMVA10Framework
//
//  Created by SAMEH on 22/05/2021.
//

import UIKit
import VFGMVA10Foundation

class VFGDeviceMoreInfoHeaderView: UIView {
    // MARK: - Outlets
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var titleLabel: VFGLabel!

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
        setupUI()
    }
}

extension VFGDeviceMoreInfoHeaderView {
    func setupUI() {
        setupTitleLabel()
        titleLabel.accessibilityIdentifier = "DMoreInfoHeaderTitleID"
    }

    private func setupTitleLabel() {
        titleLabel.text = "device_upgrade_device_step_more_information".localized(bundle: .mva10Framework)
    }
}
