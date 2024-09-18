//
//  ProgressTextView.swift
//  VFGMVA10Framework
//
//  Created by Adel Aref on 27/08/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

class ProgressTextView: UIView {
    // MARK: - IBOutlet
    @IBOutlet weak var progressBar: UIView!
    @IBOutlet weak var textLabel: VFGLabel!

    func configure(text: String?, current: Float?, max: Float?) {
        textLabel.text = text

        if let current = current, let max = max {
            let percentages = calculateProgressRatio(with: current, and: max)
            let colors: [UIColor] = [.VFGRedProgressBar, .white, .VFGAluminiumProgressBar]
            progressBar.fillProgressBarColors(colors, withPercentage: percentages)
        }
    }

    func calculateProgressRatio(with current: Float?, and max: Float?) -> [Float] {
        if let current = current, let max = max {
            let ratioPercentage = round((current / max) * 100)
            let grayColorPercent = 100.0 - (ratioPercentage + 1.0)
            return [ratioPercentage, 1.0, grayColorPercent]
        }
        return []
    }

    func setupLabelsTextColor(with fontColor: HighlightCardModel.FontColor? = .dark) {
        switch fontColor {
        case .light:
            textLabel.textColor = .VFGWhiteText
        default:
            textLabel.textColor = .VFGPrimaryText
        }
    }

    static func create() -> ProgressTextView? {
        guard let view: ProgressTextView = UIView.loadXib(bundle: . mva10Framework) else {
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
