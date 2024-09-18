//
//  StoryPreviewManager+StoryPreviewCellDelegate.swift
//  VFGMVA10Framework
//
//  Created by Ihsan Kahramanoglu on 5.07.2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import Foundation
import VFGMVA10Foundation

// MARK: - StoryPreviewDelegate Helper Functions
extension StoryPreviewManager: StoryPreviewCellDelegate {
    var forcedDetailsButtonShown: Bool? {
        return viewModel?.forcedDetailsButtonShown
    }

    func storyPreviewCell(_ storyPreviewCell: StoryPreviewCell, moveToPreviousFrom index: Int) {
        guard let stories = viewModel?.stories,
            index > 0
        else {
            currentIndex = 0
            storyPreviewCell.resetProgress()

            if let finishedViewingStoriesAction = finishedViewingStoriesAction {
                finishedViewingStoriesAction(false)
                return
            }
            return
        }

        let previousIndex = index - 1
        guard previousIndex < stories.count else {
            return
        }
        analyticsDelegate?.onStoryChanged(
            data: [:],
            currentStory: currentStory,
            nextStory: stories[previousIndex]
        )
        currentIndex = previousIndex
        currentStory = stories[previousIndex]

        let previousIndexPath = IndexPath(row: currentIndex, section: 0)
        lockDuringAnimation()
        collectionView.isPagingEnabled = false
        collectionView.scrollToItem(at: previousIndexPath, at: .left, animated: true)
        collectionView.isPagingEnabled = true
    }

    func storyPreviewCell(_ storyPreviewCell: StoryPreviewCell, moveToNextFrom index: Int) {
        let isLastOne = ((viewModel?.stories.count ?? 0) - 1) == index
        if isLastOne {
            dismissAction()
            return
        }
        guard let stories = viewModel?.stories,
            index < stories.count - 1
        else {
            if let finishedViewingStoriesAction = finishedViewingStoriesAction {
                finishedViewingStoriesAction(true)
            }
            return
        }

        let nextIndex = currentIndex + 1
        guard let numberOfItems = collectionView.dataSource?.collectionView(collectionView, numberOfItemsInSection: 0),
            nextIndex < numberOfItems,
            nextIndex < stories.count else {
            return
        }
        analyticsDelegate?.onStoryChanged(
            data: [:],
            currentStory: currentStory,
            nextStory: stories[nextIndex]
        )
        currentIndex = nextIndex
        currentStory = stories[nextIndex]

        let nextIndexPath = IndexPath(row: nextIndex, section: 0)
        lockDuringAnimation()

        collectionView.isPagingEnabled = false
        collectionView.scrollToItem(at: nextIndexPath, at: .left, animated: true)
        collectionView.isPagingEnabled = true
    }

    func storyPreviewCellDidTapCloseButton(_ storyPreviewCell: StoryPreviewCell) {
        analyticsDelegate?.onStoryDismissed(
            data: [:],
            story: currentStory
        )
        dismissAction()
    }

    func storyPreviewCell(_ storyPreviewCell: StoryPreviewCell, handleOpen storyURLString: String) {
        analyticsDelegate?.onStoryActionButtonClicked(
            data: [:],
            story: currentStory
        )

        if let onStoryButtonTappedAction = onStoryButtonTappedAction {
            onStoryButtonTappedAction(
                storyPreviewCell.getDisplayedStory(),
                storyURLString
            )
        }
    }

    func storyPreviewCellDidPressOnGridItem(
        _ storyPreviewCell: StoryPreviewCell,
        handleOpen gridItem: GridItemData
    ) {
        analyticsDelegate?.onStoryGridItemClicked(
            data: [:],
            story: currentStory
        )

        if let onStoryGridItemPressAction = onStoryGridItemTappedAction {
            onStoryGridItemPressAction(
                storyPreviewCell.getDisplayedStory(),
                gridItem
            )
        }
    }
}
