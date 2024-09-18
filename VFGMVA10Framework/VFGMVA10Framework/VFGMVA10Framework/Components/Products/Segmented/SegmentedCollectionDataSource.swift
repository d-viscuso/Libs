//
//  SegmentedColletionViewModel.swift
//  VFGMVA10Framework
//
//  Created by Claudio Cavalli on 06/05/22.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import Foundation

// MARK: - enum SegmentedCellStyle.
public enum SegmentedCellStyle {
    case flexible
    case compact
}

// MARK: - SegmentedCollectionView view's data source.
public struct SegmentedCollectionDataSource {
    /// Titles to show.
    let titles: [String?]
    /// Selected cell of colleciton.
    let startIndex: Int
    /// selected style of collection cell.
    let segmentedCellStyle: SegmentedCellStyle
}
