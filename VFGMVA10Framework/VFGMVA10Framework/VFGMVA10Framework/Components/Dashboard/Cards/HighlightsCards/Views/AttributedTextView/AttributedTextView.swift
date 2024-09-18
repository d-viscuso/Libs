//
//  AttributedTextView.swift
//  VFGMVA10Framework
//
//  Created by Adel Aref on 30/08/2022.
//

import UIKit
import VFGMVA10Foundation

class AttributedTextView: UIView {
    // MARK: - IBOutlet
    @IBOutlet weak var smallLabel: VFGLabel!
    @IBOutlet weak var largeLabel: VFGLabel!

    func configure(with large: String?, and small: String?) {
        smallLabel.text = small
        largeLabel.text = large
    }

    func setupLabelsTextColor(with fontColor: HighlightCardModel.FontColor? = .dark) {
        switch fontColor {
        case .light:
            smallLabel.textColor = .VFGWhiteText
            largeLabel.textColor = .VFGWhiteText
            self.backgroundColor = .clear
        default:
            smallLabel.textColor = .VFGPrimaryText
            largeLabel.textColor = .VFGPrimaryText
        }
    }

    static func create() -> AttributedTextView? {
        guard let view: AttributedTextView = UIView.loadXib(bundle: . mva10Framework) else {
            return nil
        }
        view.frame = CGRect.init(
            x: 0,
            y: 0,
            width: view.frame.size.width,
            height: view.frame.size.height
        )
        return view
    }
}
