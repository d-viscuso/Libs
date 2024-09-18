//
//  VFGDashboardLifeCycleProtocol.swift
//  VFGMVA10Framework
//
//  Created by Mohamed Abd ElNasser on 21/02/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import Foundation

public protocol VFGDashboardLifeCycleProtocol: AnyObject {
    func dashboardViewDidLoad()
    func dashboardViewDidAppear(_ animated: Bool)
    func dashboardViewWillAppear(_ animated: Bool)
    func dashboardViewWillDisappear(_ animated: Bool)
    func dashboardViewDidDisappear(_ animated: Bool)

    // ScrollView
    func dashboardScrollViewDidScroll(_ scrollView: UIScrollView)
    func dashboardScrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    func dashboardScrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool)
    func dashboardScrollViewWillBeginDragging(_ scrollView: UIScrollView)
}

public extension VFGDashboardLifeCycleProtocol {
    func dashboardViewDidLoad() {}
    func dashboardViewDidAppear(_ animated: Bool) {}
    func dashboardViewWillAppear(_ animated: Bool) {}
    func dashboardViewWillDisappear(_ animated: Bool) {}
    func dashboardViewDidDisappear(_ animated: Bool) {}
    func dashboardScrollViewDidScroll(_ scrollView: UIScrollView) {}
    func dashboardScrollViewDidEndDecelerating(_ scrollView: UIScrollView) {}
    func dashboardScrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {}
    func dashboardScrollViewWillBeginDragging(_ scrollView: UIScrollView) {}
}
