//
//  StoryPreviewHeaderView.swift
//  VFGStory
//
//  Created by Mithat Samet Kaskara on 22.01.2021.
//

import UIKit
import VFGMVA10Foundation

/// Delegation protocol for *StoryPreviewHeaderView* actions
protocol StoryPreviewHeaderViewDelegate: AnyObject {
    /// Handle story preview close button action
	func didTapCloseButton()
}
/// *StoryPreviewCell* header view
class StoryPreviewHeaderView: UIView {
	// MARK: - Public variables
    /// Delegation protocol for *StoryPreviewHeaderView* actions
	weak var delegate: StoryPreviewHeaderViewDelegate?

	// MARK: - IBOutlet
    @IBOutlet weak var titleLabel: VFGLabel!
    @IBOutlet weak var descriptionLabel: VFGLabel!
    @IBOutlet weak var iconContainerView: UIView!
    @IBOutlet weak var iconImageView: VFGImageView!
    @IBOutlet weak var progressContainerView: UIStackView!
    @IBOutlet weak var closeButton: VFGButton!

	// MARK: - Private variables
	private var endDate: Date?
	private var timer: Timer?
    var storiesLayout: StoriesLayout = .card

	// MARK: - Lifecycle
	deinit {
		invalidateTimer()
	}


	// MARK: - Public functions
    /// *StoryPreviewHeaderView* configuration
    /// - Parameters:
    ///    - story: Current story data 
    func configure(with story: Story) {
        iconContainerView.backgroundColor = .white
        progressContainerView.removeAllArrangedSubviews()

        if story.storyPreviewType == .single {
            setProgressView(1)
        } else if story.storyPreviewType == .multiple {
            setProgressView(story.stories.count)
        }

		invalidateTimer()
        updateHeaderLabels(for: story)
    }

    func updateHeaderLabels(for story: Story) {
        iconContainerView.layer.cornerRadius = 16
        titleLabel.text = story.title
        iconContainerView.isHidden = false
        descriptionLabel.isHidden = false
        iconImageView.contentMode = .scaleAspectFit
        switch story.type {
        case .countdown:
            endDate = story.endDate
            setCountdownLabel()
            iconImageView.image = VFGFrameworkAsset.Image.icClockBlack
        case .pinned:
            iconImageView.image = VFGFrameworkAsset.Image.icPinned
            descriptionLabel.text = story.storyDescription
        case .featured:
            iconImageView.image = VFGFrameworkAsset.Image.icFeatured
            descriptionLabel.text = story.storyDescription
        case .locked, .pinnedLocked:
            iconImageView.image = VFGFrameworkAsset.Image.icLocked
            descriptionLabel.text = story.storyDescription
        case .unlocked, .pinnedUnlocked:
            iconImageView.image = VFGFrameworkAsset.Image.icUnlocked
            descriptionLabel.text = story.storyDescription
        case .regular, .sponsored:
            iconContainerView.isHidden = true
            descriptionLabel.text = story.storyDescription
        default:
            break
        }
        setupVoiceOverAccessibility()
    }

    func updateProgressViews(for index: Int) {
        guard progressContainerView.arrangedSubviews.count > index
        else { return }
        // Display previous progress views as complete
        for i in 0..<index {
            let holderView = progressContainerView.arrangedSubviews[i]
            guard let progressView = holderView.viewWithTag(i + 1) as? StoryProgressView
            else { continue }
            progressView.reset()
            progressView.finish(for: holderView.frame.width)
        }

        // Display next progress views as not started
        for i in index..<progressContainerView.arrangedSubviews.count {
            let holderView = progressContainerView.arrangedSubviews[i]
            guard let progressView = holderView.viewWithTag(i + 1) as? StoryProgressView
            else { continue }
            progressView.reset()
        }
    }

    /// - Parameters:
    ///    - index: Arranged subview index of the progress view
    func getProgressView(for index: Int = 0) -> StoryProgressView? {
        guard progressContainerView.arrangedSubviews.count > index
        else { return nil }
        let holderView = progressContainerView.arrangedSubviews[index]

        guard let progressView = holderView.viewWithTag(index + 1) as? StoryProgressView
        else { return nil }
        return progressView
    }

	// MARK: - Private functions
    private func setProgressView(_ count: Int) {
        let holderViewWidth = UIScreen.main.bounds.width / CGFloat(count)
        for index in 0..<count {
            let progressView = StoryProgressView()
            progressView.tag = index + 1
            progressView.backgroundColor = UIColor.white
            progressView.translatesAutoresizingMaskIntoConstraints = false

            let holderView = UIView(frame: CGRect(x: 0, y: 0, width: holderViewWidth, height: 6))
            holderView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
            holderView.layer.masksToBounds = true
            holderView.addSubview(progressView)
            NSLayoutConstraint.activate([
                progressView.leadingAnchor.constraint(equalTo: holderView.leadingAnchor),
                progressView.topAnchor.constraint(equalTo: holderView.topAnchor),
                progressView.bottomAnchor.constraint(equalTo: holderView.bottomAnchor)
            ])
            progressContainerView.addArrangedSubview(holderView)
        }
    }

	private func setCountdownLabel() {
		guard endDate != nil else { return }
		descriptionLabel.isHidden = false
		timer = Timer.scheduledTimer(
			timeInterval: 1,
			target: self,
			selector: #selector(updateCountdownLabel),
			userInfo: nil,
			repeats: true
		)
		timer?.fire()
	}

	private func invalidateTimer() {
		timer?.invalidate()
		endDate = nil
		timer = nil
	}

	@objc private func updateCountdownLabel() {
		guard let endDate = endDate else {
			invalidateTimer()
			descriptionLabel.isHidden = true
			return
		}

		guard endDate.timeIntervalSinceNow.sign == .plus else {
			invalidateTimer()
			descriptionLabel.text = "story_preview_offer_expires_title_no_time".localized(bundle: Bundle.vfgStory)
			return
		}

		let components = Calendar.current.dateComponents(
			[.hour, .minute, .second],
			from: Date(),
			to: endDate
		)
		guard
			let hour = components.hour,
			let minute = components.minute,
            let second = components.second
		else {
			invalidateTimer()
			return
		}

        let localized = "story_countdown_expire_offer_time".localized(bundle: Bundle.vfgStory)
        let hourLocalized = "story_countdown_hour".localized(bundle: Bundle.vfgStory)
        let minuteLocalized = "story_countdown_minute".localized(bundle: Bundle.vfgStory)
        var countdownString = ""

        if storiesLayout == .card {
            if hour > 0, minute > 0 {
                countdownString = "\(hour)\(hourLocalized) \(minute)\(minuteLocalized)"
            } else if hour > 0 {
                countdownString = "\(hour)\(hourLocalized)"
            } else if minute > 0 {
                countdownString = "\(minute)\(minuteLocalized)"
            }
        } else {
            countdownString = String(format: "%02d:%02d:%02d", hour, minute, second)
        }

        descriptionLabel.text = String(format: localized, countdownString)
        descriptionLabel.accessibilityLabel = "story countdown"
        descriptionLabel.accessibilityValue = descriptionLabel.text
	}

	// MARK: - IBAction
    @IBAction func closeButtonTapped(_ sender: VFGButton) {
		closeButtonAction()
    }

    @objc func closeButtonAction() {
        delegate?.didTapCloseButton()
    }
}
