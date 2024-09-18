//
//  VFGCategoryListViewController.swift
//  VFGMVA10Framework
//
//  Created by Adel Aref on 20/10/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import UIKit

/// CategoryListViewController Categories view Delegate
protocol VFGCategoryListViewControllerDelegate: AnyObject {
    /// called when one of categories cards selected
    /// - Parameters:
    ///   - item: category selected item
    func didSelectCard(for item: VFGCategoryModel)
}

class VFGCategoryListViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!

    let margin: CGFloat = 16
    let minimumInteritemSpacing: CGFloat = 8
    let minimumLineSpacing: CGFloat = 8
    private let heightToWidthRatio: CGFloat = 0.6
    private var model: VFGCategoriesModel?
    var viewModel: VFGCategoryListViewModelProtocol?
    private let cellIdentifier = "VFGCategoryListCellIdentifier"

    weak var delegate: VFGCategoryListViewControllerDelegate?

    var cellWidth: CGFloat {
        let visibleCellsCount = CGFloat(2.0)
        let totalMargin = margin * 2
        return (UIScreen.main.bounds.width - (totalMargin + minimumInteritemSpacing)) / visibleCellsCount
    }

    var cellHeight: CGFloat {
        cellWidth * heightToWidthRatio
    }

    required init(_ viewModel: VFGCategoryListViewModelProtocol) {
        super.init(
            nibName: String(describing: VFGCategoryListViewController.self),
            bundle: .mva10Framework
        )
        self.viewModel = viewModel
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
            nibName: String(describing: VFGCategoryListCell.self),
            bundle: .mva10Framework
        )
        collectionView.register(cellNib, forCellWithReuseIdentifier: cellIdentifier)

        let headerNib = UINib(
            nibName: "VFGCategoryReusableView", bundle: Bundle.mva10Framework)
        collectionView.register(
            headerNib,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "VFGCategoryReusableView")
    }
}

// MARK: - UICollectionView data source functions
extension VFGCategoryListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let model = viewModel?.getCategoryForItemInSection(at: indexPath) else {
            return
        }
        delegate?.didSelectCard(for: model)
    }
}


// MARK: - UICollectionView data source functions
extension VFGCategoryListViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewModel?.sections?.count ?? 0
    }

    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        if let sectionHeader = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: "VFGCategoryReusableView",
            for: indexPath) as? VFGCategoryReusableView {
            sectionHeader.categoryTitleLabel.text = viewModel?.getSectionTitleForIndexPath(at: indexPath.section)
            return sectionHeader
        }
        return UICollectionReusableView()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel?.getNumberOfItemsInSection(at: section) ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: cellIdentifier, for: indexPath) as? VFGCategoryListCell,
            let model = viewModel?.getCategoryForItemInSection(at: indexPath)
        else { return UICollectionViewCell() }
        cell.configure(with: model)
        return cell
    }
}

// MARK: - UICollectionView flow layout functions
extension VFGCategoryListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: cellWidth, height: cellHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        minimumLineSpacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        minimumInteritemSpacing
    }
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: margin, bottom: 0, right: margin)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: collectionView.frame.width, height: viewModel?.sectionHeight ?? 0.0)
    }
}
