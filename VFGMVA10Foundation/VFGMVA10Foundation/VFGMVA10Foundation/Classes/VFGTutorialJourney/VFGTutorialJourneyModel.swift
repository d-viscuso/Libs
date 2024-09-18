//
//  VFGTutorialJourneyModel.swift
//  VFGMVA10Foundation
//
//  Created by Adel Aref on 27/09/2022.
//

import Foundation
import UIKit

public struct VFGTutorialJourneyModel: VFGTutorialJourneyProtocol {
    public var item: [VFGTutorialJourneyItemProtocol]?
    public var firstButtonTitle: String?
    public var animationFileBundle: Bundle?
    public var containsVideo: Bool?
    public var shouldShowCloseButton: Bool?
    public var shouldShowDividerView: Bool?
    public var pageIndicatorTintColor: UIColor?
    public var imageViewContentMode: UIView.ContentMode?

    public init(
        item: [VFGTutorialJourneyItemProtocol]?,
        firstButtonTitle: String?,
        animationFileBundle: Bundle?,
        containsVideo: Bool?,
        showCloseButton: Bool?,
        shouldShowDividerView: Bool?,
        pageIndicatorTintColor: UIColor?,
        imageViewContentMode: UIView.ContentMode? = .scaleAspectFit
    ) {
        self.item = item
        self.firstButtonTitle = firstButtonTitle
        self.animationFileBundle = animationFileBundle
        self.containsVideo = containsVideo
        self.shouldShowCloseButton = showCloseButton
        self.shouldShowDividerView = shouldShowDividerView
        self.imageViewContentMode = imageViewContentMode
    }
}

public struct VFGTutorialJourneyItem: VFGTutorialJourneyItemProtocol {
    public var title: String?
    public var titleFont: UIFont?
    public var description: String?
    public var descriptionFont: UIFont?
    public var primaryTitle: String?
    public var fileName: String?
    public var image: UIImage?
    public var startingFrame: CGFloat?
    public var endingFrame: CGFloat?

    public init(
        title: String?,
        titleFont: UIFont?,
        description: String?,
        descriptionFont: UIFont?,
        primaryTitle: String?,
        fileName: String?,
        image: UIImage?,
        startingFrame: CGFloat?,
        endingFrame: CGFloat?
    ) {
        self.title = title
        self.titleFont = titleFont
        self.description = description
        self.descriptionFont = descriptionFont
        self.primaryTitle = primaryTitle
        self.fileName = fileName
        self.image = image
        self.startingFrame = startingFrame
        self.endingFrame = endingFrame
    }
}
