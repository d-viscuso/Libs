//
//  VFGTutorialJourneyProtocol.swift
//  VFGMVA10Foundation
//
//  Created by Adel Aref on 27/09/2022.
//

import UIKit
import Foundation
/// Manage tutorial actions
public protocol VFGTutorialJourneyManagerProtocol: AnyObject {
    /// Notify the delegate after clicking close button
    func didPressCloseTutorialButton()

    /// Notify the delegate after clicking brousing tutorial journey
    func didEndingTutorialJourney()
}

/// View model protocol for whole tutorial journey
public protocol VFGTutorialJourneyProtocol {
    /// An array of type `VFGTutorialJourneyProtocol` each element will be displayed in the screen separately, swiping to move to the next element
    var item: [VFGTutorialJourneyItemProtocol]? { get }
    /// Animation file bundle name
    var animationFileBundle: Bundle? { get }
    /// Primary button title
    var firstButtonTitle: String? { get }
    /// A Boolean value indicating if tutorial contains video or not, default is `false`
    var containsVideo: Bool? { get }
    /// page indicators tint color, default is `VFGPageControlTint`
    var pageIndicatorTintColor: UIColor? { get }
    /// page current indicator tint color, default is `VFGPageControlCurrentPage`
    var currentPageIndicatorTintColor: UIColor? { get }
    /// A Boolean value indicating if showing or hide close button,  default is `false`
    var shouldShowCloseButton: Bool? { get }
    /// A Boolean value indicating if showing or hide divder view,  default is `false`
    var shouldShowDividerView: Bool? { get }
    /// A var that indicates if the image view should be aspect fit or aspect fill.
    var imageViewContentMode: UIView.ContentMode? { get }
}

public extension VFGTutorialJourneyProtocol {
    var containsVideo: Bool? { false }
    var pageIndicatorTintColor: UIColor? { UIColor.VFGPageControlMVA12Tint }
    var currentPageIndicatorTintColor: UIColor? { UIColor.VFGPageControlCurrentPage }
    var shouldShowCloseButton: Bool? { true }
    var shouldShowDividerView: Bool? { true }
    var imageViewContentMode: UIView.ContentMode? { .scaleAspectFit }
}

/// View model protocol for every tutorial  item/screen
public protocol VFGTutorialJourneyItemProtocol {
    /// Item title
    var title: String? { get }
    /// Item title font
    var titleFont: UIFont? { get }
    /// Item description
    var description: String? { get }
    /// Item description font
    var descriptionFont: UIFont? { get }
    /// primary button title
    var primaryTitle: String? { get }
    /// Lottie json file name you want to display
    var fileName: String? { get }
    /// Static image to be displayed
    var image: UIImage? { get }
    /// Custom backgroundColor color for the static image
    var imageBackgroundColor: UIColor? { get }
    /// The frame that you want to start the video from
    var startingFrame: CGFloat? { get }
    /// The frame that you want to end the video on
    var endingFrame: CGFloat? { get }
}

extension VFGTutorialJourneyItemProtocol {
    public var titleFont: UIFont? { nil }
    public var descriptionFont: UIFont? { nil }
    public var image: UIImage? { nil }
    public var imageBackgroundColor: UIColor? { nil }
}
