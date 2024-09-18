//
//  VFGRelatedAppTableViewCell.swift
//  VFGMVA10
//
//  Created by Sandra Morcos on 1/16/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation
/// Dashboard table view cell for related apps
class VFGRelatedAppTableViewCell: UITableViewCell {
    @IBOutlet weak var appIconImageView: VFGImageView!
    @IBOutlet weak var appNameLabel: VFGLabel!
    @IBOutlet weak var appStateButton: VFGButton!
    @IBOutlet weak var separatorView: UIView!
    /// Current app URL
    var appUrl: URL?
    /// Current app store URL
    let appStoreUrl: String = "https://itunes.apple.com/us/app/id"
    var accessibilityIdPrefix = "DBotherApps"
    private var appInfo: VFGSubItem?
    /// Determine whether app can be opened or not
    var isAppInstalled: Bool {
        guard let appSchema = appInfo?.appSchema else { return false }
        guard let url = URL(string: appSchema) else {
            return false
        }
        appUrl = url
        return UIApplication.shared.canOpenURL(url)
    }
    /// Dashboard table view cell for related app configuration
    /// - Parameters:
    ///    - appInfo: Current related app information
    ///    - index: Current related app index
    func configureRelatedAppCell(appInfo: VFGSubItem, for index: Int) {
        self.appInfo = appInfo

        appIconImageView.image = UIImage.image(named: appInfo.icon ?? "")
        appNameLabel.text = appInfo.title?.localized(bundle: Bundle.mva10Framework)

        setupButtonUI()
        setupAccessibilityIds(for: index)
        setupVoiceoverAccessibility()
    }
    /// Related app button UI setup
    func setupButtonUI() {
        if appInfo?.link == nil && isAppInstalled {
            appStateButton.setTitle(Constants.openApp, for: .normal)
            appStateButton.buttonStyle = 1
        } else {
            appStateButton.setTitle(Constants.getApp, for: .normal)
            appStateButton.buttonStyle = 0
            appStateButton.layer.borderWidth = 0.0
        }
    }

    private func setupAccessibilityIds(for index: Int) {
        accessibilityIdPrefix += "\(index + 1)"

        accessibilityIdentifier = accessibilityIdPrefix
        appIconImageView.accessibilityIdentifier = accessibilityIdPrefix + "Icon"
        appNameLabel.accessibilityIdentifier = accessibilityIdPrefix + "Title"
        appStateButton.accessibilityIdentifier = accessibilityIdPrefix + "Button"
    }

    @IBAction func linkToApp(_ sender: VFGButton) {
        if let link = appInfo?.link {
            UIApplication.openUrl(link)
            return
        }

        if isAppInstalled {
            guard let url = appUrl else { return }
            UIApplication.shared.open(url)
        } else {
            guard let appID = appInfo?.appId else { return }
            UIApplication.openUrl("\(appStoreUrl)\(appID)")
        }
    }

    private func moveToAppstoreVoiceOverAction() -> UIAccessibilityCustomAction {
        let actionName = "Opens \(appNameLabel.text ?? "") App"
        return UIAccessibilityCustomAction(
            name: actionName,
            target: self,
            selector: #selector(linkToApp))
    }

    private func setupVoiceoverAccessibility() {
        appStateButton.isAccessibilityElement = true
        appStateButton.accessibilityLabel = "Opens \(appNameLabel.text ?? "") App"
        appStateButton.accessibilityHint = "Redirects You to \(appNameLabel.text ?? "") App"
        appStateButton.accessibilityCustomActions = [moveToAppstoreVoiceOverAction()]
        appIconImageView.isAccessibilityElement = false
        separatorView.isAccessibilityElement = false
    }
}
