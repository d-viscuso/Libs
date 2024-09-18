//
//  VFGUISetup.swift
//  VFGMVA10
//
//  Created by Tomasz Czyżak on 23/06/2019.
//  Copyright © 2019 Vodafone. All rights reserved.
//
import UIKit
import VFGMVA10Foundation

private struct VFGUIConfig: Codable {
    let dashboard: VFGDashboard?
    let navigation: VFGNavigation?
    let application: VFGApplication?
}

private struct VFGDashboard: Codable {
    let mainHeaderHeight: CGFloat
    let defaultHeaderHeight: CGFloat
    let defaultFooterHeight: CGFloat
}

private struct VFGNavigation: Codable {
    let closeIcon: String
    let backArrowIcon: String
    let backgroundImage: String
    let tintColor: String
    let darkTintColor: String
}

private struct VFGApplication: Codable {
    let preferredStatusBarStyle: String
}
/// Dashboard UI constants
class VFGUISetup {
    /// Default constants for cashboard
    public enum Defaults {
        static let dashboardHeaderMaxMyProductsImageHeight: CGFloat = 220
        static let dashboardHeaderMinMyProductsImageHeight: CGFloat = 168
        static var dashboardEIOMinHeaderHeight: CGFloat {
            VFGUISetup.dashboardEIOHeaderHeight(isMinimumHeight: true)
        }
        static var dashboardEIOMaxHeaderHeight: CGFloat {
            VFGUISetup.dashboardEIOHeaderHeight(isMinimumHeight: false)
        }
        static let dashboardFooterHeight: CGFloat = 27
        static let dashboardDefaultHeaderHeight: CGFloat = 47
        static let dashboardDefaultFooterHeight: CGFloat = 27
        static let navigationCloseIcon: String = "icCloseWhite"
        static let navigationBackArrowIcon: String = "icArrowLeftWhite"
        static let navigationBackgroundImage: String = "wavesRed"
        static let navigationCloseTintColor: UIColor = .white
        static let navigationDarkTintColor: UIColor = .black
    }

    static let shared = VFGUISetup()

    private var config: VFGUIConfig?

    private init() {
        configure()
    }

    func configure(file: String = "setupUI", bundle: Bundle = Bundle.mva10Framework) {
        if let data = Data(with: file, bundle: bundle) {
            config = JSONDecoder.parseData(data)
        } else {
            config = nil
        }
    }

    private static func dashboardEIOHeaderHeight(isMinimumHeight: Bool) -> CGFloat {
        let initialHeight: CGFloat = isMinimumHeight ? eioHeaderMinHeight : eioHeaderMaxHeight
        guard VFGEIOManager.shared.headerCustomViewController != nil else {
            return initialHeight
        }
        return initialHeight + VFGEIOManager.shared.customViewControllerHeight
    }

    static var eioHeaderMinHeight: CGFloat = 76
    static var eioHeaderMaxHeight: CGFloat = 128
    static var headerExtraHeight: CGFloat = 0
    static var emptyMainHeaderHeight: CGFloat {
        guard
            let floatingViewModel = VFGManagerFramework.dashboardDelegate?.dashboardManager?.customHeaderModel,
            let floatingViewHeight = floatingViewModel.floatingContainerHeight else {
            return dashboardDefaultHeaderHeight / 2
        }

        return floatingViewHeight / 2
    }
    static var dashboardMainHeaderHeight: CGFloat {
        if VFGManagerFramework.dashboardDelegate?.dashboardManager?.customHeaderModel != nil {
            let isSectionTitleEmpty = VFGManagerFramework.dashboardDelegate?.dashboardManager?.dashboardModel?
                .titleForSection(at: 0).isEmpty ?? true
            let isMVA12Theme = VFGManagerFramework.dashboardDelegate?.dashboardManager?.dashboardController
                .isMVA12Theme ?? false
            if isMVA12Theme && !isSectionTitleEmpty {
                return dashboardDefaultHeaderHeight
            } else if !isSectionTitleEmpty {
                return dashboardDefaultHeaderHeight + emptyMainHeaderHeight
            }
            return emptyMainHeaderHeight
        } else if VFGManagerFramework.dashboardDelegate?.dashboardManager?
            .dashboardModel?.myProductsModel?.image != nil {
            return VFGManagerFramework.dashboardDelegate?.everythingIsOk.eioStatus == .success ?
                Defaults.dashboardHeaderMinMyProductsImageHeight :
                Defaults.dashboardHeaderMaxMyProductsImageHeight
        } else {
            return VFGManagerFramework.dashboardDelegate?.everythingIsOk.eioStatus == .success ?
                Defaults.dashboardEIOMinHeaderHeight + headerExtraHeight : Defaults.dashboardEIOMaxHeaderHeight
        }
    }

    static var dashboardBackgroundTopConstant: CGFloat {
        if VFGManagerFramework.dashboardDelegate?.dashboardManager?
            .dashboardModel?.myProductsModel?.image != nil {
            return Defaults.dashboardHeaderMinMyProductsImageHeight
        } else {
            return Defaults.dashboardEIOMinHeaderHeight
        }
    }

    static var dashboardDefaultHeaderHeight: CGFloat {
        return VFGUISetup.shared.config?.dashboard?.defaultHeaderHeight ?? Defaults.dashboardDefaultHeaderHeight
    }

    static var dashboardDefaultFooterHeight: CGFloat {
        return VFGUISetup.shared.config?.dashboard?.defaultFooterHeight ?? Defaults.dashboardDefaultFooterHeight
    }

    static var navigationCloseIcon: String {
        return VFGUISetup.shared.config?.navigation?.closeIcon ?? Defaults.navigationCloseIcon
    }

    static var navigationBackArrow: String {
        return VFGUISetup.shared.config?.navigation?.backArrowIcon ?? Defaults.navigationBackArrowIcon
    }

    static var navigationTintColor: UIColor {
        guard let tintStr = VFGUISetup.shared.config?.navigation?.tintColor else {
            return Defaults.navigationCloseTintColor
        }
        return UIColor(hexString: tintStr) ?? Defaults.navigationCloseTintColor
    }

    static var navigationDarkTintColor: UIColor {
        guard let darkTintStr = VFGUISetup.shared.config?.navigation?.darkTintColor else {
            return Defaults.navigationDarkTintColor
        }
        return UIColor(hexString: darkTintStr) ?? Defaults.navigationDarkTintColor
    }

    static var navigationBackgroundImage: String {
        return VFGUISetup.shared.config?.navigation?.backgroundImage ?? Defaults.navigationBackgroundImage
    }

    static var applicationStatusBarStyle: UIStatusBarStyle {
        if VFGUISetup.shared.config?.application?.preferredStatusBarStyle == "default" {
            return .default
        }
        return .default
    }

    static var statusBarHeight: CGFloat {
        return UIApplication.shared.statusBarFrameValue?.height ?? 0
    }
}
