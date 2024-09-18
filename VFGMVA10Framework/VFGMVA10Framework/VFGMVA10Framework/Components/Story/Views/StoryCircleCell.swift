//
//  StoryCircleCell.swift
//  VFGMVA10Framework
//
//  Created by Giovanni Romaniello on 15/06/22.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import Foundation
import VFGMVA10Foundation
import UIKit

/// Delegation protocol for *StoryCircleCell* countdown
public protocol VFGStoryCountdownDelegate: AnyObject {
    /// Handle countdown reaching zero on *StoryCircleCell*
    /// - Parameters:
    ///    - story: *Story* of whose countdown has reached zero
    func countdownFinished(for story: Story)
}

public class StoryCircleCell: UICollectionViewCell, VFGStoryCountdownManagerDelegate {
    // MARK: - IBOutlet
    public let titleFontSize: CGFloat = 14
    public let imageSize: CGFloat = 72
    public let stackHeight: CGFloat = 26
    public let stackWidth: CGFloat = 26

    public var container: UIView?
    public var imageBackgroundView: UIView?
    public var storyImageView: VFGImageView?
    public var titleLabel: VFGLabel?
    public var countdownLabel: VFGLabel?
    public var countdownView: UIView?
    public var iconView: UIView?
    public var featuredImageView: VFGImageView?
    public var pinnedImageView: VFGImageView?
    public var storyIcon: VFGImageView?

    public var story: Story?

    // MARK: - Private variables
    private var countdownManager: VFGStoryCountdownManager?
    private var storyCountdownDelegate: VFGStoryCountdownDelegate?

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        setupContainer()
        setupImageBackgroundView()
        setupImageView()
        setupTitleLabel()
        setupStackView()
        featuredImageView = VFGImageView()
        storyIcon = VFGImageView()
    }

    // MARK: - Lifecycle
    override public func prepareForReuse() {
        super.prepareForReuse()
        countdownManager?.invalidateTimer()
        storyImageView?.image = nil
        titleLabel?.text = nil
        countdownLabel?.text = nil
        storyIcon?.image = nil
        countdownView?.isHidden = true
        iconView?.isHidden = true
    }

    // MARK: - Public functions
    /// *StoryListCell* configuration
    /// - Parameters:
    ///    - story: Story data
    ///    - countdownDelegate: Countdown delegate for hide/show logic call backs
    public func configure(with story: Story, countdownDelegate: VFGStoryCountdownDelegate? = nil) {
        self.story = story
        self.storyCountdownDelegate = countdownDelegate
        titleLabel?.text = story.title
        titleLabel?.sizeToFit()
        titleLabel?.setNeedsLayout()
        if let url = URL(string: story.icon) {
            storyImageView?.download(from: url)
        }
        updateBorder(with: story.isViewed)
        addStoryType(type: story.type, endDate: story.endDate)
        setupVoiceOverAccessibility()
    }

    // MARK: - Private functions
    private func updateBorder(with isViewed: Bool) {
        imageBackgroundView?.layer.borderWidth = 2
        imageBackgroundView?.layer.borderColor =
        isViewed ? UIColor(hexString: "#BEBEBE")?.cgColor : UIColor(hexString: "#0099B1")?.cgColor
    }

    // MARK: VFGStoryCountdownManagerDelegate

    public func updateLabel(isHidden: Bool, text: String, accessibilityLabel: String) {
        countdownView?.isHidden = isHidden
        countdownLabel?.text = text
        countdownLabel?.accessibilityLabel = accessibilityLabel

        // Countdown finished
        if let story = story, isHidden {
            storyCountdownDelegate?.countdownFinished(for: story)
        }
    }

    public func addStoryType(type: StoryType?, endDate: Date?) {
        guard let type = type else {
            return
        }
        switch type {
        case .featured:
            storyIcon?.image = VFGFrameworkAsset.Image.icFeatured
            setupStackViewWithIcon()
            iconView?.isHidden = false
            countdownView?.isHidden = true
        case .countdown:
            guard let endDate = endDate
            else {
                countdownManager?.invalidateTimer()
                countdownView?.isHidden = true
                return
            }
            addCountdownLabel()
            countdownView?.isHidden = false
            iconView?.isHidden = true
            countdownManager = VFGStoryCountdownManager(
                endDate: endDate,
                format: .hourAndMinuteAndSecond,
                delegate: self)
            countdownManager?.startCountdownTimer()
        case .pinned:
            storyIcon?.image = VFGFrameworkAsset.Image.icPinned
            setupStackViewWithIcon()
            iconView?.isHidden = false
            countdownView?.isHidden = true
        case .locked, .pinnedLocked:
            storyIcon?.image = VFGFrameworkAsset.Image.icLocked
            setupStackViewWithIcon()
            iconView?.isHidden = false
            countdownView?.isHidden = true
        case .unlocked, .pinnedUnlocked:
            storyIcon?.image = VFGFrameworkAsset.Image.icUnlocked
            setupStackViewWithIcon()
            iconView?.isHidden = false
            countdownView?.isHidden = true
        default:
            storyIcon?.image = nil
            iconView?.isHidden = true
            countdownView?.isHidden = true
        }
    }
}
