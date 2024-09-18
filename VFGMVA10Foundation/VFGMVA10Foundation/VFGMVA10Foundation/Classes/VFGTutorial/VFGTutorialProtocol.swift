//
//  VFGTutorialProtocol.swift
//  VFGLogin
//
//  Created by Mohamed Mahmoud Zaki on 2/26/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation

/// Manage tutorial actions
public protocol VFGTutorialManagerProtocol: AnyObject {
    /// Notify the delegate after clicking on the primary button in the tutorial screen
    func primaryButtonTapped(_ tutorialViewController: VFGTutorialViewController, at index: Int)

    /// Notify the delegate after clicking on the secondary button in the tutorial screen
    func secondaryButtonTapped(_ tutorialViewController: VFGTutorialViewController, at index: Int)

    /// Notify the delegate after moving to a new screen with an index for the new screen
    func tutorialViewController(_ tutorialViewController: VFGTutorialViewController, didMoveToStepAt index: Int)

    /// Notify the delegate when current screen is about to be changed with an index for current screen
    func tutorialViewController(_ tutorialViewController: VFGTutorialViewController, willMoveFromStepAt index: Int)

    /// Notify the delegate after clicking close button
    func closeButtonAction()
}

extension VFGTutorialManagerProtocol {
    public func primaryButtonTapped(_ tutorialViewController: VFGTutorialViewController, at index: Int) {}
    public func secondaryButtonTapped(_ tutorialViewController: VFGTutorialViewController, at index: Int) {}
    public func tutorialViewController(_ tutorialViewController: VFGTutorialViewController, didMoveToStepAt index: Int) {}
    public func tutorialViewController(_ tutorialViewController: VFGTutorialViewController, willMoveFromStepAt index: Int) {}
    public func closeButtonAction() {}
}

/// View model protocol for whole tutorial journey
public protocol VFGTutorialProtocol {
    /// An array of type `VFGTutorialItemProtocol` each element will be displayed in the screen separately, swiping to move to the next element
    var item: [VFGTutorialItemProtocol]? { get }
    /// Animation file bundle name
    var animationFileBundle: Bundle? { get }
    /// Primary button title
    var firstButtonTitle: String? { get }
    /// Secondary button title
    var secondButtonTitle: String? { get }
    /// A Boolean value indicating if tutorial contains video or not, default is `false`
    var containsVideo: Bool? { get }
    /// page indicators tint color, default is `VFGPageControlTint`
    var pageIndicatorTintColor: UIColor? { get }
    /// page current indicator tint color, default is `VFGPageControlCurrentPage`
    var currentPageIndicatorTintColor: UIColor? { get }
    /// A Boolean value indicating if showing or hide close button,  default is `false`
    var shouldShowCloseButton: Bool? { get }
}

public extension VFGTutorialProtocol {
    var containsVideo: Bool? { false }
    var pageIndicatorTintColor: UIColor? { UIColor.VFGPageControlTint }
    var currentPageIndicatorTintColor: UIColor? { UIColor.VFGPageControlCurrentPage }
    var shouldShowCloseButton: Bool? { false }
}

/// View model protocol for every tutorial  item/screen
public protocol VFGTutorialItemProtocol {
    /// Item title
    var title: String? { get }
    /// Item title font
    var titleFont: UIFont? { get }
    /// Item description
    var description: String? { get }
    /// Item description font
    var descriptionFont: UIFont? { get }
    /// Lottie json file name you want to display
    var fileName: String? { get }
    /// Static image to be displayed
    var image: UIImage? { get }
    /// Custom backgroundColor color for the static image
    var imageBackgroundColor: UIColor? { get }
    /// Setting custom titles to buttons in that item, these titles will override `firstButtonTitle` and `firstButtonTitle`
    var customButtonsTitles: (primary: String?, secondary: String?)? { get }
    /// The frame that you want to start the video from
    var startingFrame: CGFloat? { get }
    /// The frame that you want to end the video on
    var endingFrame: CGFloat? { get }
}

extension VFGTutorialItemProtocol {
    public var titleFont: UIFont? { nil }
    public var descriptionFont: UIFont? { nil }
    public var image: UIImage? { nil }
    public var imageBackgroundColor: UIColor? { nil }
    public var customButtonsTitles: (primary: String?, secondary: String?)? { nil }
}
