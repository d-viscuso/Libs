//
//  AmountCell.swift
//  VFGMVA10Framework
//
//  Created by Hamsa Hassan on 7/1/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

public class AmountCell: UICollectionViewCell {
    @IBOutlet weak var amountLabel: VFGLabel!
    @IBOutlet weak var amountValueLabel: VFGLabel!

    func setupCell(with dataBundle: VFGDataBundle, currency: String?, isRecurring: Bool) {
        amountLabel.text = "\(dataBundle.bundleAmount ?? 0)\(dataBundle.dataUnit ?? "")"
        if !isRecurring {
            amountValueLabel.text = "\(dataBundle.bundlePrice ?? 0)\(currency ?? "")"
        } else {
            amountValueLabel.text = "\(dataBundle.bundlePrice ?? 0)\(currency ?? "") /month"
        }
    }

    public override var isAccessibilityElement: Bool {
        get { true }
        set { }
    }

    public override var accessibilityLabel: String? {
        get { (amountLabel.text ?? "") + " costs " + (amountValueLabel.text ?? "") }
        set { }
    }
}
