//
//  HorizontalDiscoverView.swift
//  VFGMVA10Framework
//
//  Created by Adel Aref on 14/08/2022.
//

import UIKit
import VFGMVA10Foundation

/// Dashboard horizontal discover view Delegate
public protocol HorizontalDiscoverViewDelegate: AnyObject {
    /// called when discover card selected
    /// - Parameters:
    ///   - item: discover selected item
    func didSelectCard(for item: HorizontalDiscoverItemModel)
    /// called when one of items cards selected in the  list view
    /// - Parameters:
    ///   - item: selected item
    func didSelectListCard(for item: HorizontalDiscoverItemModel)
}

/// Dashboard horizontal discover view
public class HorizontalDiscoverView: UIView {
    @IBOutlet weak var collectionView: UICollectionView!

    /// exposed action for show see all cta
    public var showSeeAllAction: (() -> Void)?
    var errorView: VFGErrorView?
    /// Update *HorizontalDiscoverViewContainerCard* collection view height
    public var viewModel: HorizontalDiscoverViewModel? {
        didSet {
            guard let viewModel else {
                state = .error
                return
            }
            state = .populated
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                if let isEmpty = viewModel.discoverList?.isEmpty, !isEmpty {
                    self.collectionViewHeightCompletion?(self.cardCellHeight)
                }
            }
        }
    }
    /// State of  the **HorizontalDiscoverView**
    public var state: VFGContentState = .loading {
        didSet {
            if state != .error {
                removeErrorCard()
            }
            collectionView?.reloadData()
        }
    }
    /// Dashboard horizontal discover view Delegate
    weak public var delegate: HorizontalDiscoverViewDelegate?

    /// Update *HorizontalDiscoverViewContainerCard* collection view height
    var collectionViewHeightCompletion: ((CGFloat) -> Void)?
    var userDefaults = UserDefaults.standard
    let margin = CGFloat(16)
    let topPadding = CGFloat(8)
    let lineSpacing = CGFloat(8)

    private let numberOfShimmeredCells = 4
    private let errorViewHeight: CGFloat = 200
    private let visibleCellsCount = CGFloat(3.33)
    private let heightRatio = CGFloat(1.5)
    private let discoverNibName = "HorizontalDiscoverCell"

    var cardCellWidth: CGFloat {
        let totalSpacing = floor(visibleCellsCount) * lineSpacing
        let totalMargin = margin * 2
        return (UIScreen.main.bounds.width - (totalMargin + totalSpacing)) / visibleCellsCount
    }

    var cardCellHeight: CGFloat {
        return cardCellWidth * heightRatio
    }

    // MARK: - Lifecycle
    public override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
    }

    func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        registerCell()
    }

    private func registerCell() {
        collectionView.register(
            UINib(
                nibName: String(describing: HorizontalDiscoverCell.self),
                bundle: Bundle.mva10Framework
            ),
            forCellWithReuseIdentifier: String(describing: discoverNibName.self)
        )

        collectionView?.register(
            UINib(
                nibName: String(describing: HorizontalDiscoverShimmerCell.self),
                bundle: Bundle.mva10Framework
            ),
            forCellWithReuseIdentifier: String(describing: HorizontalDiscoverShimmerCell.self))
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
            self?.collectionViewHeightCompletion?(self?.errorViewHeight ?? 0.0)
        }
    }

    public func removeErrorCard() {
        errorView?.removeFromSuperview()
        errorView = nil
    }
}

// MARK: - UICollectionViewDataDelegate
extension HorizontalDiscoverView: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = viewModel?.getDiscoverItemByIndex(index: indexPath.row) else {
            return
        }
        delegate?.didSelectCard(for: item)
    }
}

// MARK: - UICollectionViewDataSource
extension HorizontalDiscoverView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch state {
        case .populated:
            return viewModel?.numberOfItems ?? 0
        case .loading:
            return numberOfShimmeredCells
        default:
            return 0
        }
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let shimmerCell = shimmerCell(
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
                    withReuseIdentifier: discoverNibName,
                    for: indexPath
                ) as? HorizontalDiscoverCell
            else {
                return UICollectionViewCell()
            }
            let item = viewModel?.getDiscoverItemByIndex(index: indexPath.row)
            cell.configure(with: item)
            return cell
        default:
            return UICollectionViewCell()
        }
    }

    private func shimmerCell(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> HorizontalDiscoverShimmerCell {
        guard let shimmerCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: HorizontalDiscoverShimmerCell.self),
            for: indexPath
        ) as? HorizontalDiscoverShimmerCell
        else {
            return HorizontalDiscoverShimmerCell()
        }
        return shimmerCell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension HorizontalDiscoverView: UICollectionViewDelegateFlowLayout {
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
        return UIEdgeInsets(top: topPadding, left: margin, bottom: 0, right: margin)
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

extension HorizontalDiscoverView: VFGSeeAllProtocol {
    public var shouldShowSeeAll: Bool {
        (state == .populated) && (viewModel?.numberOfItems ?? 0 > 7)
    }
}

extension HorizontalDiscoverView: VFGDiscoverListViewControllerDelegate {
    func didSelectCard(for item: HorizontalDiscoverItemModel) {
        delegate?.didSelectListCard(for: item)
    }
}
