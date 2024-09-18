//
//  StoryPreviewManager.swift
//  VFGMVA10Framework
//
//  Created by Ihsan Kahramanoglu on 4.07.2022.
//

import UIKit
import VFGMVA10Foundation

class StoryPreviewManager: NSObject {
    /// Delegation protocol for story analytics
    var analyticsDelegate: StoryAnalyticsProtocol?
    /// Current story index
    var currentIndex = 0
    /// Current story data
    var currentStory: Story?
    /// Dismiss action
    var dismissAction: (() -> Void) = {}
    /// Swipe down action
    var swipeDownAction: (() -> Void)?
    /// On story completed action
    var onStoryCompleteAction: (() -> Void)?
    /// On story button tapped action
    var onStoryButtonTappedAction: ((Story?, String) -> Void)?
    /// On story grid layout item did press action
    var onStoryGridItemTappedAction: ((Story?, GridItemData) -> Void)?
    /// Finished viewing stories action. Bool parameter defines if stories are moving to the next story.
    var finishedViewingStoriesAction: ((Bool) -> Void)?
    /// Collection view for displaying stories
    var collectionView: UICollectionView
    /// Delegation protocol for  *StoryPreviewViewModel*
    var viewModel: StoryPreviewViewModelProtocol?

    var storiesLayout: StoriesLayout = .card

    lazy var swipeDownGesture: UISwipeGestureRecognizer = {
        let gesture = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeDown(_:)))
        gesture.direction = .down
        return gesture
    }()

    private var isScrollingToInitialIndex = false

    // MARK: - Init & Setup
    /// Default init to support convenience init
    override init() {
        collectionView = UICollectionView(
            frame: CGRect.zero,
            collectionViewLayout: UICollectionViewLayout()
        )
        super.init()
    }

    convenience init(
        viewModel: StoryPreviewViewModelProtocol?,
        collectionView: UICollectionView,
        dismissAction: @escaping (() -> Void)
    ) {
        self.init()
        self.viewModel = viewModel
        self.collectionView = collectionView
        self.dismissAction = dismissAction
        setupCollectionView()
        setupGestureRecognizer()

        guard let index = self.viewModel?.initialStoryIndex,
    index >= 0,
    index < viewModel?.stories.count ?? 0,
    let story = viewModel?.stories[index]
        else { return }
        currentStory = story
    }

    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.decelerationRate = .fast
        collectionView.register(
            UINib(
                nibName: String(describing: StoryPreviewCell.self),
                bundle: Bundle.vfgStory
            ),
            forCellWithReuseIdentifier: String(describing: StoryPreviewCell.self)
        )
    }

    private func setupGestureRecognizer() {
        swipeDownGesture.delegate = self
        collectionView.addGestureRecognizer(swipeDownGesture)
    }

    // MARK: - User Actions
    public func scrollToIndex(index: Int) {
        if index != 0 {
            isScrollingToInitialIndex = true
        }
        DispatchQueue.main.async { [weak self] in
            guard let self = self
            else { return }
            let indexPath = IndexPath(item: index, section: 0)
            guard indexPath.row < self.collectionView.numberOfItems(inSection: indexPath.section) else { return }
            self.currentIndex = indexPath.item
            self.collectionView.layoutIfNeeded()
            self.collectionView.isPagingEnabled = false
            self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
            self.collectionView.isPagingEnabled = true
        }
    }

    @objc func didSwipeDown(_ sender: Any) {
        let visibleCells = collectionView.visibleCells.sortedArrayByPosition()
        if let visibleCell = visibleCells.first as? StoryPreviewCell {
            visibleCell.updateViewedIndexBeforeClose()
        }
        if let swipeDownAction = swipeDownAction {
            swipeDownAction()
        } else {
            dismissAction()
        }
    }

    public func lockDuringAnimation() {
        collectionView.isUserInteractionEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.45) {
            self.collectionView.isUserInteractionEnabled = true
        }
    }
}

// MARK: - UICollectionViewDataSource
extension StoryPreviewManager: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.numberOfItemsInSection(section) ?? 0
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let story = viewModel?.cellForItemAtIndexPath(indexPath)
        else {
            return UICollectionViewCell()
        }

        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: String(describing: StoryPreviewCell.self),
                for: indexPath
            ) as? StoryPreviewCell
        else {
            return UICollectionViewCell()
        }
        // Skip loading cell for first story if it's not the intial story to be displayed
        // Also prevent it from being set to viewed
        if indexPath.item == 0, isScrollingToInitialIndex {
            isScrollingToInitialIndex = false
            return cell
        }
        cell.configure(
            with: story,
            index: indexPath.item,
            delegate: self
        )
        currentIndex = indexPath.item
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension StoryPreviewManager: UICollectionViewDelegate {
    public func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        guard let cell = cell as? StoryPreviewCell else { return }
        VFGDebugLog("willDisplay cell's title: \(cell.story?.title ?? "")")

        let visibleCells = collectionView.visibleCells.sortedArrayByPosition()
        if let visibleCell = visibleCells.first as? StoryPreviewCell {
            visibleCell.story?.isCompletelyVisible = false
            visibleCell.pauseProgress()
            currentStory = visibleCell.story
            VFGDebugLog("willDisplay VISIBLEcell's title: \(visibleCell.story?.title ?? "")")
        }

        if currentStory?.storyId == cell.story?.storyId {
            cell.story?.isCompletelyVisible = true
            cell.willDisplayCell()
            return
        }
        if indexPath.item == currentIndex {
            cell.willDisplayCell()
        }
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        didEndDisplaying cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        if let onStoryCompleteAction = onStoryCompleteAction {
            onStoryCompleteAction()
        }
        VFGDebugLog("\((cell as? StoryPreviewCell)?.story?.title ?? "") didEndDisplaying")

        let visibleCells = collectionView.visibleCells.sortedArrayByPosition()
        guard
            let visibleCell = visibleCells.first as? StoryPreviewCell,
            let visibleCellIndexPath = collectionView.indexPath(for: visibleCell)
        else {
            return
        }

        VFGDebugLog("visible cell's title: \(visibleCell.story?.title ?? "")")

        visibleCell.story?.isCompletelyVisible = true

        if visibleCell.story == currentStory {
            currentIndex = visibleCellIndexPath.item
            if visibleCell.longPressGestureState == nil {
                visibleCell.resumeProgress()
            }
            if visibleCell.story?.mediaType == .video {
                visibleCell.resumePlayer()
            }
            visibleCell.longPressGestureState = nil
        } else {
            if let cell = cell as? StoryPreviewCell {
                cell.stopPlayer()
            }
            visibleCell.startProgress()
        }

        // mark as viewed for visibleCell.story
        visibleCell.setStoryAsViewed()
    }
}

// MARK: - UICollectionViewFlowLayout
extension StoryPreviewManager: UICollectionViewDelegateFlowLayout {
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(
            width: UIScreen.main.bounds.width,
            height: UIScreen.main.bounds.height
        )
    }
}

// MARK: - UIGestureRecognizerDelegate
extension StoryPreviewManager: UIGestureRecognizerDelegate {
    public func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        return true
    }
}

// MARK: - UIScrollViewDelegate
extension StoryPreviewManager: UIScrollViewDelegate {
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        guard
            let cell = collectionView.visibleCells.first as? StoryPreviewCell
        else {
            return
        }

        cell.pauseProgress()
        cell.pausePlayer()
    }

    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let sortedVisibleCells = collectionView.visibleCells.sortedArrayByPosition()
        guard
            let firstCell = sortedVisibleCells.first,
            let lastCell = sortedVisibleCells.last,
            let dataSource = collectionView.dataSource
        else {
            return
        }
        let firstIndexPath = collectionView.indexPath(for: firstCell)
        let lastIndexPath = collectionView.indexPath(for: lastCell)
        let numberOfItems = dataSource.collectionView(collectionView, numberOfItemsInSection: 0) - 1
        if lastIndexPath?.item == 0 || firstIndexPath?.item == numberOfItems {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
                guard let self = self else { return }
                if let finishedViewingStoriesAction = self.finishedViewingStoriesAction {
                    finishedViewingStoriesAction(true)
                    return
                }
                self.dismissAction()
            }
        }
    }
}
