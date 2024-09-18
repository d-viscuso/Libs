//
//  AddonsViewController+Navigation.swift
//  VFGMVA10Framework
//
//  Created by Salma Ashour on 8/9/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

extension AddOnsViewController {
    func navigateToShopAddOn() {
        guard let shopAddOnsVC =
            ShopAddOnsViewController.instance(
                from: "ShopAddOns",
                with: "ShopAddOnsViewController",
                bundle: Bundle.mva10Framework) as? ShopAddOnsViewController,
            let addOnsDataProvider =
                addOnsViewModel?.addOnsDataProvider as? ShopAddOnsDataProviderProtocol else { return }
        shopAddOnsVC.shopAddOnsVM = ShopAddOnsViewModel(shopAddOnDataProvider: addOnsDataProvider)
        shopAddOnsVC.navigationDelegate = navigationDelegate
        shopAddOnsVC.manageAddOnUiDelegate = manageAddOnUiDelegate
        shopAddOnsVC.manageAddOnNavigationDelegate = manageAddOnNavigationDelegate

        var baseNavController: MVA10NavigationController?
        if let mva10NavController = rootViewController?.navigationController as? MVA10NavigationController {
            baseNavController = mva10NavController
        } else if let navController = navigationController as? MVA10NavigationController {
            baseNavController = navController
        } else {
            shopAddOnsVC.modalPresentationStyle = .fullScreen
            present(shopAddOnsVC, animated: true)
        }

        baseNavController?.setTitle(
            title: "addons_screen_title".localized(bundle: Bundle.mva10Framework),
            accessibilityID: "shopAddOnTitle",
            for: shopAddOnsVC)
        baseNavController?.pushViewController(shopAddOnsVC, animated: true)
    }

    func navigateToRemoveORAddAddOn(with addOn: AddOnsProductModel?, actionType: ManageAddOnActions = .remove) {
        guard let addOn = addOn else { return }
        switch navigationDelegate?.buyAddOnNavigationType(viewController: self, addOn) {
        case .customNavigation(let navigationAction):
            navigationAction()
            return
        default:
            break
        }
        guard let manageAddOnVC =
            ManageAddOnViewController.instance(
                from: "ManageAddOn",
                with: "ManageAddOnViewController",
                bundle: Bundle.mva10Framework) as? ManageAddOnViewController,
            let addOnsDataProvider =
                addOnsViewModel?.addOnsDataProvider as? VFGManageAddOnDataProviderProtocol else { return }

        manageAddOnVC.manageAddOnVM = ManageAddOnPlanViewModel(
            manageAddOnDataProvider: addOnsDataProvider,
            addOn: addOn,
            actionType: actionType,
            confirmAlertDelegate: manageAddOnVC,
            resultViewDelegate: manageAddOnVC)
        manageAddOnVC.uiDelegate = manageAddOnUiDelegate
        manageAddOnVC.navigationDelegate = manageAddOnNavigationDelegate
        var baseNavController: MVA10NavigationController?
        if let mva10NavController = rootViewController?.navigationController as? MVA10NavigationController {
            baseNavController = mva10NavController
        } else if let navController = navigationController as? MVA10NavigationController {
            baseNavController = navController
        } else {
            manageAddOnVC.modalPresentationStyle = .fullScreen
            present(manageAddOnVC, animated: true)
        }

        baseNavController?.setTitle(
            title: addOn.title ?? "",
            accessibilityID: addOn.title ?? "",
            for: manageAddOnVC)
        baseNavController?.pushViewController(manageAddOnVC, animated: true)
    }

    func navigateToBuyAddOn(with addOn: AddOnsCVMModelProtocol?) {
        guard let addOn = addOn else { return }
        guard let manageAddOnVC =
            ManageAddOnViewController.instance(
                from: "ManageAddOn",
                with: "ManageAddOnViewController",
                bundle: Bundle.mva10Framework) as? ManageAddOnViewController,
            let addOnsDataProvider =
                addOnsViewModel?.addOnsDataProvider as? VFGManageAddOnDataProviderProtocol else { return }

        let addOnModel = AddOnsProductModel(
            title: addOn.title ?? "",
            subTitle: addOn.subTitle ?? "",
            imageName: addOn.imageName ?? "",
            addonType: addOn.addonType ?? AddOnsTypeLocalize.others.localizedString,
            addOnDetails: addOn.addOnDetails ??
                AddOnPlanDetails(
                    title: "",
                    description: "",
                    startDate: "",
                    expirationDate: "",
                    priceDetails: "",
                    price: "",
                    isAutoRenewable: false),
            identifier: addOn.identifier ?? "")

        manageAddOnVC.manageAddOnVM = ManageAddOnPlanViewModel(
            manageAddOnDataProvider: addOnsDataProvider,
            addOn: addOnModel,
            actionType: .buy,
            confirmAlertDelegate: manageAddOnVC,
            resultViewDelegate: manageAddOnVC)
        manageAddOnVC.uiDelegate = manageAddOnUiDelegate
        manageAddOnVC.navigationDelegate = manageAddOnNavigationDelegate
        if let navController = rootViewController?.navigationController as? MVA10NavigationController {
            navController.setTitle(
                title: addOn.title ?? "",
                accessibilityID: addOn.title ?? "",
                for: manageAddOnVC)
        } else {
            rootViewController?.navigationController?.title = addOn.title ?? ""
                .localized(bundle: Bundle.mva10Framework)
        }
        rootViewController?.navigationController?.pushViewController(manageAddOnVC, animated: true)
    }
}
