//
//  VFGSelectionView.swift
//  VFGMVA10Framework
//
//  Created by SAMEH on 20/05/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

enum VFGSelectionViewSize: CGFloat {
    case large = 1
    case medium = 2
    case small = 3
}

protocol VFGSelectionViewDelegate: AnyObject {
    func selectionView(_ selectionView: VFGSelectionView, didSelectItemAt index: Int)
}

class VFGSelectionView: UIView {
    // MARK: - Outlets
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var titleLabel: VFGLabel!
    @IBOutlet weak var collectionView: UICollectionView!

    // MARK: - Attributes
    weak var delegate: VFGSelectionViewDelegate?
    var size: VFGSelectionViewSize = .small

    let selectionCellId = "VFGSelectionViewCell"
    let cellSpacing: CGFloat = 8
    let rightInsets: CGFloat = 16.6
    let leftInsets: CGFloat = 16.6

    weak var dataSource: VFGSelectionViewDataSource? {
        didSet {
            setupTitleLabel()
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
        setupVoiceOverAccessibility()
        setupAccessibilityID()
    }

    private func setupVoiceOverAccessibility() {
        isAccessibilityElement = false
        contentView.isAccessibilityElement = false
        collectionView.isAccessibilityElement = false
        titleLabel.isAccessibilityElement = true
    }

    func setupAccessibilityID() {
        titleLabel.accessibilityIdentifier = "UDSelectionViewTitleID"
    }
}

// MARK: - UI Setup
extension VFGSelectionView {
    func setupUI() {
        registerCollectionViewCell()
        setupCollectionViewLayout()
    }

    private func setupTitleLabel() {
        titleLabel.text = dataSource?.headerTitle()
    }

    private func registerCollectionViewCell() {
        collectionView.register(
            UINib(nibName: selectionCellId, bundle: .mva10Framework),
            forCellWithReuseIdentifier: selectionCellId
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
        let cellWidth = collectionViewWidth / size.rawValue - cellSpacing
        let cellHeight = collectionView.bounds.height - 1
        return CGSize(width: cellWidth, height: cellHeight)
    }
}

// MARK: - UICollectionViewDataSource - UICollectionViewDelegate
extension VFGSelectionView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.numberOfSelections() ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let dataSource = dataSource else {
            return UICollectionViewCell()
        }

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: selectionCellId, for: indexPath) as?
            VFGSelectionViewCell ?? VFGSelectionViewCell()

        let isSelected = (indexPath.row == dataSource.selectedIndex)
        cell.setup(selectionUIModel(for: indexPath.row, isSelected: isSelected))

        cell.accessibilityIdentifier = "UDSelectionViewCell\(indexPath.row)"
        if indexPath.row == dataSource.selectedIndex {
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
        }

        return cell
    }

    func selectionUIModel(for rowIndex: Int, isSelected: Bool) -> VFGSelectionUIModel {
        VFGSelectionUIModel(
            title: dataSource?.titleForSelection(at: rowIndex),
            subTitle: dataSource?.subtitleForSelection(at: rowIndex),
            selectedText: dataSource?.selectedItemSubtitleText(),
            borderColor: UIColor.VFGOceanText.cgColor,
            isSelected: isSelected
        )
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let dataSource = dataSource else {
            return
        }

        dataSource.selectedIndex = indexPath.row
        if let cell = collectionView.cellForItem(at: indexPath) as? VFGSelectionViewCell {
            cell.setup(selectionUIModel(for: indexPath.row, isSelected: true))
            delegate?.selectionView(self, didSelectItemAt: indexPath.row)
        }
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? VFGSelectionViewCell {
            cell.setup(selectionUIModel(for: indexPath.row, isSelected: false))
        }
        delegate?.selectionView(self, didSelectItemAt: indexPath.row)
    }
}

extension VFGSelectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return calculateCellSize()
    }
}
