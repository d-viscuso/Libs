//
//  VFGDiscoverListViewController.swift
//  VFGMVA10Framework
//
//  Created by Ayman Ata on 18/08/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import UIKit

/// VFGDiscoverListViewController Delegate
protocol VFGDiscoverListViewControllerDelegate: AnyObject {
    /// called when one of item cards selected
    /// - Parameters:
    ///   - item: selected item
    func didSelectCard(for item: HorizontalDiscoverItemModel)
}

class VFGDiscoverListViewController: UIViewController {
    private let rightLeftMargin: CGFloat = 16
    private let inbetweenSpace: CGFloat = 8
    private let spaceBetweenCells: CGFloat = 16
    private var discoverModels: [HorizontalDiscoverItemModel]?
    private let cellIdentifier = "VFGDiscoverListCellIdentifier"

    private var cellWidth: CGFloat {
        (UIScreen.main.bounds.width - (rightLeftMargin * 2 + inbetweenSpace)) / 2
    }
    private var cellHeight: CGFloat {
        cellWidth * VFGDiscoverListCell.heightToWidthRatio
    }

    weak var delegate: VFGDiscoverListViewControllerDelegate?

    @IBOutlet weak var collectionView: UICollectionView!

    required init(_ model: [HorizontalDiscoverItemModel]) {
        super.init(
            nibName: String(describing: VFGDiscoverListViewController.self),
            bundle: .mva10Framework
        )
        self.discoverModels = model
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }

    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        let cellNib = UINib(
            nibName: String(describing: VFGDiscoverListCell.self),
            bundle: .mva10Framework
        )
        collectionView.register(cellNib, forCellWithReuseIdentifier: cellIdentifier)
    }
}

// MARK: - UICollectionView data source functions
extension VFGDiscoverListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        discoverModels?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: cellIdentifier, for: indexPath) as? VFGDiscoverListCell,
            let model = discoverModels?[indexPath.item]
        else { return UICollectionViewCell() }
        cell.setupWith(model)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = discoverModels?[indexPath.item] else {
            return
        }
        delegate?.didSelectCard(for: item)
    }
}

// MARK: - UICollectionView flow layout functions
extension VFGDiscoverListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: cellWidth, height: cellHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        spaceBetweenCells
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        inbetweenSpace
    }
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: rightLeftMargin, bottom: 0, right: rightLeftMargin)
    }
}
