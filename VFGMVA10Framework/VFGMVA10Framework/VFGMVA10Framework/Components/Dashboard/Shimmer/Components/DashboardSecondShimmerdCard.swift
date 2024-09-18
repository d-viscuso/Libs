//
//  DashboardSecondShimmerdCard.swift
//  VFGMVA10Framework
//
//  Created by Atta Amed on 1/27/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation
import VFGMVA10Foundation
/// Dashboard second card shimmer entry
public class DashboardSecondShimmerdCard: NSObject, VFGComponentEntry {
    public required init(config: [String: Any]?, error: [String: Any]?) {}

    public lazy var cardView: UIView? = BillShimmerdCard()

    public var cardEntryViewController: UIViewController? {
        return nil
    }
}
