//
//  PrimaryPlanServicesHeader.swift
//  VFGMVA10Framework
//
//  Created by Ahmed Sultan on 7/4/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

class PrimaryPlanServicesHeader: UITableViewHeaderFooterView {
    /// Creates a generic identifier for the UITableViewCell depending on it's name/title.
    static var reuseIdentifier: String {
        return String(describing: self)
    }

    @IBOutlet weak var statusLabel: VFGLabel!
    @IBOutlet weak var planNameLabel: VFGLabel!
    @IBOutlet weak var separator: UIView!

    var viewModel: PrimaryPlanServicesHeaderViewModel? {
        didSet {
            configureView()
        }
    }

    @available(iOS 14.0, *)
    override func updateConfiguration(using state: UIViewConfigurationState) {
        backgroundConfiguration = UIBackgroundConfiguration.clear()
    }

    func configureView() {
        statusLabel?.text = viewModel?.statusText
        planNameLabel?.text = viewModel?.primaryPlanName
        statusLabel.textColor = .statusTextColor
        planNameLabel.textColor = .primaryTextColor
        separator.backgroundColor = .firstDivider
        roundCorners()
    }
}
public struct PrimaryPlanServicesHeaderViewModel {
    var statusText: String
    var primaryPlanName: String
    var renewalDate: String

    public init(
        statusText: String,
        primaryPlanName: String,
        renewalDate: String
    ) {
        self.statusText = statusText
        self.primaryPlanName = primaryPlanName
        self.renewalDate = renewalDate
    }
}
