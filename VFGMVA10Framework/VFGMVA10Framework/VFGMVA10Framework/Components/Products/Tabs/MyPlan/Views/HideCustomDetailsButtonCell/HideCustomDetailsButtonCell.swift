//
//  HideCustomDetailsButtonCell.swift
//  VFGMVA10Framework
//
//  Created by Amr Koritem on 06/14/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

class HideCustomDetailsButtonCell: UITableViewCell {
    @IBOutlet weak var hideDetailsButton: VFGButton!

    var hideDetailsActionHandler: (() -> Void)?

    @IBAction func hideDetailsAction(_ sender: Any) {
        hideDetailsActionHandler?()
    }

    func configure(with title: String?, andHandler handler: (() -> Void)?) {
        hideDetailsButton.setTitle(title, for: .normal)
        hideDetailsActionHandler = handler
    }
}
