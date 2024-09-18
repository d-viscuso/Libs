//
//  DashboradUsageShimmerdCard.swift
//  VFGMVA10Framework
//
//  Created by Atta Amed on 1/27/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation
import VFGMVA10Foundation
/// Dashboard usage card shimmer entry
public class DashboradUsageShimmerdCard: NSObject, VFGComponentEntry {
    public required init(config: [String: Any]?, error: [String: Any]?) {}

    public lazy var cardView: UIView? = UsageShimmerdCard()

    public var cardEntryViewController: UIViewController? {
        return nil
    }
}
