//
//  VFGTrayViewController+TobiSetup.swift
//  VFGMVA10Framework
//
//  Created by Esraa Eldaltony on 2/19/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation
import VFGMVA10Foundation

extension VFGTrayViewController {
    func addTOBIShadow() {
        tobiView.layer.cornerRadius = tobiView.bounds.height / 2
        tobiView.layer.shadowColor = UIColor.black.cgColor
        tobiView.layer.shadowOffset = CGSize(width: 0, height: -2)
        tobiView.layer.shadowOpacity = 0.16
        tobiView.layer.shadowRadius = 4.0
    }

    func setupTOBIBadge() {
        tobiBadgeView.layer.cornerRadius = (tobiBadgeView.bounds.height) / 2
    }

    func showTobi(_ isTobiEnabled: Bool) {
        tobiFace.isHidden = !isTobiEnabled
        tobiLessImageView?.isHidden = isTobiEnabled
    }
    /// internal method to be used for message enabled types only if text is empty or nil will hide the badge
    func setTobiBadge(badgeLabel: String?) {
        guard let badgeLabel = badgeLabel, !(badgeLabel.isEmpty)  else {
            tobiBadgeView.isHidden = true
            tobiBadgeView.badgeModel?.text?.removeAll()
            return
        }
        tobiBadgeView.isHidden = false
        tobiBadgeView.update(with: BadgeModel(text: badgeLabel))
    }

    /// to update current model color on the same model
    public func updateTOBIBadge(with color: UIColor, for key: String) {
        guard var model = tobiBadgeView.badgeModel else {
            showTOBIBadge(with: BadgeModel(text: "", backgroundColor: color), for: key)
            return }
        tobiBadgeView.isHidden = false
        model.backgroundColor = color
        tobiBadgeView.update(with: model)
        tobiBadgeModel[key] = tobiBadgeView.badgeModel
    }

    /// to update current badgeView model with new model
    public func showTOBIBadge(with model: BadgeModel, for key: String) {
        tobiBadgeView.isHidden = false
        tobiBadgeView.badgeModel = model
        tobiBadgeView.update(with: model)
        tobiBadgeModel[key] = model
    }

    /// for dismiss from presentedVC to the PresentingVC
    public func restoreTOBIBadge(for key: String) {
        if let badgeModel = tobiBadgeModel[key] {
            tobiBadgeView.isHidden = false
            tobiBadgeView.badgeModel = badgeModel
            tobiBadgeView.update(with: badgeModel)
        } else {
            removeTobiBadge()
        }
    }

    public func clearAllTobiBadges() {
        tobiBadgeModel = [:]
    }

    public func clearTobiBadgeModel(for key: String) {
        tobiBadgeModel[key] = nil
    }

    public func removeTobiBadge() {
        tobiBadgeView.isHidden = true
        tobiBadgeView.badgeModel = nil
    }

    func setupTOBIMessage(key: String) {
        titleLabel?.text = tobiMessagesModel[key]?.message
        if let animation = tobiMessagesModel[key]?.tobiAnimation {
            tobiFace.begin(animation)
        }
        isTobiMessageViewed = false
    }
}

public struct TobiMessageModel {
    public var message: String?
    public var tobiAnimation: VFGTOBIAnimation?
    public var tobiBadge: String?
    public var tobiMessageTimer: Double?

    public init(
        message: String?,
        tobiAnimation: VFGTOBIAnimation?,
        tobiBadge: String?,
        tobiMessageTimer: Double
    ) {
        self.message = message
        self.tobiAnimation = tobiAnimation
        self.tobiBadge = tobiBadge
        self.tobiMessageTimer = tobiMessageTimer
    }
}
