//
//  StoryListCell.swift
//  VFGStory
//
//  Created by Mithat Samet Kaskara on 13.01.2021.
//

import UIKit
import VFGMVA10Foundation
/// *VFGStoryContainerCard* collection view cell
public class StoryCardCell: UICollectionViewCell, VFGStoryCountdownManagerDelegate {
	// MARK: - IBOutlet
	@IBOutlet public var storyImageView: VFGImageView!
	@IBOutlet public var titleLabel: VFGLabel!
	@IBOutlet public var countdownLabel: VFGLabel!
	@IBOutlet public var countdownView: UIView!
    @IBOutlet public var featuredImageView: VFGImageView!

	// MARK: - Private variables
    private var countdownManager: VFGStoryCountdownManager?

	// MARK: - Lifecycle
	override public func prepareForReuse() {
		super.prepareForReuse()

        countdownManager?.invalidateTimer()

		storyImageView.image = nil
		titleLabel.text = nil
		countdownLabel.text = nil
		countdownView.isHidden = true
	}

	// MARK: - Public functions
    /// *StoryListCell* configuration
    /// - Parameters:
    ///    - story: Story data
    public func configure(with story: Story) {
        titleLabel.text = story.title
        if let url = URL(string: story.icon) {
            storyImageView.download(from: url)
        }
        updateBorder(with: story.isViewed)
        setupVoiceOverAccessibility()

        guard story.type == .countdown, let endDate = story.endDate
        else {
            countdownManager?.invalidateTimer()
            countdownView.isHidden = true
            return
        }

        countdownView.isHidden = false
        countdownManager = VFGStoryCountdownManager(
            endDate: endDate,
            format: .hourAndMinuteAndSecond,
            delegate: self)
        countdownManager?.startCountdownTimer()
    }

	// MARK: - Private functions
	private func updateBorder(with isViewed: Bool) {
		if isViewed {
			layer.borderWidth = 1
			layer.borderColor = UIColor(red: 153 / 255, green: 153 / 255, blue: 153 / 255, alpha: 1).cgColor
		} else {
			layer.borderWidth = 2
			layer.borderColor = UIColor(red: 0, green: 176 / 255, blue: 202 / 255, alpha: 1).cgColor
		}
	}

    // MARK: VFGStoryCountdownManagerDelegate

    public func updateLabel(isHidden: Bool, text: String, accessibilityLabel: String) {
        countdownView.isHidden = isHidden
        countdownLabel.text = text
        countdownLabel.accessibilityLabel = accessibilityLabel
    }
}
