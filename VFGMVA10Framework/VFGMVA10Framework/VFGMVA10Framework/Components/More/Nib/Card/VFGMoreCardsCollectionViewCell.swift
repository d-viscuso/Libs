//
//  VFGMoreCardsCollectionViewCell.swift
//  VFGMVA10Framework
//
//  Created by Adel Aref on 26/11/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import UIKit

class VFGMoreCardsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var collectionView: UICollectionView!

    let lineSpacing = CGFloat(8)
    let leftMargin = CGFloat(16)
    private let visibleCellsCount = CGFloat(2.41)
    private let heightRatio = CGFloat(1.2)
    private let cellIdentifier = "VFGMoreCardItemCollectionViewCell"

    var cardCellWidth: CGFloat {
        let totalLineSpacing = 2 * lineSpacing
        let totalSpacing = totalLineSpacing + leftMargin
        return (collectionView.bounds.width - totalSpacing) / visibleCellsCount
    }

    var cardCellHeight: CGFloat {
        return cardCellWidth * heightRatio
    }

    var headerSection: VFGMoreSectionModel? {
        didSet {
            collectionView.reloadData()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
    }

    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        let cellNib = UINib(
            nibName: String(describing: VFGMoreCardItemCollectionViewCell.self),
            bundle: .mva10Framework
        )
        collectionView.register(cellNib, forCellWithReuseIdentifier: cellIdentifier)
    }
}

// MARK: - UICollectionViewDataSource
extension VFGMoreCardsCollectionViewCell: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return headerSection?.items?.count ?? 0
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: cellIdentifier,
                for: indexPath
            ) as? VFGMoreCardItemCollectionViewCell
        else {
            return UICollectionViewCell()
        }
        cell.configure(with: headerSection?.items?[indexPath.item])
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension VFGMoreCardsCollectionViewCell: UICollectionViewDelegateFlowLayout {
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: cardCellWidth, height: cardCellHeight)
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: leftMargin, bottom: 0, right: 0)
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return lineSpacing
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return lineSpacing
    }
}
