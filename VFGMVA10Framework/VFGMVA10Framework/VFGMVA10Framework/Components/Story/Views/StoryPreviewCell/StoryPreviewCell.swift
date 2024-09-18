//
//  StoryPreviewCell.swift
//  VFGStory
//
//  Created by Abdullah Soylemez on 21.01.2021.
//

import UIKit
import VFGMVA10Foundation

/// Story snap movement direction states
enum SnapMovementDirectionState {
    case forward
    case backward
}

/// *StoryPreviewViewController* collection view cell
class StoryPreviewCell: UICollectionViewCell {
    // MARK: - IBOutlet
    @IBOutlet weak var headerViewContainer: UIView!
    @IBOutlet weak var mediaView: UIView!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var imageView: VFGImageView!
    @IBOutlet weak var videoView: StoryVideoView!
    @IBOutlet weak var detailButton: VFGButton!
    @IBOutlet weak var secondDetailButton: VFGButton!
    @IBOutlet weak var gridLayoutView: StoryGridLayoutView!

    // MARK: - Public variables
    /// Story data
    var story: Story?
    /// Long press gesture current state
    var longPressGestureState: UILongPressGestureRecognizer.State?
    /// *StoryPreviewViewController* collection view cell header view
    var headerView: StoryPreviewHeaderView?

    var storyIndex: Int = 0
    weak var delegate: StoryPreviewCellDelegate?

    // MARK: - Private variables
    private lazy var longPressGesture: UILongPressGestureRecognizer = {
        let gesture = UILongPressGestureRecognizer.init(target: self, action: #selector(didLongPress(_:)))
        gesture.minimumPressDuration = 0.2
        gesture.delegate = self
        return gesture
    }()
    private lazy var tapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapStory(_:)))
        gesture.cancelsTouchesInView = false
        gesture.numberOfTapsRequired = 1
        gesture.delegate = self
        return gesture
    }()

    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()

        videoView.playerObserverDelegate = self
        gridLayoutView.dataSource = self
        gridLayoutView.delegate = self

        mediaView.addGestureRecognizer(tapGesture)
        mediaView.addGestureRecognizer(longPressGesture)
        gridLayoutView.addGestureRecognizer(longPressGesture)

        gradientView.setGradientBackgroundColor(
            colors: [
                UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor,
                UIColor(red: 0, green: 0, blue: 0, alpha: 0).cgColor
            ]
        )

        registerForUIApplicationStates()
    }

    // MARK: - Config functions
    /// *StoryPreviewCell* configuration
    /// - Parameters:
    ///    - story: Current story data
    ///    - index: Current story index
    ///    - delegate: Delegation protocol for *StoryPreviewCell* actions
    func configure(
        with story: Story,
        index: Int,
        delegate: StoryPreviewCellDelegate?
    ) {
        VFGDebugLog("\(story.title) configure")
        self.story = story
        self.storyIndex = index
        self.delegate = delegate

        setStoryAsViewed()
        setupHeaderView()
        setupGridLayout()
        setupDetailButton()
        setupSecondDetailButton()
        setupVoiceOverAccessibility()
    }

    func setStoryAsViewed() {
        guard let story = story else { return }

        switch story.storyPreviewType {
        case .single:
            story.isViewed = true
        case .multiple:
            story.stories[story.lastViewedMultipleStoryIndex].isViewed = true
        }
    }

    /// Returns currently displayed story in cell based on story preview type
    func getDisplayedStory() -> Story? {
        guard let story = story else { return nil }

        switch story.storyPreviewType {
        case .single:
            return story
        case .multiple:
            return story.stories[story.lastViewedMultipleStoryIndex]
        }
    }

    func setupHeaderView() {
        headerView?.removeFromSuperview()
        headerView = nil
        headerView = StoryPreviewHeaderView.loadXib(bundle: .vfgStory)

        guard let headerView = headerView,
            let story = story,
            let displayedStory = getDisplayedStory()
        else { return }
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerViewContainer.addSubview(headerView)
        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: headerViewContainer.leadingAnchor),
            headerView.topAnchor.constraint(equalTo: headerViewContainer.topAnchor),
            headerView.trailingAnchor.constraint(equalTo: headerViewContainer.trailingAnchor),
            headerView.bottomAnchor.constraint(equalTo: headerViewContainer.bottomAnchor)
        ])
        headerView.storiesLayout = .circle
        headerView.delegate = self
        headerView.configure(with: story)
        headerView.updateHeaderLabels(for: displayedStory)
    }

    func setupGridLayout() {
        guard let story = getDisplayedStory() else { return }

        if story.gridData != nil {
            gridLayoutView.isHidden = false
            gridLayoutView.reloadData()
        } else {
            gridLayoutView.isHidden = true
        }
    }

    func setupDetailButton() {
        guard let story = getDisplayedStory(),
            let buttonTitle = story.btnTitle,
            !buttonTitle.isEmpty,
            let buttonLink = story.btnLink else {
            detailButton.isHidden = true
            return
        }
        if delegate?.forcedDetailsButtonShown == false {
            guard URL(string: buttonLink) != nil else {
                detailButton.isHidden = true
                return
            }
            detailButton.isHidden = false
        }
        detailButton.setTitle(buttonTitle, for: .normal)
        if let buttonTextColorString = story.btnTextColor,
            let buttonTextColor = UIColor(hexString: buttonTextColorString),
            let buttonBackgroundColorString = story.btnColor,
            let buttonBackgroundColor = UIColor(hexString: buttonBackgroundColorString) {
            detailButton.setTitleColor(buttonTextColor, for: .normal)
            detailButton.backgroundColor = buttonBackgroundColor
        } else {
            detailButton.setTitleColor(.VFGStoryButtonText, for: .normal)
            detailButton.backgroundColor = .VFGStoryButtonBG
        }
    }

    func setupSecondDetailButton() {
        guard let story = getDisplayedStory(),
            let buttonTitle = story.secondBtnTitle,
            !buttonTitle.isEmpty,
            let buttonLink = story.secondBtnLink
        else {
            secondDetailButton.isHidden = true
            return
        }

        if delegate?.forcedDetailsButtonShown == false {
            guard URL(string: buttonLink) != nil else { return }
            secondDetailButton.isHidden = false
        }

        secondDetailButton.setTitle(buttonTitle, for: .normal)
        if let buttonTextColorString = story.secondBtnTextColor,
            let buttonTextColor = UIColor(hexString: buttonTextColorString),
            let buttonBackgroundColorString = story.secondBtnColor,
            let buttonBackgroundColor = UIColor(hexString: buttonBackgroundColorString) {
            secondDetailButton.setTitleColor(buttonTextColor, for: .normal)
            secondDetailButton.backgroundColor = buttonBackgroundColor
        } else {
            secondDetailButton.setTitleColor(.VFGStoryButtonText, for: .normal)
            secondDetailButton.backgroundColor = .VFGStoryButtonBG
        }
    }

    private func openStoryURL() {
        guard let story = getDisplayedStory(),
            let buttonLink = story.btnLink else { return }
        if delegate?.forcedDetailsButtonShown == false {
            guard !buttonLink.isEmpty else { return }
        }
        delegate?.storyPreviewCell(self, handleOpen: buttonLink)
    }

    // MARK: - IBAction
    @IBAction func detailButtonDidPress(_ sender: VFGButton) {
        detailButtonAction()
    }

    @objc func detailButtonAction() {
        openStoryURL()
    }
}
