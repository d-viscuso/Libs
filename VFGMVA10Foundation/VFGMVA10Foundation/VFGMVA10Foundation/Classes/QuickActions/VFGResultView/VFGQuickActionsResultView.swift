//
//  VFGQuickActionsResultView.swift
//  VFGMVA10Foundation
//
//  Created by Mohamed Abd ElNasser on 12/30/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation
import Lottie

public class VFGQuickActionsResultView {
    weak var delegate: VFQuickActionsProtocol?
    let title: String
    let isCloseBtnHidden: Bool
    let model: VFGQuickActionsResultModel
    let accessibilityModel: VFGResultViewAccessibilityModel
    let accessibilityVoiceOverModel: VFGResultViewAccessibilityVoiceOverModel?
    var resultView: VFGResultView?
    private var maximumScreenHeightRatio: CGFloat
    public var isUserInteractionEnabled: Bool


    /// A generic UIView that consists of AnimationView, image, title, description, primaryButton, secondaryButton and delegate which controls button actions.
    /// - Parameters:
    ///    - title: The title of the quick action
    ///    - isCloseButtonHidden: A boolean to determine whether closed button is hidden, default false
    ///    - isUserInteractionEnabled: A boolean to determine whether user interaction is enabled, default false

    public init(
        title: String,
        isCloseButtonHidden: Bool = false,
        isUserInteractionEnabled: Bool = false,
        model: VFGQuickActionsResultModel,
        maximumHeightRatio: CGFloat = 0.95,
        accessibilityModel: VFGResultViewAccessibilityModel = VFGResultViewAccessibilityModel(
            imageViewID: "mainIcon",
            titleID: "primaryTitle",
            descriptionID: "secondaryTitle",
            primaryButtonID: "primaryButton",
            secondaryButtonID: "secondaryButton"
        ),
        accessibilityVoiceOverModel: VFGResultViewAccessibilityVoiceOverModel? = nil
    ) {
        self.title = title
        self.isCloseBtnHidden = isCloseButtonHidden
        self.isUserInteractionEnabled = isUserInteractionEnabled
        self.model = model
        self.maximumScreenHeightRatio = maximumHeightRatio
        self.accessibilityModel = accessibilityModel
        self.accessibilityVoiceOverModel = accessibilityVoiceOverModel
    }

    /// Close quick action
    public func closeQuickAction(isCloseButton: Bool, completion: (() -> Void)? = nil) {
        delegate?.closeQuickAction(completion: completion)
        resultView?.delegate?.quickActionsClose(isCloseButton: isCloseButton)
    }
}

extension VFGQuickActionsResultView: VFQuickActionsModel {
    public var quickActionsTitle: String {
        title
    }

    public var titleFont: UIFont {
        model.headlineFont
    }

    public var quickActionsContentView: UIView {
        resultView = VFGResultView.loadXib(bundle: .foundation)
        guard let resultView = resultView else {
            return UIView()
        }
        resultView.configure(
            model: model,
            accessibilityModel: accessibilityModel,
            accessibilityVoiceOverModel: accessibilityVoiceOverModel
        )
        return resultView
    }

    public func quickActionsProtocol(delegate: VFQuickActionsProtocol) {
        self.delegate = delegate
    }

    public func closeQuickAction() {
        closeQuickAction(isCloseButton: true)
    }

    public var quickActionsStyle: VFQuickActionsStyle {
        .white
    }

    public var isCloseButtonHidden: Bool {
        isCloseBtnHidden
    }

    public var maximumHeightRatio: CGFloat {
        self.maximumScreenHeightRatio
    }
}
