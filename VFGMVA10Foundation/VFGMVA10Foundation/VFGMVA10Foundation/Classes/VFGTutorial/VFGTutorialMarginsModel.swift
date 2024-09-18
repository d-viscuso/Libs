//
//  VFGTutorialMarginsModel.swift
//  VFGMVA10Foundation
//
//  Created by Mohamed Abd ElNasser on 6/7/21.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation

/// Tutorial Margins Model
public struct VFGTutorialMarginsModel {
    /// Hight of the container which carries the image, video or animation
    var uiContentHeight: CGFloat
    /// Space between image/video container and title
    var uiContentToTitle: CGFloat
    /// Space between title and subTitle
    var titleToSubTitle: CGFloat
    /// Space between subTitle and page indicator
    var subTitleToIndicator: CGFloat?
    /// Space between page indicator and primary button
    var indicatorToButton: CGFloat
    /// Space between pageControl dots
    var pageControlSpacing: CGFloat
    /// Size for pageControl dots
    var pageControlDotsSize: CGFloat

    public init(
        uiContentHeight: CGFloat = UIScreen.main.bounds.height * 0.45,
        uiContentToTitle: CGFloat = 30,
        titleToSubTitle: CGFloat = 10,
        subTitleToIndicator: CGFloat? = nil,
        indicatorToButton: CGFloat = 40,
        pageControlSpacing: CGFloat = 20,
        pageControlDotsSize: CGFloat = 8
    ) {
        self.uiContentHeight = uiContentHeight
        self.uiContentToTitle = uiContentToTitle
        self.titleToSubTitle = titleToSubTitle
        self.subTitleToIndicator = subTitleToIndicator
        self.indicatorToButton = indicatorToButton
        self.pageControlSpacing = pageControlSpacing
        self.pageControlDotsSize = pageControlDotsSize
    }
}
