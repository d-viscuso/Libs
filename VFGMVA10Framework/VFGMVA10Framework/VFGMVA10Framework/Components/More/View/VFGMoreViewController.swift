//
//  VFGMoreViewController.swift
//  VFGMVA10Framework
//
//  Created by Adel Aref on 17/11/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

public class VFGMoreViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!

    var viewModel: VFGMoreViewModel?

    public required init(_ viewModel: VFGMoreViewModel) {
        super.init(
            nibName: String(describing: VFGMoreViewController.self),
            bundle: .mva10Framework
        )
        self.viewModel = viewModel
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }

    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self

        let listCellNib = UINib(
            nibName: String(describing: VFGMoreListCollectionViewCell.self),
            bundle: .mva10Framework
        )
        collectionView.register(
            listCellNib,
            forCellWithReuseIdentifier: String(describing: VFGMoreListCollectionViewCell.self))

        let cardsCellNib = UINib(
            nibName: String(describing: VFGMoreCardsCollectionViewCell.self),
            bundle: .mva10Framework
        )
        collectionView.register(
            cardsCellNib,
            forCellWithReuseIdentifier: String(describing: VFGMoreCardsCollectionViewCell.self))

        let verticalCardsCellNib = UINib(
            nibName: String(describing: VFGMoreCardItemCollectionViewCell.self),
            bundle: .mva10Framework
        )
        collectionView.register(
            verticalCardsCellNib,
            forCellWithReuseIdentifier: String(describing: VFGMoreCardItemCollectionViewCell.self))

        let titleHeaderNib = UINib(
            nibName: String(describing: TitleHeaderCollectionReusableView.self),
            bundle: Bundle.mva10Framework)
        collectionView.register(
            titleHeaderNib,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: String(describing: TitleHeaderCollectionReusableView.self))
    }
}

// MARK: - UICollectionViewDataSource
extension VFGMoreViewController: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel?.numOfSections ?? 0
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.getNumberOfItemsInSection(for: section) ?? 0
    }

    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = createTitleCollectionReusableView(for: indexPath, and: kind)
        return headerView
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch viewModel?.getSectionType(for: indexPath.section) {
        case .cards:
            if viewModel?.isVerticalCards ?? false {
                guard
                    let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: String(describing: VFGMoreCardItemCollectionViewCell.self),
                        for: indexPath
                    ) as? VFGMoreCardItemCollectionViewCell
                else {
                    return UICollectionViewCell()
                }
                let section = viewModel?.getSection(for: indexPath.section)
                cell.configure(with: section?.items?[indexPath.item])
                return cell
            }
            guard
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: String(describing: VFGMoreCardsCollectionViewCell.self),
                    for: indexPath
                ) as? VFGMoreCardsCollectionViewCell
            else {
                return UICollectionViewCell()
            }
            let section = viewModel?.getSection(for: indexPath.section)
            cell.headerSection = section
            return cell
        case .list:
            guard
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: String(describing: VFGMoreListCollectionViewCell.self),
                    for: indexPath
                ) as? VFGMoreListCollectionViewCell
            else {
                return UICollectionViewCell()
            }
            let section = viewModel?.getSection(for: indexPath.section)
            cell.configure(with: section?.items?[indexPath.item])
            let lastIndex = (viewModel?.model.sections?[indexPath.section].items?.count ?? 0) - 1
            if indexPath.item == lastIndex {
                cell.dividerView.isHidden = true
            }
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension VFGMoreViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        switch viewModel?.getSectionType(for: indexPath.section) {
        case .cards:
            guard let viewModel = viewModel else {
                return .zero
            }
            if viewModel.isVerticalCards {
                return CGSize(width: viewModel.verticalCardCellWidth, height: viewModel.verticalCardCellHeight)
            }
            return CGSize(width: viewModel.horizontalCardsCellWidth, height: viewModel.hoirzontalCardsCellHeight)
        case .list:
            return CGSize(width: self.collectionView.frame.width, height: viewModel?.listCellHeight ?? 0.0)
        default:
            return .zero
        }
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        if viewModel?.isVerticalCards ?? false {
            return UIEdgeInsets(top: 0, left: viewModel?.margin ?? 0.0, bottom: 0, right: viewModel?.margin ?? 0.0)
        } else if viewModel?.isListAndCards ?? false {
            return UIEdgeInsets(top: 0, left: 0, bottom: viewModel?.insetForSection ?? 0, right: 0)
        }
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return viewModel?.lineSpacing ?? 0.0
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return viewModel?.lineSpacing ?? 0.0
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        section == 0 ?
        CGSize(width: self.collectionView.frame.width, height: viewModel?.titleHeaderHeight ?? 0.0) : .zero
    }
}

// MARK: - Create resuableViews
extension VFGMoreViewController {
    private func createTitleCollectionReusableView(for indexPath: IndexPath, and kind: String) -> UICollectionReusableView {
        guard
            let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: String(describing: TitleHeaderCollectionReusableView.self),
                for: indexPath) as? TitleHeaderCollectionReusableView
        else { return UICollectionReusableView() }
        return headerView
    }
}
