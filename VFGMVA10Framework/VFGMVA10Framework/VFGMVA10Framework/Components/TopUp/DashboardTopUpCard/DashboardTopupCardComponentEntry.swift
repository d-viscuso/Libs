//
//  DashboardTopupCardComponentEntry.swift
//  VFGMVA10Framework
//
//  Created by Esraa Eldaltony on 12/7/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

/// Dashboard topUp card component entry.
public class DashboardTopupCardComponentEntry: NSObject, VFGComponentEntry {
    var view: DashboardTopupCard?
    var itemAction: (() -> Void)?
    var actionId: String?
    var dataProvider: VFGTopUpDataProvider?

    public var cardEntryViewController: UIViewController? {
        return nil
    }

    public required init(config: [String: Any]?, error: [String: Any]?) {
        super.init()
        actionId = config?["itemActionId"] as? String
        dataProvider = VFGTopUpDataProvider(fileName: config?["stub_fileName"] as? String)
        view = DashboardTopupCard.loadXib(bundle: .mva10Framework)
        dataProvider?.fetchDashboardCardData { [weak self] model, error in
            guard
                let self = self,
                error == nil,
                let model = model as? VFGDashboardTopUpModel else { return }
            self.view?.configure(with: model)
        }
    }

    public var cardView: UIView? {
        return view
    }

    public func didSelectCard() {
        let actions = VFGManagerFramework.dashboardDelegate?.dashboardActions()
        itemAction = actions?[actionId ?? ""]
        self.itemAction?()
    }
}
