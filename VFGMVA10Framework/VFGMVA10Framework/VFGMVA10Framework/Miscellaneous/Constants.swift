//
//  Constants.swift
//  mva10
//
//  Created by Sandra Morcos on 12/13/18.
//  Copyright © 2018 vodafone. All rights reserved.
//
import Foundation
import VFGMVA10Foundation
import UIKit

/// List of constants to use across the app
public enum Constants {
    /// Dashboard items JSON file URL
    public static let dashboardItemsURL: URL? =
        Bundle.main.url(forResource: "dashboard_stub", withExtension: "json")
    /// Dashboard items JSON file URL for MVA12
    public static let dashboardItemsMVA12URL: URL? =
        Bundle.main.url(forResource: "dashboard_stub_mva12", withExtension: "json")
    /// Dashboard items shimmering JSON file URL
    public static var dashboardShimmerItemsURL: URL? =
        Bundle.mva10Framework.url(forResource: "dashboard_shimmering", withExtension: "json")
    public static var dashboardShimmerItemsMVA12URL: URL? = Bundle.mva10Framework.url(
        forResource: "dashboard_shimmering_mva12",
        withExtension: "json"
    )

    static let getApp = "dashboard_app_get_action_label".localized(bundle: Bundle.mva10Framework)
    static let openApp = "dashboard_app_open_action_label".localized(bundle: Bundle.mva10Framework)

    static let checksFailedMessage = "everything_is_ok_details_screen_error_text"
        .localized(bundle: Bundle.mva10Framework)
    static let checksSucceededMessage = "everything_is_ok_details_screen_success_text"
        .localized(bundle: Bundle.mva10Framework)
    static let checksInProgressMessage = "everything_is_ok_details_screen_in_progress_text"
        .localized(bundle: Bundle.mva10Framework)

    static let eiokProgressMessage = "everything_is_ok_in_progress_text".localized(bundle: Bundle.mva10Framework)
    static let eiokErrorMessage = "everything_is_ok_error_text".localized(bundle: Bundle.mva10Framework)
    static let eiokSuccessMessage = "everything_is_ok_text".localized(bundle: Bundle.mva10Framework)
    static var eiokMessageDuration = 5.0
    static var eiokWelcomeMessageDuration: TimeInterval = 2.4
    static var eiokWelcomeMessageDelay: TimeInterval = 0.5

    static let validationDelay = 0.8
    static var iPhone5ScreenHeight: CGFloat = 568.0
    static let iPhone8ScreenHeight: CGFloat = 667.0

    // todo: move them to Dashboard Enum
    static var dashboardFunFactHeight: CGFloat = 200
    static var dashboardCollectionPadding: CGFloat = 8
    static let dashboardBackgroundMargin: CGFloat = 50
    static var dashboardBackgroundMinY: CGFloat = -12
    static var dashboardHeaderIconsWidth: CGFloat = 24
    static var dashboardHeaderMargin: CGFloat = 16
    static var dashboardHeaderIconsPadding: CGFloat = 8
    static var dashboardTransitionDuration: TimeInterval = 0.5
    static var mva12DashboardBackgroundMinY: CGFloat = -15
    static var statusBarDashboardMargin: CGFloat = 49

    static let trayItemsURL: URL? = Bundle.main.url(forResource: "tray_stub", withExtension: "json")
    static var trayItemsAnimationOffset: CGFloat = 10
    static let transitionPadding: CGFloat = 150
    static let trayBottomPadding: CGFloat = 17
    static let trayViewWidth: CGFloat = 68

    static let genericMaximumHeight: CGFloat = 340.0
    static let editorialMaximumHeight: CGFloat = 314

    static let messageCenterBadgeID = "messageCenter"

    enum TrayAnimations {
        static let tobiDisplacement: CGFloat = 15.0
        static let tobiDownDuration: TimeInterval = 0.2
        static let tobiUpDuration: TimeInterval = 0.3
        static let reverseTobiUpDuration: TimeInterval = 0.2
        static let tobiDelay: TimeInterval = 0
        static let reverseTobiDelay: TimeInterval = 0.05
        static let trayPlaceholderDuration: TimeInterval = 0.2
        static let reverseTrayPlaceholderDuration: TimeInterval = 0.3
        static let trayPlaceholderDelay: TimeInterval = 0
        static let trayPlaceholderFade: TimeInterval = 0.15
        static let trayPlaceholderFadeOutDelay: TimeInterval = 0.55
        static let sheetViewBottomFadeOutDelay: TimeInterval = 0.25
        static let reverseTrayPlaceholderDelay: TimeInterval = 0
        static let labelsDuration: TimeInterval = 0.3
        static let labelsDelay: TimeInterval = 0.1
        static let reverseLabelsDuration: TimeInterval = 0.08
        static let traysubItemOpenDelay: TimeInterval = 0.25
        static let traysubItemHighDelay: TimeInterval = 0.2
        static let traysubItemHighDuration: TimeInterval = 0.3
        static let traysubItemLowDuration: TimeInterval = 0.05
        static let traysubItemDelayFactor: TimeInterval = 0.05
        static let traysubItemDelay: TimeInterval = 0.2
        static let trayFirstSwitchingDuration: TimeInterval = 0.15
        static let trayFirstFadingDuration: TimeInterval = 0.1
        static let trayLastSwitchingDuration: TimeInterval = 0.2
        static let trayItemTextDuration: TimeInterval = 0.1
        static let trayLottieSpeedPercentage: CGFloat = 0.9
    }
    /// Constants for EIO animation process
    public enum EIOAnimation {
        static let iconAnimationDuration: TimeInterval = 0.3
        static let iconOpacity: CGFloat = 0.4
        static let yOffset: CGFloat = 45
        static let delayBetweenEachImage: TimeInterval = 0.1
        static let blinkingIconDuration: TimeInterval = 0.47
        static let blinkingHeaderDuration: TimeInterval = 0.55
        public static let expandingCollapsingDuration: TimeInterval = 0.3
    }

    enum DashboardSectionHeader {
        static var collectionScrollMargin: CGFloat {
            return UIScreen.screenHasNotch ? 44 : 0
        }
        static let initialLogoTopMargin: CGFloat = 12
        static let iconsContainerHeight: CGFloat = 32
        static let parallexRatio: CGFloat = 1.5
        static var currentAlpha: CGFloat = 1
    }

    enum DashboardDiscoverSnap {
        static let discoverTopMargin: CGFloat = 30.0
        static let discoverSnappingTopThreshold: CGFloat = 120.0
        static let discoverSnappingBottomThreshold: CGFloat = 120.0
    }

    // MARK: - Dashboard
    /// List of constants to be used in dashboard
    public enum Dashboard {
        enum Identifier {
            static let cell = "VFDashboardCellId"
            static let header = "VFDashboardSectionHeaderId"
            static let defaultSectionHeader = "VFGDefaultSectionHeaderId"
            static let discoverHeader = "VFDiscoverSectionHeaderId"
            static let refreshFooter = "VFDasboardRefreshFooterId"
            static let defaultReusableView = "defaultReusableViewIdentifier"
            static let defaultEIOHeaderView = "defaultEIOHeaderIdentifier"
            static let discoverHeaderShimmer = "VFDiscoverSectionHeaderShimmerId"
        }

        enum View {
            static let defaultSectionHeader = "VFGDefaultSectionHeader"
            static let discoverHeader = "VFDiscoverHeader"
            static let refreshView = "VFGRefreshFooterView"
            static let discoverHeaderShimmer = "VFGDiscoverHeaderShimmer"
        }
        /// Time-based operations time interval
        public enum Interval {
            public static let autoRefreshIntervalInSeconds: Double = 120.0
            public static let multipleAccountsBannerInterval: Double = 5.0
            public static let seasonalOfferWait: Int = 5
        }
        /// Dashboard view layout constants
        public enum Layout {
            static let margin: CGFloat = 32.0
            public static var firstItemExtraHeight: CGFloat = 0.0

            enum Logo {
                static let x: CGFloat = 16.0
                static let y: CGFloat = 17.0
                static let width: CGFloat = 32.0
                static let height: CGFloat = 32.0
            }
        }
    }

    enum ErrorCard {
        static let tryAgainText = "dashboard_loading_error_try_again_button".localized(bundle: .mva10Framework)
        static let identifier = "VFErrorCardId"
        static let description = "dashboard_loading_error_message".localized(bundle: .mva10Framework)
        static let visibilityDuration: TimeInterval = 0.3
    }

    enum TobiMessages {
        static let welcomeMessageTimer: Double = 3.0
        static let tobiMessageTimer: Double = 5.0
    }

    enum ManageAddOn {
        static let backgroundImageName = "headerImage"
    }

    enum AddOnsTimeline {
        static let timelineDateViewsHorizontalSpacing: CGFloat = 25
        static let timelineDateViewWidth: CGFloat = 50
        static let timelineDateStartViewXPosition: CGFloat = 10
        static let timelineCellHeight: CGFloat = 50
        static let timelineCurrentPlanCellHeight: CGFloat = 72
        static let timelineCellVerticallSpacing: CGFloat = 16.6
        static let timelineCellStartYPosition: CGFloat = 22

        // Date Format
        static let dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        static let localeUS = Locale(identifier: "en_US_POSIX")
    }

    enum TopUp {
        static let os14DefaultMargins: CGFloat = 10
    }

    enum ProductsAndServices {
        enum MyPlan {
            enum Description {
                static let minimumTerm = "Mininum term"
                static let upgradeEligibility = "Eligible to upgrade"
            }

            enum Kind {
                static let mobileProduct = "Mobile Product"
                static let mobilePlan = "Mobile Plan"
                static let simDetails = "Mobile SIM Card"
                static let phoneDetails = "Mobile Phone"
            }
        }
    }

    enum AutoBill {
        static let autoBillLoadingViewHeight: CGFloat = 490
        static let autoBillLoadingAnimationViewHeight: CGFloat = 150
        static let daysCellsCount: Int = 300
        static let initialSelectedDay: Int = 23
        static let initialSelectedRowOffset: Int = 123
    }

    enum Appointment {
        enum Size {
            enum ServiceCell {
                static let height: CGFloat = 170
            }

            enum TimeSlotCell {
                static let width: CGFloat = 98
                static let height: CGFloat = 30
            }

            enum StoreCell {
                static let height: CGFloat = 200
                static let leftInset: CGFloat = 16
            }
        }
    }
    // MARK: - EShop
    /// List of constants to be used in eShop
    public enum EShop {
        static let safeAreaTop: CGFloat = UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0
        static let topTabHeight: CGFloat = 50
        static let topTabNoHeight: CGFloat = 0
        static let headViewTotalHeight: CGFloat = safeAreaTop + 90
        static let headViewNoTabsHeight: CGFloat = safeAreaTop + 72
        static let headViewReducedHeight: CGFloat = safeAreaTop + 58
        static let topTabsTopHeight: CGFloat = 60
        static let topTabsTopHeightNoHeader: CGFloat = 8
    }
}
