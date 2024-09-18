//
//  HighlightsCardsViewModel.swift
//  Airship
//
//  Created by Adel Aref on 29/08/2022.
//

import Foundation
import UIKit
import VFGMVA10Foundation

/// Highlights Cards ViewModel
///
public class HighlightsCardsViewModel {
    let model: HighlightCardModel

    /// init HighlightsCardsViewModel
    public init(with model: HighlightCardModel) {
        self.model = model
    }

    /// highlight alert status color
    var alertStatusColor: UIColor? {
        switch model.alertStatus {
        case .green:
            return .VFGAlertPositive
        case .orange:
            return .VFGAlertNeutral
        case .grey:
            return .VFGPageControlTint
        case .red:
            return .VFGRedOrangeTextMva12
        default:
            return nil
        }
    }

    /// highlight center view
    var centerView: UIView? {
        switch model.centerViewType {
        case .largeText(let text):
            let view = LargeTextView.create()
            view?.setupLabelsTextColor(with: model.fontColorType)
            view?.configure(with: text)
            return view
        case let .attributedText(large, small):
            let view = AttributedTextView.create()
            view?.setupLabelsTextColor(with: model.fontColorType)
            view?.configure(with: large, and: small)
            return view
        case .infoText(let text):
            let view = InfoTextView.create()
            view?.setupLabelsTextColor(with: model.fontColorType)
            view?.configure(with: text)
            return view
        case let .progress(text, current, max):
            let view = ProgressTextView.create()
            view?.setupLabelsTextColor(with: model.fontColorType)
            view?.configure(text: text, current: current, max: max)
            return view
        default:
            return UIView()
        }
    }
}
