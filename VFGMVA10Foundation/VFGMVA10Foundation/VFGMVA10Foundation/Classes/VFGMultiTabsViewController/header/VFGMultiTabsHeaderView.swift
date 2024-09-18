//
//  VFGMultiTabsHeaderView.swift
//  VFGMVA10Foundation
//
//  Created by Moataz Akram on 12/4/21.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import UIKit

/// A delegate protocol manages user interactions with the multi tabs header's contents,
/// including top-up button press
public protocol MultiTabsHeaderViewDelegate: AnyObject {
    /// A method invoked after the top-up button pressed
    func topUpButtonDidPress()
}

/// A view that is used as a header for multi tabs view controller,
/// you can customize multi tabs header content by passing your own *MultiTabsHeaderViewModel*
public class VFGMultiTabsHeaderView: UIView, MultiTabsHeaderViewProtocol {
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var titleLabel: VFGLabel!
    @IBOutlet weak var subtitleBoldText: VFGLabel!
    @IBOutlet weak var subtitleRegText: VFGLabel!
    @IBOutlet weak var secondSubtitleText: VFGLabel!
    @IBOutlet weak public var lastUpdatedLabel: VFGLabel!
    @IBOutlet weak public var refreshButton: VFGButton!
    @IBOutlet weak var topUpHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var topUpButton: VFGButton!
    @IBOutlet weak var billingButton: VFGButton!
    @IBOutlet weak var subTitleContainer: UIStackView!

    var topupButtonHeight: CGFloat = 32
    var viewModel: MultiTabsHeaderViewModel?
    public var refreshManager: VFGRefreshManager?
    public weak var delegate: (MultiTabsHeaderViewDelegate & VFGRefreshViewDelegate)?

    public func configure(with viewModel: MultiTabsHeaderViewModel?) {
        self.viewModel = viewModel
        titleLabel.text = viewModel?.title
        subtitleBoldText.text = viewModel?.subtitleBoldText
        if subtitleBoldText.text == nil || subtitleBoldText.text?.isEmpty ?? false {
            subtitleBoldText.removeFromSuperview()
        }
        subtitleRegText.text = viewModel?.subtitleRegText
        secondSubtitleText.text = viewModel?.secondSubtitleText
        topUpHeightConstraint.constant = (viewModel?.enableTopup ?? false) ? topupButtonHeight : 0.0
        // Soho
        billingButton.setTitle(viewModel?.billingBtnTitle, for: .normal)
        billingButton.isHidden = !(viewModel?.enableBilling ?? false)
        lastUpdatedLabel.isHidden = viewModel?.enableBilling ?? false
        refreshButton.isHidden = viewModel?.enableBilling ?? false
        titleLabel.isHidden = viewModel?.hideTitle ?? false
        subTitleContainer.isHidden = viewModel?.hideSubtitleText ?? false
        secondSubtitleText.isHidden = viewModel?.hideSecondSubtitleText ?? false
        setupAccessibility()
    }

    public func updateSubtitle(text: String) {
        subtitleBoldText.text = text
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    private func commonInit() {
        xibSetup()
        refreshManager = VFGRefreshManager(
            lastUpdatedTimeKey: "multiTabsLastUpdatedTime",
            refreshView: self,
            refreshStatusModel: viewModel?.refreshStatusModel ?? VFGRefreshStatusModel()
        )
        addForegroundObserver()
        addBackgroundObserver()
    }

    func xibSetup() {
        if let view = loadViewFromNib(
            nibName: String("\(VFGMultiTabsHeaderView.self)"),
            in: Bundle.foundation) {
            contentView = view
            xibSetup(contentView: contentView)
        }
    }

    func setupAccessibility() {
        titleLabel.accessibilityLabel = viewModel?.title
        subtitleBoldText.accessibilityLabel = viewModel?.subtitleBoldText
        subtitleRegText.accessibilityLabel = viewModel?.subtitleRegText
        secondSubtitleText.accessibilityLabel = viewModel?.secondSubtitleText
        refreshButton.accessibilityLabel = "refresh"
    }

    @IBAction public func refreshButtonPressed(_ sender: Any) {
        delegate?.refreshButtonDidPress()
    }

    @IBAction public func topUpButtonPressed(_ sender: Any) {
        delegate?.topUpButtonDidPress()
    }

    func addForegroundObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didMoveToForeground),
            name: UIApplication.willEnterForegroundNotification,
            object: nil)
    }

    func addBackgroundObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didMoveToBackground),
            name: UIApplication.willResignActiveNotification,
            object: nil)
    }

    @objc func didMoveToBackground() {
        refreshManager?.didMoveToBackground()
    }

    @objc func didMoveToForeground() {
        refreshManager?.didMoveToForeground()
    }
}
