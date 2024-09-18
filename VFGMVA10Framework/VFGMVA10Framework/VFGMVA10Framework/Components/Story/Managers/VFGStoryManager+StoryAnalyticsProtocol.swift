//
//  VFGStoryManager+StoryAnalyticsProtocol.swift
//  VFGMVA10Framework
//
//  Created by Moustafa Hegazy on 15/03/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

extension VFGStoryManager: StoryAnalyticsProtocol {
    static func getStoriesAnalyticsPageAndVisitorData() -> [String: String] {
        [
            VFGAnalyticsKeys.journeyType: JourneyType.discover.rawValue,
            VFGAnalyticsKeys.pageName: "analytics_framework_stories_page_name".localized(bundle: .mva10Framework),
            VFGAnalyticsKeys.pageSection: JourneyType.dashboard.rawValue,
            VFGAnalyticsKeys.eventAction: EventAction.onClick.rawValue,
            VFGAnalyticsKeys.eventCategory: EventCategory.card.rawValue,
            VFGAnalyticsKeys.eventLabel:
                "analytics_framework_stories_event_label"
                .localized(bundle: .mva10Framework),
            "analytics_framework_stories_campaign_internal_visitor_type_key"
                .localized(bundle: .mva10Framework):
                "analytics_framework_stories_campaign_internal_visitor_type"
                .localized(bundle: .mva10Framework),
            "analytics_framework_stories_visitor_addon_balance_usage_remaining_active_key"
                .localized(bundle: .mva10Framework):
                "analytics_stories_visitor_addon_balance_usage_remaining_active"
                .localized(bundle: .main),
            "analytics_framework_stories_visitor_asset_plan_id_active_key"
                .localized(bundle: .mva10Framework):
                "analytics_framework_stories_visitor_asset_plan_id_active"
                .localized(bundle: .mva10Framework),
            "analytics_framework_stories_visitor_asset_plan_name_active_key"
                .localized(bundle: .mva10Framework):
                "analytics_stories_visitor_asset_plan_name_active"
                .localized(bundle: .main),
            "analytics_framework_stories_visitor_asset_plan_type_active_key"
                .localized(bundle: .mva10Framework):
                "analytics_stories_visitor_asset_plan_type_active".localized(bundle: .main),
            "analytics_framework_stories_visitor_bill_amount_current_active_key"
                .localized(bundle: .mva10Framework):
                "analytics_stories_visitor_bill_amount_current_active".localized(bundle: .main),
            "analytics_framework_stories_visitor_bill_date_due_current_active_key"
                .localized(bundle: .mva10Framework):
                "analytics_stories_visitor_bill_date_due_current_active".localized(bundle: .main),
            "analytics_framework_stories_visitor_id_amcvid_key"
                .localized(bundle: .mva10Framework):
                "analytics_framework_stories_visitor_id_amcvid".localized(bundle: .mva10Framework),
            "analytics_framework_stories_visitor_id_asset_active_key"
                .localized(bundle: .mva10Framework):
                "analytics_stories_visitor_id_asset_active".localized(bundle: .main),
            "analytics_framework_stories_visitor_id_asset_list_key"
                .localized(bundle: .mva10Framework):
                "analytics_stories_visitor_id_asset_list".localized(bundle: .main),
            "analytics_framework_stories_visitor_id_asset_primary_key".localized(bundle: .mva10Framework):
                "analytics_stories_visitor_id_asset_primary".localized(bundle: .main),
            "analytics_framework_visitor_login_status_key"
                .localized(bundle: .mva10Framework):
                "analytics_framework_visitor_login_status".localized(bundle: .mva10Framework)
        ]
    }

    static
    func getStoriesAnalyticsCampaignData() -> [String: String] {
        let campaignPhaseValue = "analytics_framework_stories_campaign_internal_phase"
            .localized(bundle: .mva10Framework)
        let campaignPhase = campaignPhaseValue.replacingOccurrences(of: " ", with: ";")
        return [
            "analytics_framework_campaign_internal_id_key".localized(bundle: .mva10Framework):
                "analytics_framework_stories_campaign_internal_id".localized(bundle: .mva10Framework),
            "analytics_framework_stories_campaign_internal_phase_key".localized(bundle: .mva10Framework):
                campaignPhase,
            "analytics_framework_stories_campaign_internal_medium_key".localized(bundle: .mva10Framework):
                "analytics_framework_stories_campaign_internal_medium".localized(bundle: .mva10Framework),
            "analytics_framework_stories_campaign_internal_name_key".localized(bundle: .mva10Framework):
                "analytics_framework_stories_campaign_internal_name".localized(bundle: .mva10Framework),
            "analytics_framework_stories_campaign_internal_offer_detail_key"
                .localized(bundle: .mva10Framework):
                "analytics_framework_stories_campaign_internal_offer_detail"
                .localized(bundle: .mva10Framework),
            "analytics_framework_stories_campaign_internal_type_key".localized(bundle: .mva10Framework):
                "analytics_framework_stories_campaign_internal_type".localized(bundle: .mva10Framework),
            "analytics_framework_stories_page_channel_key".localized(bundle: .mva10Framework):
                "analytics_framework_stories_page_channel".localized(bundle: .mva10Framework),
            "analytics_framework_stories_page_country_key".localized(bundle: .mva10Framework):
                "analytics_framework_stories_page_country".localized(bundle: .mva10Framework),
            "analytics_framework_stories_page_locale_key".localized(bundle: .mva10Framework):
                "analytics_framework_stories_page_locale".localized(bundle: .mva10Framework)
        ]
    }

    static func getFullParameters(data: [String: String]?) -> [String: String] {
        let parameters = VFGStoryManager.getStoriesAnalyticsPageAndVisitorData()
        let fullParameters: [String: String] = parameters
            .merging(VFGStoryManager.getStoriesAnalyticsCampaignData()) { _, added  in added }
        if let data = data {
            return fullParameters.merging(data) { _, added  in added }
        } else {
            return fullParameters
        }
    }
}
