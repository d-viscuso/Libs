//
//  LargeTextView.swift
//  VFGMVA10Framework
//
//  Created by Adel Aref on 29/08/2022.
//

import UIKit
import VFGMVA10Foundation

class LargeTextView: UIView {
    // MARK: - IBOutlet
    @IBOutlet weak var titleLabel: VFGLabel!

    func configure(with text: String?) {
        titleLabel.text = text
    }

    func setupLabelsTextColor(with fontColor: HighlightCardModel.FontColor? = .dark) {
        switch fontColor {
        case .light:
            titleLabel.textColor = .VFGWhiteText
        default:
            titleLabel.textColor = .VFGPrimaryText
        }
    }

    static func create() -> LargeTextView? {
        guard let view: LargeTextView = UIView.loadXib(bundle: . mva10Framework) else {
            return nil
        }
        view.backgroundColor = .clear
        view.frame = CGRect.init(
            x: 0,
            y: 0,
            width: view.frame.size.width,
            height: view.frame.size.height
        )
        return view
    }
}
