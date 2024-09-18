//
//  VFGShimmerManager.swift
//  VFGMVA10Framework
//
//  Created by Atta Amed on 1/19/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation
import VFGMVA10Foundation
/// Dashboard screen shimmer model
public class VFGDashboardShimmerModel: VFGDashboardItemsProtocol {
    public var refreshManager: VFGRefreshManager? = VFGRefreshManager(
        lastUpdatedTimeKey: "dashboardLastUpdatedTime")
    public var lastUpdatedTime = Date()
    /// Dashboard shimmer sections
    var sections: [BaseSectionViewModel]
    /// Dashboard shimmer data URL
    var dataStringUrl: String
    weak public var delegate: VFGDashboardManagerProtocol?
    /// Dashboard shimmer data provider
    let dataProvider: VFGDashboardDataProviderProtocol
    public var state: VFGContentState = .loading
    /// *VFGDashboardShimmerModel* initializer based on URL and data provider
    /// - Parameters:
    ///    - stringURL: Dashboard shimmer data url
    ///    - dataProvider: Dashboard shimmer data provider
    public init?(
        stringURL: String? = Constants.dashboardShimmerItemsURL?.absoluteString ?? "",
        dataProvider: VFGDashboardDataProviderProtocol = VFGDashboardDataProvider()
    ) {
        guard let dashboardItemUrl = stringURL else {
            VFGErrorLog("Failed to create model with:\(stringURL ?? "")")
            return nil
        }
        dataStringUrl = dashboardItemUrl
        sections = []
        self.dataProvider = dataProvider
        setup()
        refreshManager?.refreshStatusModel = refreshStatusModel ?? VFGRefreshStatusModel()
    }
    /// *VFGDashboardShimmerModel* initializer based on model and data provider
    /// - Parameters:
    ///    - model: Dashboard shimmer data model
    ///    - dataProvider: Dashboard shimmer data provider
    public init(
        model: [BaseSectionViewModel],
        dataProvider: VFGDashboardDataProviderProtocol
    ) {
        sections = model
        dataStringUrl = ""
        self.dataProvider = dataProvider
        refreshManager?.refreshStatusModel = refreshStatusModel ?? VFGRefreshStatusModel()
    }

    public func setup() {
        setupInitialData(completion: nil)
    }
    /// Dashboard shimmer data request
    /// - Parameters:
    ///    - completion: A closure to hold data array of sections in case of request succeeded
    public func setupInitialData(completion: (([BaseSectionViewModel]?) -> Void)?) {
        if !dataStringUrl.isEmpty {
            dataProvider.requestData(with: dataStringUrl) { [weak self] sections, error in
                guard let self = self else {
                    return
                }
                guard error == nil else {
                    if let sections = sections {
                        self.sections = sections
                    }
                    return
                }
                if let sections = sections {
                    self.sections = sections
                    if let completion = completion {
                        completion(sections)
                    }
                }
            }
        }
    }

    public func refresh(completion: @escaping (_ error: Error?) -> Void) {
        setupInitialData { _ in
            completion(nil)
        }
    }

    public func numberOfSections() -> Int {
        return (sections.isEmpty) ? 1 : sections.count
    }

    public func numberOfItemsAtSection(section: Int) -> Int {
        if !sections.isEmpty {
            return sections[section].items?.count ?? 0
        }
        return 1
    }

    public func sectionAtIndex(index: Int) -> BaseSectionViewModel? {
        if !sections.isEmpty {
            return sections[index]
        }

        return nil
    }

    public func cardAtIndex(indexPath: IndexPath) -> BaseItemViewModel? {
        if !sections.isEmpty, !(sections[indexPath.section].items?.isEmpty ?? false) {
            guard let item = sections[indexPath.section].items?[indexPath.row] else {
                return BaseItemViewModel()
            }
            return item
        }

        return nil
    }

    public func titleForSection(at index: Int) -> String {
        let sectionsNotEmpty = !sections.isEmpty
        let indexWithinRange = sections.indices.contains(index)
        if sectionsNotEmpty, indexWithinRange {
            return sections[index].title ?? ""
        }
        return ""
    }

    public func didSelectCardAtIndex(indexPath: IndexPath) {}

    public func dashboardIndexInSections() -> Int? {
        if !sections.isEmpty {
            return sections.firstIndex { $0.type == VFGDashboardCardType.dashboard.rawValue }
        }
        return nil
    }

    public func discoverIndexInSections() -> Int? {
        if !sections.isEmpty {
            return sections.firstIndex { $0.type == VFGDashboardCardType.discover.rawValue }
        }
        return nil
    }

    public func typeForSection(at index: Int) -> String? {
        let sectionsNotEmpty = !sections.isEmpty
        let indexWithinRange = index < sections.count
        if sectionsNotEmpty, indexWithinRange {
            return sections[index].type ?? VFGDashboardCardType.none.rawValue
        }
        return VFGDashboardCardType.none.rawValue
    }

    public func enableHeaderForSection(at index: Int) -> Bool {
        return true
    }
}
