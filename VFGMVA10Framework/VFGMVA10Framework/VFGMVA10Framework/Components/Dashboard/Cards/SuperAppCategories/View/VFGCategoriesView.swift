//
//  VFGCategoriesView.swift
//  VFGMVA10Framework
//
//  Created by Ayman Ata on 22/09/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

/// Dashboard Categories view Delegate
public protocol VFGCategoriesViewDelegate: AnyObject {
    /// called when one of categories cards selected
    /// - Parameters:
    ///   - item: category selected item
    func didSelectCard(for item: VFGCategoryModel)
    /// called when one of categories cards selected in the categories list view
    /// - Parameters:
    ///   - item: category selected item
    func didSelectListCard(for item: VFGCategoryModel)
}

/// **VFGCategoriesView** is a view that representing a super-app-categories look like view that can be used as a dashboard section.
public class VFGCategoriesView: UIView {
    /// The collection that presents each category cell.
    @IBOutlet weak var collectionView: UICollectionView!

    /// number of shimmerd viewsDone .
    let numberOfShimmerdViews = 8
    /// ErrorView height .
    let errorViewHeight: CGFloat = 232
    /// A completion handler that returns the dashboard categories view height.
    var cardViewHeightCompletion: ((CGFloat) -> Void)?
    /// Instance of *VFGErrorView*.
    var errorView: VFGErrorView?
    /// Instance of *VFGCategoriesViewModel*.
    /// This property must be passed correctly to make this view *VFGCategoriesView* works properly.
    public var viewModel: VFGCategoriesViewModel? {
        didSet {
            state = .populated
            DispatchQueue.main.async { [weak self] in
                self?.cardViewHeightCompletion?(self?.viewModel?.cardViewHeight ?? 0)
            }
        }
    }

    /// the state of  **VFGCategoriesView**
    public var state: VFGContentState = .loading {
        didSet {
            if state != .error {
                removeErrorCard()
            }
            collectionView?.reloadData()
        }
    }

    /// Categories view Delegate
    public var delegate: VFGCategoriesViewDelegate?

    public override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
        collectionView.isScrollEnabled = false
    }

    /// Sets up the collection view delegate, data source and registering it's cell.
    private func setupCollectionView() {
        collectionView.backgroundColor = .VFGLightGreyBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(
            UINib(
                nibName: String(describing: VFGCategoryCell.self),
                bundle: .mva10Framework
            ),
            forCellWithReuseIdentifier: String(describing: VFGCategoryCell.self))

        collectionView?.register(
            UINib(
                nibName: String(describing: VFGCategoryShimmerCollectionCell.self),
                bundle: Bundle.mva10Framework
            ),
            forCellWithReuseIdentifier: String(describing: VFGCategoryShimmerCollectionCell.self))
    }

    public func showErrorCard(
        with errorConfig: VFGErrorModel,
        tryAgain completion: (() -> Void)?
    ) {
        state = .error
        errorView = VFGErrorView(error: errorConfig)
        errorView?.errorImageView.image = VFGFrameworkAsset.Image.warning
        errorView?.configureErrorViewConstraints()
        embed(view: errorView ?? UIView())
        errorView?.refreshingClosure = {
            self.state = .loading
            completion?()
        }
        DispatchQueue.main.async { [weak self] in
            self?.cardViewHeightCompletion?(self?.errorViewHeight ?? 0.0)
        }
    }

    public func removeErrorCard() {
        errorView?.removeFromSuperview()
        errorView = nil
    }
}

// MARK: - Functions of UICollectionViewDelegate.
extension VFGCategoriesView: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard viewModel?.isSeeAllCell(at: indexPath) ?? false else {
            if let item = viewModel?.categories[indexPath.row] {
                delegate?.didSelectCard(for: item)
            }
            return
        }
        if let model = viewModel?.model {
            let viewModel = VFGCategoryListViewModel(model)
            let categoryListVC = VFGCategoryListViewController(viewModel)
            categoryListVC.delegate = self
            let navController = MVA10NavigationController(rootViewController: categoryListVC)
            navController.isCloseButtonHidden = false
            navController.hasDivider = false
            let title = "dashboard_super_app_more_cateogry_label".localized(bundle: .mva10Framework)
            navController.setTitle(title: title, for: categoryListVC)
            UIApplication.topViewController()?.present(navController, animated: true, completion: nil)
        }
    }
}

// MARK: - Functions of UICollectionViewDataSource.
extension VFGCategoriesView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch state {
        case .loading:
            return numberOfShimmerdViews
        case .populated:
            return viewModel?.numberOfItems ?? 0
        default:
            return 0
        }
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let shimmerCell = shimmerCollectionView(
            collectionView,
            cellForItemAt: indexPath
        )
        switch state {
        case .loading:
            shimmerCell.startShimmer()
            return shimmerCell
        case .populated:
            shimmerCell.stopShimmer()
            guard
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: String(describing: VFGCategoryCell.self),
                    for: indexPath
                ) as? VFGCategoryCell,
                let model = viewModel?.categories[indexPath.item]
            else { return UICollectionViewCell() }

            guard !(viewModel?.isSeeAllCell(at: indexPath) ?? false) else {
                let seeAllTitle = "balance_history_see_all_categories".localized(bundle: .mva10Framework)
                let seeAllModel = VFGCategoryModel(title: seeAllTitle, image: "ic_three-dots")
                cell.configure(with: seeAllModel, isSeeAllCell: true)
                return cell
            }
            cell.configure(with: model)
            return cell
        default:
            return UICollectionViewCell()
        }
    }

    private func shimmerCollectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> VFGCategoryShimmerCollectionCell {
        guard let shimmerCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: VFGCategoryShimmerCollectionCell.self),
            for: indexPath
        ) as? VFGCategoryShimmerCollectionCell
        else {
            return VFGCategoryShimmerCollectionCell()
        }
        return shimmerCell
    }
}

// MARK: - Functions of UICollectionViewDelegateFlowLayout.
extension VFGCategoriesView: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        viewModel?.cellSize ?? .zero
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        viewModel?.spaceBetweenCells ?? 0
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        viewModel?.spaceBetweenCells ?? 0
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        viewModel?.sectionInsets ?? .zero
    }
}

extension VFGCategoriesView: VFGCategoryListViewControllerDelegate {
    func didSelectCard(for item: VFGCategoryModel) {
        delegate?.didSelectListCard(for: item)
    }
}
