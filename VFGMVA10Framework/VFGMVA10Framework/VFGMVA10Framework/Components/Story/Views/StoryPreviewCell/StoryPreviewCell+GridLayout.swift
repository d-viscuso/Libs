//
//  StoryPreviewCell+GridLayout.swift
//  VFGMVA10Framework
//
//  Created by Ihsan Kahramanoglu on 29.07.2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

// MARK: - StoryGridLayoutDataSource
extension StoryPreviewCell: StoryGridLayoutDataSource {
    func gridLayoutData() -> GridData? {
        guard let story = getDisplayedStory() else { return nil }
        return story.gridData
    }
}

// MARK: - StoryGridLayoutDelegate
extension StoryPreviewCell: StoryGridLayoutDelegate {
    func gridLayout(itemDidPress item: GridItemData) {
        delegate?.storyPreviewCellDidPressOnGridItem(self, handleOpen: item)
    }
}
