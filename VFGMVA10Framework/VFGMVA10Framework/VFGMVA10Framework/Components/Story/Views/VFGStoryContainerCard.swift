//
//  VFGStoryContainerCard.swift
//  VFGStory
//
//  Created by Abdullah Soylemez on 13.01.2021.
//

import AVKit
import Foundation
import VFGMVA10Foundation

/// Stories state which handles the loaded view when fetching data or after data is populated or even in error state
public enum VFGStoriesState {
    case loading
    case populated
    case error
}

private final class DefaultStoryAnalytics: StoryAnalyticsProtocol {}

/// Story container card in dashboard
public class VFGStoryContainerCard: UIView {
    // MARK: - Public variables
    /// Delegation protocol for *StoryViewModel*
    public var viewModel: StoryViewModelProtocol? {
        didSet {
            viewModel?.delegate = self
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                VFGInfoLog("COLLECTION VIEW RELOADED!")
                if let stories = self.viewModel?.nonSponsoredStories, !stories.isEmpty {
                    self.collectionViewHeightCompletion?(self.cellHeight ?? 0)
                }
            }
        }
    }

    /// Update *VFGStoryContainerCard* collection view height
    var collectionViewHeightCompletion: ((CGFloat) -> Void)?
    /// Current story button action
    public var storyContentButtonTapped: ((Story) -> Void)?
    public var storiesLayout: StoriesLayout = .card {
        didSet {
            switch storiesLayout {
            case .card:
                cellWidth = cardCellWidth
                cellHeight = cardCellHeight
            case .circle:
                cellWidth = circleCellWidth
                cellHeight = circleCellHeight
            }
        }
    }
    public var state: VFGStoriesState = .loading {
        didSet {
            collectionView?.reloadData()
        }
    }

    /// Delegation protocol for story analytics
    public var analyticsDelegate: StoryAnalyticsProtocol? = DefaultStoryAnalytics()

    // MARK: - IBOutlet
    @IBOutlet weak var collectionView: UICollectionView!
    // MARK: - Private variables
    private let spacing = CGFloat(16)
    private let padding = CGFloat(16)
    private let displayableCellCount = CGFloat(3.2)
    private let heightRatio = CGFloat(1.44)

    private var cardCellWidth: CGFloat {
        return (UIScreen.main.bounds.width / displayableCellCount) - padding
    }

    private var cardCellHeight: CGFloat {
        return cardCellWidth * heightRatio
    }

    private var circleCellWidth: CGFloat {
        return 90
    }

    private var circleCellHeight: CGFloat {
        return 160
    }

    private(set) var cellWidth: CGFloat?
    private(set) var cellHeight: CGFloat?

    public init() {
        super.init(frame: CGRect.zero)
        xibSetup()
        setupCollectionView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
        setupCollectionView()
    }
    /// Dashboard bill card shimmer view XIB load
    private func xibSetup() {
        guard let view = loadViewFromNib(
            nibName: String(describing: VFGStoryContainerCard.self)
        ) else {
            VFGErrorLog("VFGStoryContainerCard is nil")
            return
        }
        xibSetup(contentView: view)
    }

    // MARK: - Lifecycle
    public override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
    }

    // MARK: - Private functions
    private func setupCollectionView() {
        storiesLayout = .card
        collectionView.dataSource = self
        collectionView.delegate = self
        registerCells()
    }

    private func registerCells() {
        collectionView.register(
            UINib(
                nibName: String(describing: StoryCardCell.self),
                bundle: Bundle.vfgStory
            ),
            forCellWithReuseIdentifier: String(describing: StoryCardCell.self)
        )
        collectionView.register(
            StoryCircleCell.self,
            forCellWithReuseIdentifier: String(describing: StoryCircleCell.self))
        collectionView.register(
            UINib(
                nibName: String(describing: StoryCircleShimmerCell.self),
                bundle: Bundle.vfgStory
            ),
            forCellWithReuseIdentifier: String(describing: StoryCircleShimmerCell.self)
        )
    }
}

// MARK: - UICollectionViewDataSource
extension VFGStoryContainerCard: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch storiesLayout {
        case .card:
            return viewModel?.nonSponsoredStories.count ?? 0
        case .circle:
            switch state {
            case .loading:
                return 10
            case .populated:
                return viewModel?.nonSponsoredStories.count ?? 0
            case .error:
                return 0
            }
        }
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        switch storiesLayout {
        case .card:
            let cell = cardCollectionView(
                collectionView,
                cellForItemAt: indexPath
            )
            if let story = viewModel?.nonSponsoredStories[indexPath.item] {
                cell.configure(with: story)
            }
            return cell
        case .circle:
            let shimmerCell = circleShimmerCollectionView(
                collectionView,
                cellForItemAt: indexPath
            )
            switch state {
            case .loading:
                let isMva12 =
                VFGManagerFramework.dashboardDelegate?.dashboardManager?.dashboardController.isMVA12Theme == true
                let theme: ShimmerTheme = isMva12 ? .mva12 : .mva10
                shimmerCell.startShimmer(theme: theme)
                return shimmerCell
            case .populated:
                shimmerCell.stopShimmer()
                let cell = circleCollectionView(
                    collectionView,
                    cellForItemAt: indexPath
                )
                if let story = viewModel?.nonSponsoredStories[indexPath.item] {
                    cell.configure(with: story, countdownDelegate: self)
                    return cell
                }

                return cell
            case .error:
                return UICollectionViewCell()
            }
        }
    }

    private func circleShimmerCollectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> StoryCircleShimmerCell {
        guard
            let shimmerCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: String(describing: StoryCircleShimmerCell.self),
                for: indexPath
            ) as? StoryCircleShimmerCell
        else {
            return StoryCircleShimmerCell()
        }
        return shimmerCell
    }

    private func circleCollectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> StoryCircleCell {
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: String(describing: StoryCircleCell.self),
                for: indexPath
            ) as? StoryCircleCell
        else {
            return StoryCircleCell()
        }
        return cell
    }

    private func cardCollectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> StoryCardCell {
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: String(describing: StoryCardCell.self),
                for: indexPath
            ) as? StoryCardCell
        else {
            return StoryCardCell()
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension VFGStoryContainerCard: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let sponsoredStories = viewModel?.nonSponsoredStories, let stories = viewModel?.stories else {
            collectionView.deselectItem(at: indexPath, animated: false)
            return
        }

        let story = sponsoredStories[indexPath.item]
        analyticsDelegate?.onStoryClicked(data: [:], story: story)

        let storyIndex = stories.enumerated().first { iterator in
            iterator.element.storyId == story.storyId
        }?.offset

        let previewVC = StoryPreviewViewController(nibName: "StoryPreviewViewController", bundle: .vfgStory)
        previewVC.viewModel = StoryPreviewViewModel(
            stories, storyIndex ?? 0, viewModel?.forcedDetailsButtonShown ?? false )
        previewVC.storiesLayout = storiesLayout
        previewVC.delegate = self
        previewVC.analyticsDelegate = analyticsDelegate
        previewVC.storyContentButtonTapped = storyContentButtonTapped
        previewVC.modalPresentationStyle = .fullScreen
        UIApplication.topViewController()?.present(previewVC, animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension VFGStoryContainerCard: UICollectionViewDelegateFlowLayout {
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: cellWidth ?? 0, height: cellHeight ?? 0)
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: padding, bottom: 0, right: padding)
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return CGFloat.greatestFiniteMagnitude
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        if let story = viewModel?.nonSponsoredStories[indexPath.item] {
            analyticsDelegate?.onDashboardStoriesScrolled(data: [:], story: story)
        }
    }
}

// MARK: - StoryPreviewViewControllerDelegate
extension VFGStoryContainerCard: StoryPreviewViewControllerDelegate {
    func storyPreviewViewControllerDidDismiss(_ storyPreviewViewController: StoryPreviewViewController) {
        viewModel?.update(stories: viewModel?.stories ?? [])
        try? AVAudioSession.sharedInstance().setCategory(.soloAmbient, mode: .default, options: [])
    }
}

extension VFGStoryContainerCard: StoryViewModelDelegate {
    public func updateView() {
        collectionView.reloadData()
    }
}

// MARK: - StoryPreviewViewControllerDelegate
extension VFGStoryContainerCard: VFGStoryCountdownDelegate {
    public func countdownFinished(for story: Story) {
        guard
            viewModel?.stories != nil,
            let storyIndex = viewModel?.stories.firstIndex(where: { $0.storyId == story.storyId })
        else { return }

        viewModel?.stories.remove(at: storyIndex)
        let indexPath = IndexPath(item: storyIndex, section: 0)
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.deleteItems(at: [indexPath])
        }
    }
}
