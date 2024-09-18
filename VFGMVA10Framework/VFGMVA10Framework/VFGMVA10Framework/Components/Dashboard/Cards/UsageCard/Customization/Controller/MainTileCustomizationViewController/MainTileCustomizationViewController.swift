//
//  MainTileCustomizationViewController.swift
//  VFGMVA10Framework
//
//  Created by Yasser Soliman on 03/11/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation
/// *DashboardCustomizationViewController* setup
class MainTileCustomizationViewController: DashboardCustomizationViewController {
    required init() {
        super.init(nibName: "DashboardCustomizationViewController", bundle: .mva10Framework)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocalization()
    }
    /// *DashboardCustomizationViewController* localization setup
    func setupLocalization() {
        titleLabel.text = "edit_usage_cards_title".localized(bundle: .mva10Framework)
        subTitleLabel.text = "edit_usage_cards_subtitle".localized(bundle: .mva10Framework)
        confirmButton.setTitle(
            "edit_usage_cards_confirm_cta_button_title".localized(bundle: .mva10Framework),
            for: .normal
        )
    }
    /// *DashboardCustomizationViewController* presentation
    /// - Parameters:
    ///    - usageCardsConfiguration: Dashboard usage cards configurations
    class func present(with usageCardsConfiguration: [CustomizationCardConfigurationModel]) {
        let mainTileCustomizationViewController = instance() as MainTileCustomizationViewController
        mainTileCustomizationViewController.usageCardsConfiguration = usageCardsConfiguration
        let navController = MVA10NavigationController(rootViewController: mainTileCustomizationViewController)
        navController.modalPresentationStyle = .fullScreen
        UIApplication.topViewController()?.present(navController, animated: true, completion: nil)
    }

    override open func confirmButtonDidPress(_ sender: VFGButton) {
        super.confirmButtonDidPress(sender)
        notifyObservers(with: .UsageCardsConfirmButtonDidPress)
    }
}
