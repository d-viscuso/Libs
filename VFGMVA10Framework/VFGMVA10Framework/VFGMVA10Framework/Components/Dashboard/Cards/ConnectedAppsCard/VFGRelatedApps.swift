//
//  VFGRelatedApps.swift
//  VFGMVA10Group
//
//  Created by Mahmoud Amer on 8/4/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import Foundation
import VFGMVA10Foundation
/// Dashboard table view cell related apps keys
enum VFGRelatedAppsMetaDataKeys {
    static let title = "title"
    static let subItems = "subItems"
    static let moreText = "moreText"
}
/// Dashboard table view cell related apps entry
public class VFGRelatedApps: VFGComponentEntry, VFDashboardListEntryProtocol {
    public required init(config: [String: Any]?, error: [String: Any]?) {}

    public var hasShowMore: Bool?
    public var showMoreAction: ((Bool) -> Void)?
    /// An instance of *VFGRelatedAppsViewController*
    var appsVC: VFGRelatedAppsViewController?
    public var item: VFGDashboardItem?
    public var cardEntryViewController: UIViewController?
    public var showMoreHeight: CGFloat? = 0

    public var cardView: UIView? {
        if appsVC != nil {
            return appsVC?.view
        }

        guard let subItems = item?.value(for: VFGRelatedAppsMetaDataKeys.subItems) as? [VFGSubItem],
            !subItems.isEmpty else {
            VFGErrorLog("No application found in \(item?.componentId ?? "")")
            return nil
        }
        appsVC = UIViewController.relatedAppsViewController()
        appsVC?.appRows = subItems
        return appsVC?.view
    }
}
