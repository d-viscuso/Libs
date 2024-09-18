//
//  VFGQuickActionsResultModel.swift
//  VFGMVA10Foundation
//
//  Created by Mohamed Abd ElNasser on 12/30/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation
import Lottie

/// An enum that has different types, every type has a default image and animation
public enum VFGResultViewType {
    case success
    case failure
    /// a type that takes an a custom image
    case customImage(_ image: UIImage?)
    /// a type that takes animation in light & dark  mode
    case customAnimation(light: Animation?, dark: Animation?)
    case none
}

public struct VFGQuickActionsResultModel {
    public var type: VFGResultViewType
    public weak var delegate: VFGResultViewProtocol?
    public var titleText: String
    public var descriptionText: String
    public var traceIDText: String?
    public var buttonTitle: String
    public var secondaryButtonTitle: String?
    /// a property to change the font of the quick action result view headline font
    var headlineFont = UIFont.vodafoneBold(16)
    /// a property to change the font of the headline text
    var titleFont = UIFont.vodafoneRegular(24)
    /// a property to change the font of the description text
    var descriptionFont = UIFont.vodafoneRegular(16)
    /// a property to change the font of the primary button
    var primaryButtonFont = UIFont.vodafoneRegular(19)
    /// a property to change the font of the secondary button
    var secondaryButtonFont = UIFont.vodafoneRegular(19)

    public init(
        type: VFGResultViewType,
        delegate: VFGResultViewProtocol?,
        titleText: String,
        descriptionText: String,
        traceIDText: String? = nil,
        primaryButtonTitle: String,
        secondaryButtonTitle: String? = nil,
        titleFont: UIFont = .vodafoneRegular(25),
        descriptionFont: UIFont = .vodafoneBold(16),
        headlineFont: UIFont = .vodafoneBold(17),
        primaryButtonFont: UIFont = .vodafoneRegular(18),
        secondaryButtonFont: UIFont = .vodafoneRegular(18)
    ) {
        self.type = type
        self.delegate = delegate
        self.titleText = titleText
        self.descriptionText = descriptionText
        self.traceIDText = traceIDText
        self.buttonTitle = primaryButtonTitle
        self.secondaryButtonTitle = secondaryButtonTitle
        self.titleFont = titleFont
        self.descriptionFont = descriptionFont
        self.headlineFont = headlineFont
        self.primaryButtonFont = primaryButtonFont
        self.secondaryButtonFont = secondaryButtonFont
    }
}
