//
//  DashboardFunFactComponentEntry.swift
//  VFGMVA10Framework
//
//  Created by Ramy Nasser on 09/02/2022.
//

import VFGMVA10Foundation

/// Dashboard fun fact card entry
public class DashboardFunFactComponentEntry: NSObject, VFGComponentEntry {
    var view: VFGFunFactView?

    public required init(config: [String: Any]?, error: [String: Any]?) {
        super.init()
        view = VFGFunFactView.loadXib(bundle: Bundle.mva10Framework)

        guard let model = VFGManagerFramework.funFactDelegate?.model else {
            return
        }
        view?.configure(model: model)
    }

    public var cardView: UIView? {
        view
    }

    public var cardEntryViewController: UIViewController? {
        return nil
    }
    /// configure card view when the entry will display
    public func willDisplay() {
        view?.willDisplay()
    }
    /// configure card view when the entry did scroll
    public func didScroll(percentage: CGFloat) {
        view?.didScroll(percentage: percentage)
    }
}
