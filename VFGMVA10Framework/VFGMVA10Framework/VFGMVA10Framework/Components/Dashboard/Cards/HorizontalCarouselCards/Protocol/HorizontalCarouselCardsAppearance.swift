//
//  HorizontalCarouselCardsAppearance.swift
//  VFGMVA10Framework
//
//  Created by Ahmed AbdElnabi on 19/12/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

/// An appearance protocol that manages the layout of your horizontal carousel cards view
/// You can use appearance to customize layout height
public protocol HorizontalCarouselCardsAppearance: AnyObject {
    /// Customize horizontal carousel cards view height
    /// You have two layout options .small and .large
    var layout: HorizontalCarouselLayout { get }
}

extension HorizontalCarouselCardsAppearance {
    public var layout: HorizontalCarouselLayout {
        .large
    }
}
