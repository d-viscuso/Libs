//
//  VFGDeviceCollectionAndDeliveryView.swift
//  VFGMVA10Framework
//
//  Created by SAMEH on 20/05/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import UIKit

class VFGDeviceCollectionAndDeliveryView: UIView {
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!

    // MARK: - Attribuites
    let collectionAndDeliveryCellId = "VFGCollectionAndDeliverySelectionCell"
    let numberOfItemsInRow: CGFloat = 2
    let cellSpacing: CGFloat = 0
    let leftInsets: CGFloat = 27.7
    let rightInsets: CGFloat = 27.7

    weak var dataSource: VFGViewModelCollectionAndDeliveryDataSource? {
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
    }
}

// MARK: - UI Setup
extension VFGDeviceCollectionAndDeliveryView {
    func setupUI() {
        registerCollectionViewCell()
        setupCollectionViewLayout()
        collectionView.reloadData()
    }

    private func registerCollectionViewCell() {
        collectionView.register(
            UINib(nibName: collectionAndDeliveryCellId, bundle: .mva10Framework),
            forCellWithReuseIdentifier: collectionAndDeliveryCellId
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

    func calculateCellSize() -> CGSize {
        let collectionViewWidth = collectionView.bounds.width - (leftInsets + rightInsets)
        let cellWidth = collectionViewWidth / numberOfItemsInRow
        let cellHeight = collectionView.bounds.height
        return CGSize(width: cellWidth, height: cellHeight)
    }
}

// MARK: - UICollectionViewDataSource - UICollectionViewDelegate
extension VFGDeviceCollectionAndDeliveryView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.numberOfCollectionAndDelivery() ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: collectionAndDeliveryCellId,
            for: indexPath
        ) as? VFGCollectionAndDeliverySelectionCell ?? VFGCollectionAndDeliverySelectionCell()
        if let collectionAndDelivery = dataSource?.collectionAndDelivery(at: indexPath.row) {
            cell.setupUI(collectionAndDelivery: collectionAndDelivery)
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let collectionAndDelivery = dataSource?.collectionAndDelivery(at: indexPath.row)
        dataSource?.selectedCollectionAndDelivery = collectionAndDelivery
    }
}

extension VFGDeviceCollectionAndDeliveryView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return calculateCellSize()
    }
}
