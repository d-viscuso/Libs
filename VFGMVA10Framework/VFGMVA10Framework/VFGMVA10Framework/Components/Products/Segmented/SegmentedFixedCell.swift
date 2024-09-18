//
//  SegmentedFixedCell.swift
//  VFGMVA10Framework
//
//  Created by Claudio Cavalli on 07/05/22.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

// MARK: - SegmentedCellModel.
public class SegmentedFixedCellModel {
    let title: String
    let numberOfElement: Int
    let height: CGFloat
    init(title: String, numberOfElement: Int, height: CGFloat) {
        self.title = title
        self.numberOfElement = numberOfElement
        self.height = height
    }
}

// MARK: - SegmentedCell.
public class SegmentedFixedCell: UICollectionViewCell {
    /// SegmentedFlexibleCellModel title label.
    private let sectionTitleLabel = VFGLabel()
    /// SegmentedFlexibleCellModel selected view.
    private let selectedView = UIView()
    public var model: SegmentedFixedCellModel? {
        didSet {
            self.update()
        }
    }
    /// SegmentedFlexibleCellModel selected font.
    public override var isSelected: Bool {
        didSet {
            self.setFont()
        }
    }
    /// SegmentedFlexibleCellModel init.
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
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
    /// SegmentedFlexibleCellModel style.
    private func style() {
        backgroundColor = .clear
        sectionTitleLabel.font = .vodafoneRegular(16.0)
        sectionTitleLabel.textColor = .primaryTextColor
        sectionTitleLabel.numberOfLines = 1
        sectionTitleLabel.textAlignment = .center
        sectionTitleLabel.lineBreakMode = .byTruncatingTail
        selectedView.backgroundColor = .linksRed
        selectedView.layer.cornerRadius = 2
        selectedView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        selectedView.isHidden = true
    }
    /// SegmentedFlexibleCellModel layout.
    private func layout() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        sectionTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        selectedView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            centerXAnchor.constraint(equalTo: centerXAnchor),
            centerYAnchor.constraint(equalTo: centerYAnchor),
            sectionTitleLabel.topAnchor.constraint(equalTo: topAnchor),
            selectedView.heightAnchor.constraint(equalToConstant: 4.0),
            selectedView.centerXAnchor.constraint(equalTo: sectionTitleLabel.centerXAnchor),
            selectedView.centerYAnchor.constraint(equalTo: bottomAnchor, constant: -2.0)
        ])
    }
    /// SegmentedFlexibleCellModel update.
    private func update() {
        guard let model = model else { return }
        sectionTitleLabel.text = model.title
        let contentWidth = (UIScreen.main.bounds.width / CGFloat(model.numberOfElement))
        let contentHeight = model.height
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: contentWidth),
            sectionTitleLabel.widthAnchor.constraint(equalToConstant: contentWidth),
            sectionTitleLabel.heightAnchor.constraint(equalToConstant: contentHeight),
            selectedView.widthAnchor.constraint(equalToConstant: contentWidth)
        ])
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
