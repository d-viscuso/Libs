//
//  SegmentedView.swift
//  VFGMVA10Framework
//
//  Created by Claudio Cavalli on 06/05/22.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import Foundation
import UIKit

// MARK: - SegmentedCollectionView.
public class SegmentedCollectionView: UIView {
    /// CollectionView to show.
    var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: SegmentedCollectionViewFlowLayout()
    )
    /// CollectionView dataSource.
    public var dataSource: SegmentedCollectionDataSource? {
        didSet {
            self.update()
        }
    }
    /// SegmentedCollectionView callback update controller.
    public var didTapCell: ((Int) -> Void)?
    /// SegmentedCollectionView callback update controller.
    public static var selectedName: String?
    /// SegmentedCollectionView awakeFromNib.
    public override func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
        self.style()
        self.layout()
    }
    /// SegmentedCollectionView init.
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
        self.style()
        self.layout()
    }
    /// SegmentedCollectionView required init.
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    /// SegmentedCollectionView setup.
    private func setup() {
        self.colletionViewSetup()
        self.addSubview(collectionView)
    }
    /// SegmentedCollectionView colletionViewSetup.
    private func colletionViewSetup() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(
            SegmentedFlexibleCell.self,
            forCellWithReuseIdentifier: SegmentedFlexibleCell.reuseIdentifier
        )
        collectionView.register(
            SegmentedFixedCell.self,
            forCellWithReuseIdentifier: SegmentedFixedCell.reuseIdentifier
        )
    }
    /// SegmentedCollectionView style.
    private func style() {
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
    }
    /// SegmentedCollectionView layout.
    private func layout() {
        // Snap collection view to the edges of the screen.
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.leftAnchor.constraint(equalTo: leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor),
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    /// SegmentedCollectionView update.
    private func update() {
        guard let dataSource = dataSource else { return }
        let index = IndexPath(row: dataSource.startIndex, section: 0)
        self.collectionView.reloadData()
        self.selectCell(indexPath: index)
        SegmentedCollectionView.selectedName = self.dataSource?.titles[index.row]
    }
    /// SegmentedCollectionView selectCell for scroll collection view.
    private func selectCell(indexPath: IndexPath) {
        guard let dataSource = dataSource else { return }
        let isOutOfBounds = dataSource.titles.count < indexPath.row
        let selectIndexPath = isOutOfBounds ? IndexPath(row: 0, section: 0) : indexPath
        let animation = dataSource.segmentedCellStyle == .flexible
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.didTapCell?(selectIndexPath.row)
            self.collectionView.selectItem(
                at: selectIndexPath,
                animated: animation,
                scrollPosition: .centeredHorizontally)
            self.collectionView.collectionViewLayout.invalidateLayout()
        }
    }
}

// MARK: - SegmentedCollectionView: UICollectionViewDelegate.
extension SegmentedCollectionView: UICollectionViewDelegate {
    /// SegmentedCollectionView collectionView change selected cell.
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectCell(indexPath: indexPath)
        ProductsManager.trackEvent(
            eventName: SegmentedCollectionView.selectedName ?? "",
            eventLabel: self.dataSource?.titles[indexPath.row] ?? "",
            pageName: "sub_tray_product_title".localized(bundle: .mva10Framework)
        )
        SegmentedCollectionView.selectedName = self.dataSource?.titles[indexPath.row]
    }
}

// MARK: - SegmentedCollectionView: UICollectionViewDataSource.
extension SegmentedCollectionView: UICollectionViewDataSource {
    /// SegmentedCollectionView selectCell for scroll collection view.
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.dataSource?.titles.count ?? 0
    }
    /// SegmentedCollectionView collectionView create cell.
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch dataSource?.segmentedCellStyle {
        case .flexible:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: SegmentedFlexibleCell.reuseIdentifier,
                for: indexPath) as? SegmentedFlexibleCell ?? SegmentedFlexibleCell(frame: .zero)
            cell.model = SegmentedFlexibleCellModel(
                title: dataSource?.titles[indexPath.row] ?? " ",
                height: self.frame.height)
            return cell
        case .compact:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: SegmentedFixedCell.reuseIdentifier,
                for: indexPath) as? SegmentedFixedCell ?? SegmentedFixedCell(frame: .zero)
            cell.model = SegmentedFixedCellModel(
                title: dataSource?.titles[indexPath.row] ?? " ",
                numberOfElement: dataSource?.titles.count ?? 0,
                height: self.frame.height)
            return cell
        case .none:
            return SegmentedFixedCell(frame: .zero)
        }
    }
}

// MARK: - SegmentedCollectionView: UICollectionViewDelegateFlowLayout.
extension SegmentedCollectionView: UICollectionViewDelegateFlowLayout {
    /// SegmentedCollectionView collectionView layout interspacing.
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0.0
    }
    /// SegmentedCollectionView collectionView layout minimumLineSpacingForSectionAt.
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0.0
    }
    /// SegmentedCollectionView collectionView layout insetForSectionAt.
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    }
}
