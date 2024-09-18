//
//  MyPlanViewModelProtocol.swift
//  VFGMVA10Framework
//
//  Created by Hussein Kishk on 9/24/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation

/// My plan view model protocol.
public protocol MyPlanViewModelProtocol {
    /// My plan data provider.
    var myPlanDataProvider: MyPlanDataProviderProtocol { get }
    /// My active service.
    var myActiveServices: ActivePlanServicesProtocol? { get }
    /// Primary plan service.
    var primaryPlanService: PrimaryPlanServiceProtocol? { get }
    /// List of main inclusions.
    var mainInclusions: [MainInclusion]? { get }
    /// List of additional inclusions.
    var additionalInclusions: [AdditionalInclusion]? { get }
    /// List of extra info items.
    var extraInfoItems: [PlanExtraInfo]? { get }
    /// List of additional extra info items.
    var additionalExtraInfoItems: [PlanExtraInfo]? { get }
    /// Service title.
    var serviceTitle: String? { get }
    /// Service subtitle.
    var serviceSubtitle: String? { get }
    /// Content state *empty, loading, etc*.
    var contentState: VFGContentState { get }
    /// An optional UIView that can be added as a footer to my plan screen.
    var extraFooterView: UIView? { get set }
    /// Boolean to determine whether to hide or show my plan footer.
    var isMyPlanFooterHidden: Bool { get }
    /// Boolean to determine whether to hide or show section header.
    var isSectionHeaderHidden: Bool { get }
    /// Boolean to determine whether the customDetailsView is initially hidden
    var isCustomDetailsViewHidden: Bool { get set }
    /// A string to set the custom details button title. Notice that if the button title equal nil or you don't pass the title, the button will be hidden
    var customDetailsButtonTitle: String? { get }
    /// A string to set the custom details button title after it has been clicked
    var customDetailsButtonTitleOnClick: String? { get }
    /// Extra height for my plan view controller
    var additionalHeight: CGFloat { get }
    /// Completion called to start loading.
    var startLoadingState: (() -> Void)? { get set }

    init(myPlanProvider: MyPlanDataProviderProtocol)
    /// Method returns number of inclusions.
    func numberOfInclusions() -> Int
    /// Method returns number of active paln services.
    func numberOfActivePlanServices() -> Int
    /// Method returns number of inactive paln services.
    func numberOfInActivePlanServices() -> Int
    /// Method returns inclusion type  *InclusionType* of the selected index.
    func inclusionType(at index: Int) -> InclusionType?
    /// Method returns *PrimaryPlanCellViewModel* instance at a specific index.
    func cellViewModel(at index: Int) -> PrimaryPlanCellViewModel
    /// Method returns header view model *PrimaryPlanServicesHeaderViewModel*.
    func headerViewModel() -> PrimaryPlanServicesHeaderViewModel
    /// Method returns footer view model *PrimaryPlanServicesFooterViewModel*.
    func footerViewModel() -> PrimaryPlanServicesFooterViewModel
    /// Method to fetch active plan services.
    func fetchMyActivePlanServices(completion: @escaping () -> Void)
}

public extension MyPlanViewModelProtocol {
    var isMyPlanFooterHidden: Bool {
        false
    }

    var isSectionHeaderHidden: Bool {
        false
    }

    var customDetailsButtonTitle: String? {
        nil
    }

    var customDetailsButtonTitleOnClick: String? {
        nil
    }

    var isCustomDetailsViewHidden: Bool {
        get { false }
        set { isCustomDetailsViewHidden = newValue }
    }

    var extraFooterView: UIView? {
        get { nil }
        set { extraFooterView = newValue }
    }

    var additionalHeight: CGFloat {
        0.0
    }
}
