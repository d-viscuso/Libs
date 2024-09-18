//
//  OtherVodafoneAppsCell.swift
//  VFGMVA10Framework
//
//  Created by Ahmed AbdElnabi on 17/11/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

/// An enum which represents the two button styles of other vodafone apps..
public enum OtherVodafoneAppsButtonStyle: Int {
    case primary = 0
    case outline = 2
}

class OtherVodafoneAppsCell: UITableViewCell {
    @IBOutlet weak var appIconImageView: VFGImageView!
    @IBOutlet weak var appTitleLabel: VFGLabel!
    @IBOutlet weak var appStateButton: VFGButton!

    let appStoreUrl: String = "https://itunes.apple.com/us/app/id"
    var appStateButtonAction: ((OtherVodafoneAppsItemModel) -> Void)?
    weak var appearance: OtherVodafoneAppsAppearance? {
        didSet {
            setupButtonAppearance()
        }
    }

    private var appInfo: OtherVodafoneAppsItemModel?
    private var appURL: URL?
    private var isAppInstalled: Bool {
        guard let appSchema = appInfo?.appSchema,
            let url = URL(string: appSchema)
        else { return false }
        appURL = url
        return UIApplication.shared.canOpenURL(url)
    }

    public func configure(model: OtherVodafoneAppsItemModel) {
        appearance = appearance == nil ? self : appearance
        appInfo = model
        appIconImageView.download(by: model.iconUrl)
        appTitleLabel.text = model.appName.localized()
        setupButtonAppearance()
    }

    @IBAction func appStateButtonDidPress(_ sender: UIButton) {
        if isAppInstalled {
            guard let url = appURL else { return }
            UIApplication.shared.open(url)
        } else {
            guard let appID = appInfo?.appId else { return }
            UIApplication.openUrl("\(appStoreUrl)\(appID)")
        }
        guard let appInfo = appInfo else { return }
        appStateButtonAction?(appInfo)
    }

    private func setupButtonAppearance() {
        if isAppInstalled {
            setupOpenButtonAppearance()
        } else {
            setupGetButtonAppearance()
        }
    }

    private func setupGetButtonAppearance() {
        guard let appearance = appearance else { return }

        appStateButton.layer.borderWidth = 0.0
        appStateButton.buttonStyle = appearance.getButtonStyle.rawValue
        appStateButton.setTitle(
            "dashboard_app_get_action_label".localized(bundle: Bundle.mva10Framework),
            for: .normal)
    }

    private func setupOpenButtonAppearance() {
        guard let appearance = appearance else { return }

        appStateButton.buttonStyle = appearance.openButtonStyle.rawValue
        appStateButton.setTitle(
            "dashboard_app_open_action_label".localized(bundle: Bundle.mva10Framework),
            for: .normal)
    }
}

extension OtherVodafoneAppsCell: OtherVodafoneAppsAppearance {}
