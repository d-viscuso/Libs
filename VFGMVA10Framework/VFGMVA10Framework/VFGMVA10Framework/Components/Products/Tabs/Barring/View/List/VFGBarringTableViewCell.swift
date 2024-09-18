//
//  VFGBarringTableViewCell.swift
//  VFGMVA10Framework
//
//  Created by Trachani, Vasiliki, Vodafone on 17/5/22.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

/// Barring table view cell protocol.
protocol VFGBarringTableViewCellProtocol: AnyObject {
    /// Responsible for handling the result of pressing the toggle button
    /// - Parameters:
    ///    - indexPath: Current indexPath
    func didPressToggle(for indexPath: IndexPath)
}

/// Barring list tableview cell.
class VFGBarringTableViewCell: UITableViewCell {
    // MARK: Outlets
    @IBOutlet weak var titleLabel: VFGLabel!
    @IBOutlet weak var descriptionLabel: VFGLabel!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var toggleButton: VFGButton!

    weak var delegate: VFGBarringTableViewCellProtocol?
    var indexPath: IndexPath?
    /// Boolean to indicate if toggle is on or off
    var buttonToggledOn = true {
        didSet {
            if buttonToggledOn {
                toggleButton.setImage(
                    UIImage.VFGToggle.Medium.active,
                    for: .normal)
            } else {
                toggleButton.setImage(
                    UIImage.VFGToggle.Medium.inactive,
                    for: .normal)
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    // MARK: Setup
    public func setup(
        with model: VFGBarringItemViewModel,
        indexPath: IndexPath,
        delegate: VFGBarringTableViewCellProtocol? = nil,
        isLastCell: Bool
    ) {
        self.indexPath = indexPath
        self.delegate = delegate
        titleLabel.text = model.title
        descriptionLabel.text = model.description
        buttonToggledOn = model.toggleState
        separatorView.isHidden = isLastCell
    }

    // MARK: Actions
    @IBAction func toggleButtonPressed(_ sender: Any) {
        guard let indexPath = indexPath else { return }
        delegate?.didPressToggle(for: indexPath)
    }
}
