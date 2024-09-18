//
//  SegmentedCollectionViewCell.swift
//  VFGMVA10Framework
//
//  Created by Claudio Cavalli on 06/05/22.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

// MARK: - SegmentedCellModel.
public struct SegmentedFlexibleCellModel {
    /// title of the cell.
    let title: String
    /// height of the cell.
    let height: CGFloat
}

// MARK: - SegmentedCell.
public class SegmentedFlexibleCell: UICollectionViewCell {
    /// SegmentedFlexibleCellModel title label.
    private let sectionTitleLabel = VFGLabel()
    /// SegmentedFlexibleCellModel selected view.
    private let selectedView = UIView()
    /// SegmentedFlexibleCellModel model.
    var model: SegmentedFlexibleCellModel? {
        didSet {
            self.update()
        }
    }
    /// SegmentedFlexibleCellModel isSelected.
    public override var isSelected: Bool {
        didSet {
            self.setFont()
        }
    }
    /// SegmentedFlexibleCellModel init.
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
        self.setupAccessibilityIdentifier()
        self.style()
        self.layout()
    }
    /// SegmentedFlexibleCellModel required init.
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// SegmentedFlexibleCellModel setup.
    private func setup() {
        contentView.addSubview(sectionTitleLabel)
        contentView.addSubview(selectedView)
    }
    /// SegmentedFlexibleCellModel setupAccessibilityIdentifier.
    private func setupAccessibilityIdentifier() {
        selectedView.accessibilityIdentifier = "PRtopSlidingView"
    }
    /// SegmentedFlexibleCellModel style.
    private func style() {
        backgroundColor = .clear
        sectionTitleLabel.font = .vodafoneRegular(16.0)
        sectionTitleLabel.numberOfLines = 1
        sectionTitleLabel.textAlignment = .center
        selectedView.backgroundColor = .VFGRedProgressBar
        selectedView.layer.cornerRadius = 2
        selectedView.isHidden = true
    }
    /// SegmentedFlexibleCellModel layout.
    private func layout() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        sectionTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        selectedView.translatesAutoresizingMaskIntoConstraints = false
        sectionTitleLabel.fresh.makeConstraints { make in
            make.left == self.fresh.left.constant(20)
            make.right == self.fresh.right.constant(-20)
            make.top == self.fresh.top
        }
        selectedView.fresh.makeConstraints { make in
            make.height == 4
            make.left == self.fresh.left
            make.right == self.fresh.right
            make.centerX == sectionTitleLabel.fresh.centerX
            make.centerY == self.fresh.bottom.constant(-2)
        }
    }
    /// SegmentedFlexibleCellModel update.
    private func update() {
        guard let model = model else { return }
        sectionTitleLabel.text = model.title
        sectionTitleLabel.fresh.makeConstraints { make in
            make.height == model.height
        }
    }
    /// SegmentedFlexibleCellModel setFont.
    private func setFont() {
        if isSelected {
            selectedView.isHidden = false
            sectionTitleLabel.font = .vodafoneBold(16.0)
        } else {
            selectedView.isHidden = true
            sectionTitleLabel.font = .vodafoneRegular(16.0)
        }
    }
}
