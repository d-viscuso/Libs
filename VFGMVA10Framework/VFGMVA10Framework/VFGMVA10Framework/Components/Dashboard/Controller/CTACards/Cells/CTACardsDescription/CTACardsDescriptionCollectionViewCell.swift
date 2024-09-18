//
//  CTACardsDescriptionCollectionViewCell.swift
//  VFGMVA10Framework
//
//  Created by İhsan Kahramanoğlu on 1/17/23.
//  Copyright © 2023 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

class CTACardsDescriptionCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var descriptionLabel: VFGLabel!

    func config(description: String?) {
        descriptionLabel.text = description
    }

    static func getCellSize(for description: String?, spacing: CGFloat) -> CGSize {
        guard let text = description else { return .zero }
        let fontAttributes = [NSAttributedString.Key.font: UIFont.vodafoneRegular(18)]
        let size = text.size(withAttributes: fontAttributes)
        return CGSize(width: UIScreen.main.bounds.width, height: (size.height * 4.5) + spacing)
    }
}
