//
//  DashboardThirdShimmerdCard.swift
//  VFGMVA10Framework
//
//  Created by Atta Amed on 1/27/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation
import VFGMVA10Foundation
/// Dashboard third card shimmer entry
public class DashboardThirdShimmerdCard: NSObject, VFGComponentEntry {
    public required init(config: [String: Any]?, error: [String: Any]?) {}

    public lazy var cardView: UIView? = OfferShimmerdCard()

    public var cardEntryViewController: UIViewController? {
        return nil
    }
}
