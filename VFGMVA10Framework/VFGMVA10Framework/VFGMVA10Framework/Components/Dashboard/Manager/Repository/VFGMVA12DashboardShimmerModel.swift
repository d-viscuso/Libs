//
//  VFGMVA12DashboardShimmerModel.swift
//  VFGMVA10Framework
//
//  Created by Ahmed AbdElnabi on 30/08/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import Foundation
import VFGMVA10Foundation
/// Dashboard screen shimmer model
public class VFGMVA12DashboardShimmerModel: VFGDashboardItemsProtocol {
    public var delegate: VFGDashboardManagerProtocol?

    public var state: VFGContentState = .loading

    public var lastUpdatedTime = Date()

    /// Dashboard shimmer sections
    var mva12ShimmerSections: [BaseSectionViewModel]
    /// Dashboard shimmer data URL
    var dataStringUrl: String
    /// Dashboard shimmer data provider
    let mva12ShimmerDataProvider: VFGDashboardDataProviderProtocol

    /// *VFGDashboardShimmerModel* initializer based on URL and data provider
    /// - Parameters:
    ///    - stringURL: Dashboard shimmer data url
    ///    - dataProvider: Dashboard shimmer data provider
    public init?(
        stringURL: String? = Constants.dashboardShimmerItemsMVA12URL?.absoluteString ?? "",
        dataProvider: VFGDashboardDataProviderProtocol = VFGDashboardDataProvider()
    ) {
        guard let dashboardItemUrl = stringURL else {
            VFGErrorLog("Failed to create model with:\(stringURL ?? "")")
            return nil
        }
        dataStringUrl = dashboardItemUrl
        mva12ShimmerSections = []
        self.mva12ShimmerDataProvider = dataProvider
        setup()
    }
    /// *VFGDashboardShimmerModel* initializer based on model and data provider
    /// - Parameters:
    ///    - model: Dashboard shimmer data model
    ///    - dataProvider: Dashboard shimmer data provider
    public init(
        model: [BaseSectionViewModel],
        dataProvider: VFGDashboardDataProviderProtocol
    ) {
        mva12ShimmerSections = model
        dataStringUrl = ""
        self.mva12ShimmerDataProvider = dataProvider
    }

    public func setup() {
        setupInitialData(completion: nil)
    }
    /// Dashboard shimmer data request
    /// - Parameters:
    ///    - completion: A closure to hold data array of sections in case of request succeeded
    public func setupInitialData(completion: (([BaseSectionViewModel]?) -> Void)?) {
        if !dataStringUrl.isEmpty {
            mva12ShimmerDataProvider.requestData(with: dataStringUrl) { [weak self] sections, error in
                guard let self = self else {
                    return
                }
                guard error == nil else {
                    if let sections = sections {
                        self.mva12ShimmerSections = sections
                    }
                    return
                }
                if let sections = sections {
                    self.mva12ShimmerSections = sections
                    if let completion = completion {
                        completion(sections)
                    }
                }
            }
        }
    }

    public func sectionAtIndex(index: Int) -> BaseSectionViewModel? {
        if !mva12ShimmerSections.isEmpty {
            return mva12ShimmerSections[index]
        }

        return nil
    }

    public func cardAtIndex(indexPath: IndexPath) -> BaseItemViewModel? {
        if !mva12ShimmerSections.isEmpty, !(mva12ShimmerSections[indexPath.section].items?.isEmpty ?? false) {
            guard let item = mva12ShimmerSections[indexPath.section].items?[safe: indexPath.row] else {
                return BaseItemViewModel()
            }
            return item
        }

        return nil
    }

    public func titleForSection(at index: Int) -> String {
        let sectionsNotEmpty = !mva12ShimmerSections.isEmpty
        let indexWithinRange = mva12ShimmerSections.indices.contains(index)
        if sectionsNotEmpty, indexWithinRange {
            return mva12ShimmerSections[index].title ?? ""
        }
        return ""
    }

    public func numberOfSections() -> Int {
        return (mva12ShimmerSections.isEmpty) ? 1 : mva12ShimmerSections.count
    }

    public func numberOfItemsAtSection(section: Int) -> Int {
        if !mva12ShimmerSections.isEmpty {
            return mva12ShimmerSections[section].items?.count ?? 0
        }
        return 1
    }

    public func didSelectCardAtIndex(indexPath: IndexPath) {}

    public func typeForSection(at index: Int) -> String? {
        let sectionsNotEmpty = !mva12ShimmerSections.isEmpty
        let indexWithinRange = index < mva12ShimmerSections.count
        if sectionsNotEmpty, indexWithinRange {
            return mva12ShimmerSections[index].type ?? VFGDashboardCardType.none.rawValue
        }
        return VFGDashboardCardType.none.rawValue
    }

    @discardableResult
    public func enableHeaderForSection(at index: Int) -> Bool {
        if !mva12ShimmerSections.isEmpty {
            return !(mva12ShimmerSections[index].title?.isEmpty ?? true)
        }
        return false
    }

    public func enableFooterForSection(at index: Int) -> Bool {
        if !mva12ShimmerSections.isEmpty {
            return mva12ShimmerSections[index].type != VFGDashboardCardType.scrollableCard.rawValue &&
            mva12ShimmerSections[index].type != VFGDashboardCardType.discover.rawValue
        }
        return false
    }
}
