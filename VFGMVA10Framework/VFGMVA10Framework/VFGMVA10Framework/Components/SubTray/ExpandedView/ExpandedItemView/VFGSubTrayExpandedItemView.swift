//
//  VFGSubTrayExpandedItemView.swift
//  VFGMVA10Framework
//
//  Created by Mohamed Abd ElNasser on 21/10/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import VFGMVA10Foundation
/// Sub tray expanded view collection view cell container item view
class VFGSubTrayExpandedItemView: UIView {
    @IBOutlet weak var titleLabel: VFGLabel!
    @IBOutlet weak var descriptionLabel: VFGLabel!
    /// Delegation protocol for sub tray expanded view actions
    weak var delegate: VFGSubTrayExpandedItemDelegate?
    /// Sub tray expanded view item model
    var model: VFGSubTrayExpandedItemModel

    required init?(coder: NSCoder) {
        model = VFGSubTrayExpandedItemModel()
        super.init(coder: coder)

        initializationSetup()
    }

    private func initializationSetup() {
        guard let contentView = loadViewFromNib(nibName: className) else {
            return
        }

        xibSetup(contentView: contentView)
        setupFonts()
        updateOutlineUnselected()
        roundCorners()
    }
    /// *VFGSubTrayExpandedItemView* labels font setup
    func setupFonts() {
        titleLabel.font = .vodafoneRegular(18.7)
        descriptionLabel.font = .vodafoneRegular(14.6)
    }
    /// *VFGSubTrayExpandedItemView* configuration
    /// - Parameters:
    ///    - model: Sub tray expanded view item model
    ///    - delegate: Delegation protocol for sub tray expanded view actions
    func configure(model: VFGSubTrayExpandedItemModel, delegate: VFGSubTrayExpandedItemDelegate?) {
        titleLabel.text = model.title
        descriptionLabel.text = model.description
        self.delegate = delegate
        self.model = model
    }
    /// Update layer for selected sub tray expanded view collection view cell container item view
    func updateOutlineSelected() {
        layer.borderWidth = 2
        layer.borderColor = UIColor.VFGActiveSelectionOutline.cgColor
    }
    /// Update layer for unselected sub tray expanded view collection view cell container item view
    func updateOutlineUnselected() {
        layer.borderWidth = 1
        layer.borderColor = UIColor.VFGDefaultSelectionOutline.cgColor
    }

    @IBAction func itemDidPress(_ sender: VFGButton) {
        delegate?.itemDidPress(self, model)
    }
}
