//
//  VFGMyPlanManager.swift
//  VFGMVA10Framework
//
//  Created by Hussein Kishk on 9/24/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation
import VFGMVA10Foundation

/// My plan manager.
public class VFGMyPlanManager {
    /// Add plan state manager delegate.
    public weak var addPlanStateManagerDelegate: VFGAddPlanStateManagerProtocol?
    /// Page banner delegate.
    public weak var pageBannerDelegate: VFGPageBannerProtocol?
    /// My plan view model.
    let myPlanViewModel: MyPlanViewModelProtocol
    /// Boolean to determine whether to enable or disable CVM page banner.
    public var enableCVMPageBanner: Bool

    public init(
        pageBannerDelegate: VFGPageBannerProtocol? = nil,
        cvmPageBanner: Bool = false,
        addPlanStateManagerDelegate: VFGAddPlanStateManagerProtocol?,
        myPlanViewModel: MyPlanViewModelProtocol
    ) {
        self.enableCVMPageBanner = cvmPageBanner
        self.pageBannerDelegate = pageBannerDelegate
        self.myPlanViewModel = myPlanViewModel
        self.addPlanStateManagerDelegate = addPlanStateManagerDelegate
    }

    func setupPageBanner() -> VFGPageBanner {
        guard let bannerView: VFGPageBanner =
            VFGPageBanner.loadXib(bundle: Bundle.foundation, nibName: "VFGPageBanner") else {
                return VFGPageBanner()
        }
        let bannerModel = VFGPageBannerModel(
            header: "cvm_page_banner_title".localized(bundle: Bundle.main),
            description: "cvm_page_banner_description".localized(bundle: Bundle.main),
            primaryButton: "cvm_page_banner_primary_button_title".localized(bundle: Bundle.main),
            primaryButtonBackgroundColor: .white,
            primaryButtonTitleColor: .black,
            secondaryButton: "cvm_page_banner_secondary_button_title".localized(bundle: Bundle.main),
            buttonType: .close)
        bannerView.setupUI(model: bannerModel)
        return bannerView
    }

    /// Returns a fully initialized instance of *MyPlanViewController*.
    public func myPlanViewController(with entryPointType: ProductsEntryPoints = .myPhone) -> MyPlanViewController {
        let myPlanViewController = MyPlanViewController()

        if enableCVMPageBanner {
            myPlanViewController.pageBanner = setupPageBanner()
            myPlanViewController.pageBannerDelegate = pageBannerDelegate
        } else {
            myPlanViewController.pageBanner = nil
        }

        myPlanViewController.myPlanViewModel = myPlanViewModel
        myPlanViewController.addPlanStateManagerDelegate = addPlanStateManagerDelegate
        myPlanViewController.entryPoint = entryPointType

        return myPlanViewController
    }
}
