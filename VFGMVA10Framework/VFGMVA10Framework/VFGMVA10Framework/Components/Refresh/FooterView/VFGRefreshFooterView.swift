//
//  RefreshView.swift
//  VFGMVA10Group
//
//  Created by ahmed mahdy on 10/17/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//
import Foundation
import VFGMVA10Foundation
import UIKit
/// Dashboard collection view footer refresh view
public class VFGRefreshFooterView: UICollectionReusableView, VFGRefreshViewProtocol {
    @IBOutlet weak public var refreshButton: VFGButton!
    @IBOutlet weak public var lastUpdatedLabel: VFGLabel!

    let nibName = "VFGRefreshFooterView"
    /// Refresh view footer shimmer view
    var shimmerView = VFGShimmerView()
    /// Delegate for refresh view actions
    weak var delegate: VFGRefreshViewDelegate?

    public override func awakeFromNib() {
        super.awakeFromNib()
        setupAccessibilityLabels()
    }

    @IBAction func refreshButtonDidPress(_ sender: Any) {
        delegate?.refreshButtonDidPress()
    }
    /// Start refresh view footer shimmering process
    func applyShimmer() {
        refreshButton.isHidden = true
        lastUpdatedLabel.isHidden = true
        if !shimmerView.isDescendant(of: self) {
            self.addSubview(shimmerView)
            shimmerView.translatesAutoresizingMaskIntoConstraints = false
            shimmerView.widthAnchor.constraint(equalToConstant: 200).isActive = true
            shimmerView.heightAnchor.constraint(equalToConstant: 12).isActive = true
            shimmerView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            shimmerView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        }
        shimmerView.startAnimation()
    }
    /// End refresh view footer shimmering process
    func stopShimmer() {
        refreshButton.isHidden = false
        lastUpdatedLabel.isHidden = false
        shimmerView.isHidden = true
    }

    private func refreshButtonVoiceOverAction() -> UIAccessibilityCustomAction {
        let actionName = "Refresh"
        return UIAccessibilityCustomAction(
            name: actionName,
            target: self,
            selector: #selector(refreshButtonDidPress))
    }

    private func setupAccessibilityLabels() {
        refreshButton.isAccessibilityElement = true
        refreshButton.accessibilityLabel = "Refresh Now"
        refreshButton.accessibilityTraits = .button
        refreshButton.accessibilityCustomActions = [refreshButtonVoiceOverAction()]
    }
}
