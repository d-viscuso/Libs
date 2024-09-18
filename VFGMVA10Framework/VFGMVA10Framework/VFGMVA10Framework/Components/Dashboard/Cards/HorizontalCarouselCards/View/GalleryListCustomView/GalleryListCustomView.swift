//
//  GalleryListCustomView.swift
//  VFGMVA10Framework
//
//  Created by Ahmed AbdElnabi on 01/01/2023.
//  Copyright © 2023 Vodafone. All rights reserved.
//

import UIKit

/// A view which shows a collection of cards with different width and with different content.
/// It supports three different types:
/// - Large width card.
/// - Medium squared card.
/// - Dual small Cards.
public class GalleryListCustomView: UIView {
    @IBOutlet weak var galleryCollectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionViewLeadingConstraint: NSLayoutConstraint!

    let minimumLineSpacing: CGFloat = 8
    let leftPadding: CGFloat = 16
    let rightPadding: CGFloat = 16
    /// Height of gallery list cards view.
    public var cardHeight: CGFloat? {
        return collectionViewHeightConstraint.constant +
            collectionViewTopConstraint.constant +
            collectionViewBottomConstraint.constant
    }
    /// Gallery list view data source.
    public weak var dataSource: GalleryListViewDataSource? {
        didSet {
            reloadData()
        }
    }

    public override func awakeFromNib() {
        super.awakeFromNib()
        setupCollection()
    }

    private func setupCollection() {
        setupCollectionViewData()
    }

    private func setupCollectionViewData() {
        registerCells()
        galleryCollectionView.dataSource = self
        galleryCollectionView.delegate = self
    }

    /// Reload gallery list view content
    public func reloadData() {
        galleryCollectionView.reloadData()
    }
}

extension GalleryListCustomView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.numberOfCards(self, in: collectionView) ?? 0
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = dataSource?.galleryList(
            self,
            collectionView,
            cardForItemAt: indexPath) as? BaseBannerCellProtocol
        else { return UICollectionViewCell() }
        return cell
    }
}

extension GalleryListCustomView: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let cell = dataSource?.galleryList(
            self,
            collectionView,
            cardForItemAt: indexPath)
        else { return CGSize(width: 0, height: 0) }
        cell.cellHeight = collectionViewHeightConstraint.constant
        cell.minimumLineSpacing = minimumLineSpacing
        cell.collectionInset = collectionViewLeadingConstraint.constant
        let width = cell.cellWidthType?.value ?? 0
        return CGSize(width: width, height: collectionViewHeightConstraint.constant)
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(
            top: 0,
            left: leftPadding,
            bottom: 0,
            right: rightPadding
        )
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        minimumLineSpacing
    }
}
