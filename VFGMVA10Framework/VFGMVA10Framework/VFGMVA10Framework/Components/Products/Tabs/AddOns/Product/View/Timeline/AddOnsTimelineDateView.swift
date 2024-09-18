//
//  AddOnsTimelineDateView.swift
//  VFGMVA10Framework
//
//  Created by Esraa Eldaltony on 7/5/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

class AddOnsTimelineDateView: UIView {
    @IBOutlet weak var datelabel: VFGLabel!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var circleView: UIView!
    var date: String?

    func setupView(isToday: Bool) {
        if isToday {
            datelabel.text = "addons_timeline_today".localized(bundle: Bundle.mva10Framework)
            datelabel.textColor = .VFGTimelineCellActive
            lineView.backgroundColor = .VFGTimelineCellActive
            circleView.backgroundColor = .VFGTimelineCellActive
        } else {
            datelabel.textColor = .VFGSecondaryText
            lineView.backgroundColor = .VFGTimelineSeparator
            circleView.backgroundColor = .VFGTimelineSeparator
        }
        setupAccessibilityLabels()
    }

    func setupAccessibilityLabels() {
        datelabel.accessibilityLabel = datelabel.text ?? ""
    }
}
