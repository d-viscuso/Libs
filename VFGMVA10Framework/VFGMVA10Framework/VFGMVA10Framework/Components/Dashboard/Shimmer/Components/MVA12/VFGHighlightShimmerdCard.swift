//
//  VFGHighlightShimmerdCard.swift
//  VFGMVA10Framework
//
//  Created by Ahmed AbdElnabi on 23/09/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import Foundation
import VFGMVA10Foundation
/// Dashboard fourth card shimmer entry
public class VFGHighlightShimmerdCard: NSObject, VFGComponentEntry {
    public required init(config: [String: Any]?, error: [String: Any]?) {}

    public lazy var cardView: UIView? = HighlightShimmerCardView()

    public var cardEntryViewController: UIViewController? {
        return nil
    }
}
