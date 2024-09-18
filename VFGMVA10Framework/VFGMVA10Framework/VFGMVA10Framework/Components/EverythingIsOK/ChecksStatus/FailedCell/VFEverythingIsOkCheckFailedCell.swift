//
//  VFEverythingIsOkCheckFailedCell.swift
//  VFGMVA10Group
//
//  Created by Sandra Morcos on 3/19/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

protocol EIOCellProtocol {
    static var isClicked: Bool { get set }
}
class VFEverythingIsOkCheckFailedCell: UITableViewCell, EIOCellProtocol {
    @IBOutlet weak var icon: VFGImageView!
    @IBOutlet weak var titleLabel: VFGLabel!
    @IBOutlet weak var descriptionLabel: VFGLabel!
    @IBOutlet weak var refreshButton: VFGButton!
    var refreshActionClosure: (() -> Void)? {
        didSet {
            accessibilityCustomActions?.append(refreshButtonVoiceOverAction())
        }
    }
    static var isClicked = false

    @IBOutlet weak var failureDetailsView: UIView!
    @IBAction func refreshClicked(_ sender: VFGButton) {
        refreshAction()
    }

    @objc func refreshAction() {
        refreshActionClosure?()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        viewAppearance(type: VFEverythingIsOkCheckFailedCell.self, duration: 0.2, delay: 0.3)
    }
}

extension VFEverythingIsOkCheckFailedCell {
    func refreshButtonVoiceOverAction() -> UIAccessibilityCustomAction {
        let actionName = "refresh service action"
        return UIAccessibilityCustomAction(
            name: actionName,
            target: self,
            selector: #selector(refreshAction)
        )
    }
}
