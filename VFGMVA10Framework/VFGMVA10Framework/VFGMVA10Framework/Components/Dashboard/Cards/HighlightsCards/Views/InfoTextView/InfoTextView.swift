//
//  InfoTextView.swift
//  VFGMVA10Framework
//
//  Created by Adel Aref on 30/08/2022.
//

import UIKit
import VFGMVA10Foundation
class InfoTextView: UIView {
    // MARK: - IBOutlet
    @IBOutlet weak var textLabel: VFGLabel!

    func configure(with text: String?) {
        textLabel.text = text
    }

    func setupLabelsTextColor(with fontColor: HighlightCardModel.FontColor? = .dark) {
        switch fontColor {
        case .light:
            textLabel.textColor = .VFGWhiteText
        default:
            textLabel.textColor = .VFGPrimaryText
        }
    }

    static func create() -> InfoTextView? {
        guard let view: InfoTextView = UIView.loadXib(bundle: . mva10Framework) else {
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
