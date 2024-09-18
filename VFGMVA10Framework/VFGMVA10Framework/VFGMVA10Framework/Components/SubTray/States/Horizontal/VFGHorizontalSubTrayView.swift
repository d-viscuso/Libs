//
//  VFGHorizontalSubTrayView.swift
//  VFGMVA10Framework
//
//  Created by Yahya Saddiq on 11/17/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import VFGMVA10Foundation
/// Horizontal view for sub tray
public class VFGHorizontalSubTrayView: VFGBaseSubtrayView {
    @IBOutlet weak var headerStackView: UIStackView?
    @IBOutlet weak var expandedScrollView: UIScrollView?
    @IBOutlet weak var expandedView: UIView?
    @IBOutlet weak var expandedViewWidthConstraint: NSLayoutConstraint?
    @IBOutlet weak var expandedViewHeightConstraint: NSLayoutConstraint?

    public override var dataModel: VFGSubTrayModel? {
        didSet {
            if type == nil && dataModel != nil {
                extractType()
                collectionView?.reloadData()
            }
        }
    }

    let horizontalCellId = "VFGHorizontalSubTrayCollectionViewCell"
    var numberOfShimmerCells = 3
    var cellWidth: CGFloat = 142
    var cellHeight: CGFloat {
        return isSubTrayCustomizable ? 215 : 195
    }
    var cellsCount: Int {
        dataModel?.items?.count ?? numberOfShimmerCells
    }

    var collectionViewWidthObserver: NSKeyValueObservation?
    var scrollType: HorizontalSubTrayScrollType = .itemsCollectionView
    var highlightedItemIndex: Int?
    var scrollDidFinishAction: (() -> Void)?
    // 325 is the minimum acceptable height for sub-tray, it's needed for small screens.
    let mainHeight = max(UIScreen.main.bounds.height * 0.35, 325)
    private var isManageDataViewLoaded = false
    /// *VFGHorizontalSubTrayView* initializer
    /// - Parameters:
    ///    - title: Horizontal sub tray view title
    ///    - subtitle: Horizontal sub tray view subtitle
    ///    - onRefresh: Horizontal sub tray view refresh handler
    required public init(_ title: String, _ subtitle: String, _ onRefresh: @escaping () -> Void) {
        super.init(title, subtitle, onRefresh, mainHeight, 24)

        commonInit()
        updateSubtitle()
        setupActionView()
        setupVoiceOverAccessibility()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    /// *VFGHorizontalSubTrayView* configuration
    func commonInit() {
        guard let contentView = loadViewFromNib(nibName: className) else {
            return
        }

        xibSetup(contentView: contentView)

        let nibShimmerCell = UINib(nibName: shimmerCellId, bundle: .mva10Framework)
        let nibCell = UINib(nibName: horizontalCellId, bundle: .mva10Framework)

        collectionView?.register(nibCell, forCellWithReuseIdentifier: horizontalCellId)
        collectionView?.register(nibShimmerCell, forCellWithReuseIdentifier: shimmerCellId)
        subtitleLabel?.text = subtitle?.localized(bundle: .mva10Framework)

        collectionView?.delegate = self
        collectionView?.dataSource = self

        expandedScrollView?.delegate = self

        collectionViewWidthObserver = collectionView?.observe(\.contentSize, options: [.new]) { [weak self] _, change in
            guard let self = self,
                let newWidth = change.newValue?.width else { return }
            self.expandedViewWidthConstraint?.constant = newWidth
        }
        hideExpandedView()
    }
    /// *VFGHorizontalSubTrayView* action view setup
    func setupActionView() {
        if let headerActionView = dataSource?.actionView(for: self) {
            headerStackView?.addArrangedSubview(headerActionView)
        }
    }

    private func setupFooterActionView() {
        guard !isManageDataViewLoaded,
        let manageGroupActionView = dataSource?.manageGroupActionView(for: self) else {
            return
        }

        addSubview(manageGroupActionView)
        // increase the tray height from the initial value to fit the manage group CTA
        height = UIScreen.main.bounds.width * 0.81
        delegate?.subtrayHeightDidChange(for: self)
        manageGroupActionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            manageGroupActionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -1),
            manageGroupActionView.heightAnchor.constraint(equalToConstant: 30),
            manageGroupActionView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        isManageDataViewLoaded = true
    }
    /// Configure header view for soho
    /// - Parameters:
    ///    - headerView: Soho header view to add to sub tray
    public func setupHeaderViewForSohoTray(with headerView: UIView) {
        headerStackView?.removeSubviews()
        headerStackView?.addArrangedSubview(headerView)
        headerStackView?.addArrangedSubview(subtitleLabel ?? VFGLabel())
    }
    /// *subtitleLabel* text
    func updateSubtitle() {
        guard let subtitle = dataSource?.title(for: self) else {
            return
        }

        subtitleLabel?.text = subtitle
    }

    public override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        guard highlightedItemIndex != nil else { return }
        hideExpandedView()
    }

    deinit {
        collectionViewWidthObserver = nil
    }
}

extension VFGHorizontalSubTrayView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        cellsCount
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let shimmerCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: shimmerCellId,
            for: indexPath) as? VFGSubTrayShimmerCell
        if let subItem = dataModel?.items?[indexPath.row] {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: horizontalCellId,
                for: indexPath) as? VFGSubTrayCollectionViewCell else {
                    return VFGSubTrayCollectionViewCell()
            }

            if subItem.badge != nil {
                badgeDelegates[indexPath.row] = cell
            }

            var isHighlighted = false
            if let highlightedIndex = highlightedItemIndex,
                highlightedIndex == indexPath.row {
                isHighlighted = true
            }

            cell.setup(
                item: subItem,
                index: indexPath.row,
                type: type,
                isLocked: dataSource?.isLocked(item: subItem, for: self) ?? false,
                isCustomizable: isSubTrayCustomizable,
                isHighlighted: isHighlighted
            )
            cell.customizeButtonActionClosure = {
                subItem.customizeAction(
                    VFGManagerFramework.trayDelegate?.subTrayItemsActions(.customization(subItem), self))
            }
            shimmerCell?.stopShimmer()
            indexPath.item == 0 ? setupFooterActionView() : ()
            return cell
        } else {
            shimmerCell?.startShimmer()
            return shimmerCell ?? VFGSubTrayShimmerCell()
        }
    }
}

extension VFGHorizontalSubTrayView: UICollectionViewDelegateFlowLayout {
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout
        let minimumInteritemSpacing = (flowLayout?.minimumInteritemSpacing ?? 0) * CGFloat(cellsCount)
        let alternativeWidth = UIScreen.main.bounds.width / 2 - minimumInteritemSpacing
        let width = cellsCount < 3 ? alternativeWidth : cellWidth
        return CGSize(width: width, height: cellHeight)
    }
}

extension VFGHorizontalSubTrayView: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedItem = dataModel?.items?[indexPath.row] else {
            return
        }
        selectedItem.action(delegate: self, expandedItem: nil)
    }
}
