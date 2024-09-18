//
//  VFGTutorialJourneyViewController.swift
//  VFGMVA10Foundation
//
//  Created by Adel Aref on 26/09/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import UIKit
import Lottie

/// Tutorial journey view controller
open class VFGTutorialJourneyViewController: UIViewController {
    @IBOutlet weak var primaryButton: VFGButton!
    @IBOutlet weak var animationView: AnimationView!
    @IBOutlet weak var pageControl: VFGPageControl!
    @IBOutlet weak var itemsStackView: UIStackView!
    @IBOutlet weak var itemsScrollView: UIScrollView!
    @IBOutlet weak var uiContentToTitleConstraint: NSLayoutConstraint!
    @IBOutlet weak var closeButton: VFGButton!
    @IBOutlet weak var backButton: VFGButton!

    var itemViews: [VFGTutorialItemView] = []
    var currentAnimation: String?
    var currentPage = 0
    public weak var delegate: VFGTutorialJourneyManagerProtocol?
    public var dataSource: VFGTutorialJourneyProtocol?
    static var margins: VFGTutorialMarginsModel?
    public var analyticsManager = VFGAnalyticsManager.self

    /// A method used to instantiate tutorial view controller from storyboard.
    /// - Parameters:
    ///   - dataModel: An object of type *VFGTutorialJourneyProtocol* that represents the data source for tutorial view controller.
    ///   - customMargins: An object of type *VFGTutorialMarginsModel* that holds the margin values for tutorial journey view controller.
    /// - Returns: An object of type *VFGTutorialJourneyViewController*.
    public class func viewController(
        with dataModel: VFGTutorialJourneyProtocol?,
        customMargins: VFGTutorialMarginsModel? = nil
    ) -> VFGTutorialJourneyViewController {
        margins = customMargins
        let storyboard = UIStoryboard(name: "Tutorial", bundle: Bundle.foundation)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "TutorialJourneyViewController")
            as? VFGTutorialJourneyViewController else {
            return VFGTutorialJourneyViewController()
        }
        viewController.dataSource = dataModel
        return viewController
    }

    override open func viewDidLoad() {
        super.viewDidLoad()
        setupUIContent()
        setupButtonPrimaryButton(at: 0)
        setUpPageControl(model: VFGTutorialJourneyViewController.margins ?? createTutorialMargins())
        setupItems(model: VFGTutorialJourneyViewController.margins ?? createTutorialMargins())
        setupMargins(model: VFGTutorialJourneyViewController.margins ?? createTutorialMargins())

        if UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft ||
            UIView.appearance().semanticContentAttribute == .forceRightToLeft {
            itemsScrollView.transform = CGAffineTransform(scaleX: -1, y: 1)
            itemsStackView.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
        addForegroundObserver()
        addBackgroundObserver()
        setVideoAccessibilityIdentifier()
        setPageIndicatorAccessibilityIdentifier()
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

    /// create margin tutorial journey model
    func createTutorialMargins() -> VFGTutorialMarginsModel {
        let bootomViewHight = 222.0
        let topInset = UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0
        let bottomInset = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        let insets = topInset + bottomInset
        return VFGTutorialMarginsModel(
            uiContentHeight: UIScreen.main.bounds.height - bootomViewHight - insets,
            uiContentToTitle: 0,
            titleToSubTitle: 16,
            subTitleToIndicator: nil,
            indicatorToButton: 24)
    }

    /// setup page control
    private func setUpPageControl(model: VFGTutorialMarginsModel) {
        pageControl.isDotsEqualSize = true
        pageControl.spacing = model.pageControlSpacing
        pageControl.dotSize = model.pageControlDotsSize
        let numberOfPageControlItems = dataSource?.item?.count ?? 0
        pageControl.numberOfPages = numberOfPageControlItems == 1 ? 0 : numberOfPageControlItems
        pageControl.dotColor = dataSource?.pageIndicatorTintColor ?? .VFGPageControlMVA12Tint
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
                imageBackgroundColor: dataSource?.item?[index].imageBackgroundColor,
                showDividerView: dataSource?.shouldShowDividerView)
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

    private func setupButtonPrimaryButton(at index: Int) {
        guard
            let items = dataSource?.item,
            index < items.count else { return }

        if let primaryTitle = items[index].primaryTitle {
            primaryButton.setTitle(primaryTitle, for: .normal)
            primaryButton.accessibilityIdentifier = "tutorialPrimaryButton"
            primaryButton.isHidden = false
        } else {
            primaryButton.setTitle(dataSource?.firstButtonTitle, for: .normal)
            primaryButton.isHidden = true
        }
    }

    private func setupMargins(model: VFGTutorialMarginsModel) {
        animationView.heightAnchor.constraint(equalToConstant: model.uiContentHeight).isActive = true
        uiContentToTitleConstraint.constant = model.uiContentToTitle
        view.layoutIfNeeded()
    }

    @IBAction func primaryButtonDidPress(_ sender: Any) {
        primaryButtonAction()
    }

    @IBAction func closeButtonDidPress(_ sender: Any) {
        delegate?.didPressCloseTutorialButton()
    }

    @IBAction func backButtonDidPress(_ sender: Any) {
        backButtonAction()
    }

    /// A method used to move to new tutorial page by updating UI content and setup buttons of new tutorial page.
    /// - Parameters:
    ///   - oldPage: An integer that represents the page you moved from.
    ///   - newPage: An integer that represents the page you moved to.
    ///   - animated: A boolean flag that is used to enable or disable animation.
    func updateSelection(oldPage: Int, newPage: Int, animated: Bool) {
        let x = CGFloat(newPage) * itemsScrollView.frame.size.width
        itemsScrollView.setContentOffset(CGPoint(x: x, y: .zero), animated: true)
        updateUIContent(oldPage: currentPage, newPage: newPage)
        setupButtonPrimaryButton(at: newPage)
        currentPage = newPage
    }

    @objc func primaryButtonAction() {
        let lastIndex = (dataSource?.item?.count ?? 0) - 1
        if currentPage == lastIndex {
            delegate?.didEndingTutorialJourney()
        } else {
            moveToNextPage()
        }
    }

    @objc func backButtonAction() {
        if currentPage == 1 {
            backButton.isHidden = true
        }
        moveToPreviousPage()
    }

    /// A method used to move to the next tutorial page.
    /// - Parameter animated: A boolean flag that is used to enable or disable animation.
    public func moveToNextPage(animated: Bool = true) {
        guard currentPage < (dataSource?.item?.count ?? 0) - 1 else { return }
        let newPage = currentPage + 1
        updateSelection(oldPage: currentPage, newPage: newPage, animated: animated)
        pageControl.currentPage = newPage
        backButton.isHidden = false
    }

    /// A method used to move to the previous tutorial page.
    /// - Parameter animated: A boolean flag that is used to enable or disable animation.
    public func moveToPreviousPage(animated: Bool = true) {
        guard currentPage > 0 else { return }
        let newPage = currentPage - 1
        updateSelection(oldPage: currentPage, newPage: newPage, animated: animated)
        pageControl.currentPage = newPage
    }
}

extension VFGTutorialJourneyViewController: UIScrollViewDelegate {
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let cellWidth = view.frame.width
        let oldPage = pageControl.currentPage
        let offsetX = scrollView.contentOffset.x
        let newPage = Int(offsetX / cellWidth)
        updatePaging(newPage)
        updateUIContent(oldPage: oldPage, newPage: newPage)
        setupButtonPrimaryButton(at: newPage)
        setupBackButtonVisiblity(at: newPage)
    }

    func setupBackButtonVisiblity(at index: Int) {
        let hiddenStateIndex = 0

        if index == hiddenStateIndex {
            backButton.isHidden = true
        } else {
            backButton.isHidden = false
        }
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

extension VFGTutorialJourneyViewController {
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
