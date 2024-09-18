//
//  VFGTutorialViewController.swift
//  VFGLogin
//
//  Created by Mohamed Mahmoud Zaki on 2/25/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import UIKit
import Lottie

/// Tutorial view controller
open class VFGTutorialViewController: UIViewController {
    @IBOutlet weak var primaryButton: VFGButton!
    @IBOutlet weak var secondaryButton: VFGButton!
    @IBOutlet weak var animationView: AnimationView!
    @IBOutlet weak var pageControl: VFGPageControl!
    @IBOutlet weak var itemsStackView: UIStackView!
    @IBOutlet weak var itemsScrollView: UIScrollView!
    @IBOutlet weak var uiContentToTitleConstraint: NSLayoutConstraint!
    @IBOutlet weak var subTitleToIndicatorConstraint: NSLayoutConstraint!
    @IBOutlet weak var indicatorToButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var closeButton: VFGButton!

    var itemViews: [VFGTutorialItemView] = []
    var currentAnimation: String?
    var currentPage = 0
    public weak var delegate: VFGTutorialManagerProtocol?
    public var dataSource: VFGTutorialProtocol?
    static var margins: VFGTutorialMarginsModel?
    public var analyticsManager = VFGAnalyticsManager.self

    /// A method used to instantiate tutorial view controller from storyboard.
    /// - Parameters:
    ///   - dataModel: An object of type *VFGTutorialProtocol* that represents the data source for tutorial view controller.
    ///   - customMargins: An object of type *VFGTutorialMarginsModel* that holds the margin values for tutorial view controller.
    /// - Returns: An object of type *VFGTutorialViewController*.
    public class func viewController(
        with dataModel: VFGTutorialProtocol?,
        customMargins: VFGTutorialMarginsModel? = nil
    ) -> VFGTutorialViewController {
        margins = customMargins

        let storyboard = UIStoryboard(name: "Tutorial", bundle: Bundle.foundation)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "VFGTutorialViewController")
            as? VFGTutorialViewController else {
                return VFGTutorialViewController()
        }
        viewController.dataSource = dataModel
        return viewController
    }

    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animationView.play()
        itemViews[currentPage].video.player?.play()
    }

    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(
            self,
            name: UIApplication.willEnterForegroundNotification,
            object: nil)

        NotificationCenter.default.removeObserver(
            self,
            name: UIApplication.didEnterBackgroundNotification,
            object: nil)
        animationView.pause()
        itemViews.forEach { $0.video.player?.pause() }
    }

    override open func viewDidLoad() {
        super.viewDidLoad()
        setupItems(model: VFGTutorialViewController.margins ?? VFGTutorialMarginsModel())
        setupUIContent()
        setupButtons(at: 0)
        setUpPageControl()
        setupMargins(model: VFGTutorialViewController.margins ?? VFGTutorialMarginsModel())
        if UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft ||
            UIView.appearance().semanticContentAttribute == .forceRightToLeft {
            itemsScrollView.transform = CGAffineTransform(scaleX: -1, y: 1)
            itemsStackView.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
        addForegroundObserver()
        addBackgroundObserver()
        trackView()
        // accessibility identifier
        setPageIndicatorAccessibilityIdentifier()
        setVideoAccessibilityIdentifier()
        addAccessibilityForVoiceOver()
    }
    /// setup page control 
    private func setUpPageControl() {
        pageControl.isDotsEqualSize = true
        let numberOfPageControlItems = dataSource?.item?.count ?? 0
        pageControl.numberOfPages = numberOfPageControlItems == 1 ? 0 : numberOfPageControlItems
        pageControl.dotColor = dataSource?.pageIndicatorTintColor ?? .VFGPageControlTint
        pageControl.selectedColor = dataSource?.currentPageIndicatorTintColor ?? .VFGPageControlCurrentPage
    }
    /// Set AccessibilityIdentifier for page control
    private func setPageIndicatorAccessibilityIdentifier() {
        pageControl.isAccessibilityElement = true
        pageControl.accessibilityIdentifier = "tutorialBubblePageIndicator"
    }
    // Set accessibility identifier for video
    private func setVideoAccessibilityIdentifier() {
        animationView.isAccessibilityElement = true
        animationView.accessibilityIdentifier = "tutorialVideoView"
    }
    private func setupItems(model: VFGTutorialMarginsModel) {
        for index in 0..<(dataSource?.item?.count ?? 0) {
            guard let itemView: VFGTutorialItemView = UIView.loadXib(bundle: .foundation) else {
                return
            }
            itemView.configure(
                titleText: dataSource?.item?[index].title,
                titleFont: dataSource?.item?[index].titleFont ?? .vodafoneLite(29),
                descriptionText: dataSource?.item?[index].description,
                descriptionFont: dataSource?.item?[index].descriptionFont
                    ?? .vodafoneRegular(19),
                titleToSubTitleMargin: VFGTutorialViewController.margins?.titleToSubTitle ?? 10,
                image: dataSource?.item?[index].image,
                imageBackgroundColor: dataSource?.item?[index].imageBackgroundColor)
            itemView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
            itemViews.append(itemView)
            if dataSource?.item?[index].image != nil {
                itemsScrollView.topAnchor.constraint(equalTo: animationView.topAnchor).isActive = true
                itemView.tutorialImageView.heightAnchor.constraint(
                    equalToConstant: model.uiContentHeight).isActive = true
            } else if dataSource?.containsVideo ?? false {
                itemView.videoContainerView.isHidden = false
                itemViews[index].video.localVideoString = dataSource?.item?[index].fileName
                itemsScrollView.topAnchor.constraint(equalTo: animationView.topAnchor).isActive = true
                itemView.videoContainerView.heightAnchor.constraint(
                    equalToConstant: model.uiContentHeight).isActive = true
            } else {
                itemView.tutorialImageView.isHidden = true
            }
            itemsStackView.addArrangedSubview(itemView)
        }
    }

    private func setupUIContent() {
        closeButton.isHidden = !(dataSource?.shouldShowCloseButton ?? false)
        closeButton.setTitle("", for: .normal)
        closeButton.setImage(VFGFoundationAsset.Image.icClose, for: .normal)
        closeButton.accessibilityIdentifier = "tutorialCloseButton"
        animationView.backgroundBehavior = .pauseAndRestore
        if dataSource?.item?.first?.image != nil {
            showImageView()
        } else if dataSource?.containsVideo ?? false, dataSource?.item?.first?.image == nil {
            animationView.isHidden = true
            itemViews.first?.videoContainerView.isHidden = false
            itemViews.first?.video.localVideoString = dataSource?.item?.first?.fileName
            itemViews.first?.video.player?.play()
        } else {
            showAnimationView()
            animationView.animation = Animation.named(
                dataSource?.item?.first?.fileName ?? "",
                bundle: dataSource?.animationFileBundle ?? Bundle.main
            )
            currentAnimation = dataSource?.item?.first?.fileName
            animationView.play(
                fromFrame: dataSource?.item?.first?.startingFrame,
                toFrame: dataSource?.item?.first?.endingFrame ?? 0,
                completion: nil
            )
            animationView.contentMode = .scaleAspectFit
        }
    }

    private func setupButtons(at index: Int) {
        guard
            let items = dataSource?.item,
            index < items.count else { return }
        var primaryTitle: String?
        var secondaryTitle: String?

        if let customTitles = items[index].customButtonsTitles {
            primaryTitle = customTitles.primary
            secondaryTitle = customTitles.secondary
        } else {
            primaryTitle = dataSource?.firstButtonTitle
            secondaryTitle = dataSource?.secondButtonTitle
        }

        if let primaryTitle = primaryTitle {
            primaryButton.setTitle(primaryTitle, for: .normal)
            primaryButton.accessibilityIdentifier = "tutorialPrimaryButton"
            primaryButton.isHidden = false
        } else {
            primaryButton.isHidden = true
        }

        if let secondaryTitle = secondaryTitle {
            secondaryButton.setTitle(secondaryTitle, for: .normal)
            secondaryButton.accessibilityIdentifier = "tutorialSecondaryButton"
            secondaryButton.isHidden = false
        } else {
            secondaryButton.isHidden = true
        }
    }

    /// A method used to move to the next tutorial page.
    /// - Parameter animated: A boolean flag that is used to enable or disable animation.
    public func moveToNextPage(animated: Bool = true) {
        guard currentPage < (dataSource?.item?.count ?? 0) - 1 else { return }
        let newPage = currentPage + 1
        updateSelection(oldPage: currentPage, newPage: newPage, animated: animated)
        pageControl.currentPage = newPage
    }

    /// A method used to move to the previous tutorial page.
    /// - Parameter animated: A boolean flag that is used to enable or disable animation.
    public func moveToPreviousPage(animated: Bool = true) {
        guard currentPage > 0 else { return }
        let newPage = currentPage - 1
        updateSelection(oldPage: currentPage, newPage: newPage, animated: animated)
        pageControl.currentPage = newPage
    }

    private func setupMargins(model: VFGTutorialMarginsModel) {
        let minimumPadding: CGFloat = 17
        animationView.heightAnchor.constraint(equalToConstant: model.uiContentHeight).isActive = true
        uiContentToTitleConstraint.constant = model.uiContentToTitle
        if let subTitleToIndicator = model.subTitleToIndicator {
            subTitleToIndicatorConstraint.constant = subTitleToIndicator
            indicatorToButtonConstraint.isActive = false
            indicatorToButtonConstraint = pageControl.bottomAnchor.constraint(
                lessThanOrEqualTo: primaryButton.topAnchor,
                constant: -minimumPadding)
            indicatorToButtonConstraint.isActive = true
        } else {
            indicatorToButtonConstraint.constant = model.indicatorToButton
        }
        view.layoutIfNeeded()
    }

    @IBAction func primaryButtonDidPress(_ sender: Any) {
        primaryButtonAction()
    }

    @IBAction func secondaryButtonDidPress(_ sender: Any) {
        secondaryButtonAction()
    }

    @IBAction func pageControlValueChanged(_ sender: UIPageControl) {
        let newPage = sender.currentPage
        updateSelection(oldPage: currentPage, newPage: newPage, animated: false)
    }

    @IBAction func closeButton(_ sender: Any) {
        delegate?.closeButtonAction()
    }

    /// A method used to move to new tutorial page by updating UI content and setup buttons of new tutorial page.
    /// - Parameters:
    ///   - oldPage: An integer that represents the page you moved from.
    ///   - newPage: An integer that represents the page you moved to.
    ///   - animated: A boolean flag that is used to enable or disable animation.
    func updateSelection(oldPage: Int, newPage: Int, animated: Bool) {
        delegate?.tutorialViewController(self, willMoveFromStepAt: oldPage)
        let x = CGFloat(newPage) * itemsScrollView.frame.size.width
        itemsScrollView.setContentOffset(CGPoint(x: x, y: .zero), animated: true)
        updateUIContent(oldPage: currentPage, newPage: newPage)
        setupButtons(at: newPage)
        currentPage = newPage
        delegate?.tutorialViewController(self, didMoveToStepAt: newPage)
    }

    @objc func primaryButtonAction() {
        delegate?.primaryButtonTapped(self, at: currentPage)
    }

    @objc func secondaryButtonAction() {
        delegate?.secondaryButtonTapped(self, at: currentPage)
    }
}

extension VFGTutorialViewController: UIScrollViewDelegate {
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let cellWidth = view.frame.width
        let oldPage = pageControl.currentPage
        let offsetX = scrollView.contentOffset.x
        let newPage = Int(offsetX / cellWidth)
        delegate?.tutorialViewController(self, willMoveFromStepAt: oldPage)
        updatePaging(newPage)
        updateUIContent(oldPage: oldPage, newPage: newPage)
        setupButtons(at: newPage)
        delegate?.tutorialViewController(self, didMoveToStepAt: newPage)
    }

    func updatePaging(_ newPage: Int) {
        pageControl.currentPage = newPage
        currentPage = newPage
    }

    func updateUIContent(oldPage: Int, newPage: Int) {
        guard
            oldPage != newPage,
            dataSource?.item?.count ?? 0 > newPage else { return }
        if dataSource?.item?[newPage].image != nil {
            showImageView()
        } else if dataSource?.containsVideo ?? false {
            itemViews[newPage].video.avplayer?.play()
        } else {
            showAnimationView()
            setupAnimation(at: newPage)
        }
        itemViews[oldPage].video.avplayer?.seek(to: .zero)
        itemViews[oldPage].video.avplayer?.pause()
    }

    private func setupAnimation(at index: Int) {
        if currentAnimation == dataSource?.item?[index].fileName {
            animationView.play(
                fromFrame: dataSource?.item?[index].startingFrame,
                toFrame: dataSource?.item?[index].endingFrame ?? 0,
                completion: nil)
        } else {
            currentAnimation = dataSource?.item?[index].fileName
            animationView.animation = Animation.named(
                dataSource?.item?[index].fileName ?? "",
                bundle: dataSource?.animationFileBundle ?? Bundle.main)
            animationView.play()
        }
    }

    private func showAnimationView() {
        animationView.isHidden = false
        itemViews.forEach { $0.videoContainerView.isHidden = true }
    }

    private func showImageView() {
        animationView.isHidden = true
    }
}

// MARK: - Tealium Tags
extension VFGTutorialViewController {
    func trackView() {
        let journeyType = "Pre-Onboarding Tutorial"
        let parameters: [String: String] = [
            VFGAnalyticsKeys.pageName: journeyType,
            VFGAnalyticsKeys.journeyType: journeyType
        ]
        analyticsManager.trackView( parameters: parameters, bundle: .foundation)
    }
}


extension VFGTutorialViewController {
    // A method used to add observer for the screen when enters foreground.
    func addForegroundObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didMoveToForeground),
            name: UIApplication.willEnterForegroundNotification,
            object: nil)
    }

    // A method used to add observer for the screen when enters background.
    func addBackgroundObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didMoveToBackground),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil)
    }

    @objc func didMoveToBackground() {
        itemViews[currentPage].video.player?.pause()
    }

    @objc func didMoveToForeground() {
        itemViews[currentPage].video.player?.play()
    }
}
