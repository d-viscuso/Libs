//
//  AddOnsViewController+Data.swift
//  VFGMVA10Framework
//
//  Created by Yahya Saddiq on 3/19/21.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

extension AddOnsViewController {
    func fetchData() {
        let dispatchGroup = DispatchGroup()

        fetchAddOnsCVM(dispatchGroup)
        fetchMyProducts(dispatchGroup)
        if addOnsViewModel?.isTimeLineViewHidden == false {
            fetchMyActivePlanServices(dispatchGroup)
        }

        dispatchGroup.notify(queue: DispatchQueue.main) { [weak self] in
            self?.rootViewController?.dataFetchingDidComplete()
        }
    }

    func fetchMyProducts(_ dispatchGroup: DispatchGroup) {
        dispatchGroup.enter()

        addOnsViewModel?.updateProductLoadingStatus = { [weak self] in
            guard let self = self else {
                return
            }

            switch self.addOnsViewModel?.productContentState {
            case .loading:
                self.rootViewController?.dataFetchingWillStart()
                self.startShimmering()
            case .populated:
                self.stopShimmering()
                self.numberOfAddOns = self.addOnsViewModel?.myProducts?.count ?? 0
                self.toggleNoAddOnsAvailableLabel()
                dispatchGroup.leave()
            case .error:
                self.handleDataError()
                dispatchGroup.leave()
            case .empty:
                // Just leave dispatch group with a state indicating that there's no data..
                dispatchGroup.leave()
            default:
                VFGDebugLog("Default case")
            }
        }

        addOnsViewModel?.fetchMyProducts()
    }

    func fetchAddOnsCVM(_ dispatchGroup: DispatchGroup) {
        dispatchGroup.enter()

        addOnsViewModel?.updateCVMLoadingStatus = { [weak self] in
            guard let self = self else {
                return
            }

            switch self.addOnsViewModel?.cvmContentState {
            case .loading:
                VFGInfoLog("loading")
            case .populated:
                self.stopShimmering()
                self.toggleNoAddOnsAvailableLabel()
                dispatchGroup.leave()
            case .error:
                dispatchGroup.leave()
            case .empty:
                // Just leave dispatch group with a state indicating that there's no data..
                dispatchGroup.leave()
            default:
                VFGDebugLog("Default case")
            }
        }
        addOnsViewModel?.fetchAddonsCVM()
    }

    func fetchMyActivePlanServices(_ dispatchGroup: DispatchGroup) {
        dispatchGroup.enter()

        myPlanDataProvider?.fetchActiveServices { [weak self] myPlans, error in
            guard let self = self,
                error == nil,
                let myActiveServices = myPlans else {
                dispatchGroup.leave()
                return
            }

            self.myActiveServices = myActiveServices
            let addonPrice = (self.myActiveServices?.primaryPlan?.planPrice ?? "")
                + (self.myActiveServices?.primaryPlan?.planPriceUnit ?? "")
            let addonStartDate = self.myActiveServices?.primaryPlan?.startDate
            let addonExpirationDate = self.myActiveServices?.primaryPlan?.expirationDate
            let myPlanModel = AddOnsProductModel(
                title: self.myActiveServices?.primaryPlan?.planName ?? "",
                subTitle: "",
                imageName: "",
                addonType: AddOnsTypeLocalize.myPlan.localizedString,
                addOnDetails: AddOnPlanDetails(
                    title: "",
                    description: "",
                    startDate: addonStartDate ?? "",
                    expirationDate: addonExpirationDate ?? "",
                    priceDetails: "",
                    price: addonPrice,
                    isAutoRenewable: true),
                identifier: "")

            self.timelineProducts = self.addOnsViewModel?.myProducts ?? []
            self.timelineProducts.insert(myPlanModel, at: 0)
            self.myPlanModel = myPlanModel
            dispatchGroup.leave()
        }
    }

    public func refresh() {
        guard addOnsProductsCollectionView != nil else {
            return
        }

        showScreenContent()
        removeErrorCard()
        fetchData()
    }
}
