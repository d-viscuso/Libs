//
//  VFGScrollableCardShimmerdCard.swift
//  VFGMVA10Framework
//
//  Created by Ahmed AbdElnabi on 29/09/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import Foundation
import VFGMVA10Foundation
/// Dashboard fourth card shimmer entry
public class VFGScrollableCardShimmerdCard: NSObject, VFGComponentEntry {
    public required init(config: [String: Any]?, error: [String: Any]?) {}

    public lazy var cardView: UIView? = {
        let model = ScrollableCardModel()
        let viewModel = ScrollableCardViewModel(with: model)
        let view = ScrollableCardView(with: viewModel)
        view.state = .loading
        return view
    }()

    public var cardEntryViewController: UIViewController? {
        return nil
    }
}
