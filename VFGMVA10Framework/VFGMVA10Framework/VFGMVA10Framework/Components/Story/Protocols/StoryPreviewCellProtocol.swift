//
//  StoryPreviewCellProtocol.swift
//  VFGMVA10Framework
//
//  Created by Ashraf Dewan on 20/02/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import Foundation
/// Delegation protocol for *StoryPreviewCell* actions
protocol StoryPreviewCellDelegate: AnyObject {
    /// foce hide details button in case of empty URL passed
    var forcedDetailsButtonShown: Bool? { get }
    /// Handle moving to previous story
    /// - Parameters:
    ///    - storyPreviewCell: Cell to display story preview
    ///    - index: Currently displayed story index
    func storyPreviewCell(_ storyPreviewCell: StoryPreviewCell, moveToPreviousFrom index: Int)
    /// Handle moving to next story
    /// - Parameters:
    ///    - storyPreviewCell: Cell to display story preview
    ///    - index: Currently displayed story index
    func storyPreviewCell(_ storyPreviewCell: StoryPreviewCell, moveToNextFrom index: Int)
    /// Handle closing story
    /// - Parameters:
    ///    - storyPreviewCell: Story preview cell to be closed
    func storyPreviewCellDidTapCloseButton(_ storyPreviewCell: StoryPreviewCell)
    /// Handle opening story link
    /// - Parameters:
    ///    - storyPreviewCell: Cell that holds story link
    ///    - index: Currently displayed story index
    func storyPreviewCell(_ storyPreviewCell: StoryPreviewCell, handleOpen storyURLString: String)
    /// Handle pressing on grid item
    /// - Parameters:
    ///   - storyPreviewCell: Cell that holds grid item
    ///   - gridItem: Currently selected grid item
    func storyPreviewCellDidPressOnGridItem(
        _ storyPreviewCell: StoryPreviewCell,
        handleOpen gridItem: GridItemData
    )
}
