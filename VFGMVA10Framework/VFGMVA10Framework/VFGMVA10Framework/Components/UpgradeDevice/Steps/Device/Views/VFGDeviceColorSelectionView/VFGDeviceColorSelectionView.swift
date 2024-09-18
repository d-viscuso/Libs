//
//  VFGDeviceColorSelectionView.swift
//  VFGMVA10Framework
//
//  Created by SAMEH on 19/05/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

class VFGDeviceColorSelectionView: UIView {
    // MARK: - Outlets
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var titleLabel: VFGLabel!
    @IBOutlet weak var collectionView: UICollectionView!

    // MARK: - Attribuites
    let colorSelectionCellId = "VFGColorSelectionCell"
    let rightInsets: CGFloat = 16.6
    let leftInsets: CGFloat = 16.6
    let cellSpacing: CGFloat = 8

    weak var dataSource: VFGDeviceViewModelColorsDataSource? {
        didSet {
            collectionView.reloadData()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        load()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        load()
    }

    // MARK: - LoadView
    func load() {
        Bundle.mva10Framework.loadNibNamed(className, owner: self, options: nil)
        guard let contentView = contentView else { return }
        contentView.frame = bounds
        addSubview(contentView)
        setupUI()
        setupAccessibilityLabels()
    }

    private func setupAccessibilityLabels() {
        [self, contentView, collectionView]
            .forEach { $0.isAccessibilityElement = false }
        titleLabel.isAccessibilityElement = true
    }
}

// MARK: - UI Setup
extension VFGDeviceColorSelectionView {
    func setupUI() {
        setupTitleLabel()
        registerCollectionViewCell()
        setupCollectionViewLayout()
    }

    private func setupTitleLabel() {
        titleLabel.text = "device_upgrade_device_step_select_colour".localized(bundle: .mva10Framework)
        titleLabel.accessibilityIdentifier = "DColorSelectionTitleID"
    }

    private func registerCollectionViewCell() {
        collectionView.register(
            UINib(nibName: colorSelectionCellId, bundle: .mva10Framework),
            forCellWithReuseIdentifier: colorSelectionCellId
        )
    }

    private func setupCollectionViewLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = calculateCellSize()
        layout.minimumInteritemSpacing = cellSpacing
        layout.sectionInset = UIEdgeInsets(top: 0, left: leftInsets, bottom: 0, right: rightInsets)
        collectionView.setCollectionViewLayout(layout, animated: false)
    }

    private func calculateCellSize() -> CGSize {
        let collectionViewWidth = collectionView.bounds.width - (rightInsets + leftInsets)
        let cellWidth = collectionViewWidth / numberOfItemsInRow - cellSpacing
        let cellHeight = collectionView.bounds.height - 1
        return CGSize(width: cellWidth, height: cellHeight)
    }
}

// MARK: - UICollectionViewDataSource - UICollectionViewDelegate
extension VFGDeviceColorSelectionView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.numberOfColors() ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: colorSelectionCellId, for: indexPath) as?
            VFGColorSelectionCell ?? VFGColorSelectionCell()
        if let item = dataSource?.color(at: indexPath.row) {
            let isSelected = item == dataSource?.selectedColor
            cell.setupUI(color: item.color ?? .black, text: item.colorName, isSelected: isSelected)
            if isSelected {
                collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
            }
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedColor = dataSource?.color(at: indexPath.row)
        dataSource?.selectedColor = selectedColor
        if let cell = collectionView.cellForItem(at: indexPath) as? VFGColorSelectionCell {
            cell.setupUI(color: selectedColor?.color ?? .black, text: selectedColor?.colorName, isSelected: true)
        }
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let colorModel = dataSource?.color(at: indexPath.row)
        if let cell = collectionView.cellForItem(at: indexPath) as? VFGColorSelectionCell {
            cell.setupUI(color: colorModel?.color ?? .black, text: colorModel?.colorName, isSelected: false)
        }
    }
}

extension VFGDeviceColorSelectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return calculateCellSize()
    }
}

extension VFGDeviceColorSelectionView {
    var numberOfItemsInRow: CGFloat {
        guard let numberOfColors = dataSource?.numberOfColors()
            else { return 0 }
        if numberOfColors <= 3 {
            return 3
        } else {
            return 3.1
        }
    }
}
