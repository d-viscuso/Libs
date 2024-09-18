//
//  SegmentedCollectionFlowLayout.swift
//  VFGMVA10Framework
//
//  Created by Claudio Cavalli on 06/05/22.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import Foundation

// MARK: - SegmentedCollectionViewFlowLayout view's flow layout.
public class SegmentedCollectionViewFlowLayout: UICollectionViewFlowLayout {
    /// SegmentedCollectionViewFlowLayout init with setup.
    override init() {
        super.init()
        self.setup()
    }
    /// Required init.
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    /// Setup flow layout.
    private func setup() {
        self.scrollDirection = .horizontal
        self.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
    }
}
