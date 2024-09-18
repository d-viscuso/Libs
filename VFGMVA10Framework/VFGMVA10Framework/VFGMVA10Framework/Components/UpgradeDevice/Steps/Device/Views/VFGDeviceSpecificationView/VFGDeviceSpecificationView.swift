//
//  VFGDeviceSpecificationView.swift
//  VFGMVA10Framework
//
//  Created by SAMEH on 24/05/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

class VFGDeviceSpecificationView: UIView {
    // MARK: - Outlets
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!

    // MARK: - Attributes
    let specificationCellId = "VFGDeviceSpecificationViewCell"
    var heightObserver: NSKeyValueObservation?
    let numberOfItemsInRow: CGFloat = 2
    let cellSpacing: CGFloat = 0
    let leftInsets: CGFloat = 48
    let rightInsets: CGFloat = 48
    let lineSpacing: CGFloat = 33

    weak var dataSource: VFGDeviceViewModelSpecificationsDataSource? {
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
        setHeightObserver()
        setupAccessibilityLabels()
    }

    private func setHeightObserver() {
        guard heightObserver == nil else { return }
        heightObserver = collectionView?.observe(\.contentSize, options: [.new]) { [weak self] _, _ in
            guard let self = self
                else { return }
            self.collectionViewHeightConstraint.constant = self.collectionView.contentSize.height
            self.layoutIfNeeded()
        }
    }

    deinit {
        heightObserver = nil
    }

    private func setupAccessibilityLabels() {
        [self, contentView, collectionView]
            .forEach { $0.isAccessibilityElement = false }
    }
}

// MARK: - UI Setup
extension VFGDeviceSpecificationView {
    func setupUI() {
        registerCollectionViewCell()
        setupCollectionViewLayout()
    }

    private func registerCollectionViewCell() {
        collectionView.register(
            UINib(nibName: specificationCellId, bundle: .mva10Framework),
            forCellWithReuseIdentifier: specificationCellId
        )
    }

    func setupCollectionViewLayout() {
        let layout = VFGSpecificationFlowLayout()
        layout.scrollDirection = .vertical
        layout.estimatedItemSize = calculateCellSize()
        layout.sectionInset = UIEdgeInsets(top: 0, left: leftInsets, bottom: 0, right: rightInsets)
        layout.minimumLineSpacing = lineSpacing
        layout.minimumInteritemSpacing = cellSpacing
        collectionView.setCollectionViewLayout(layout, animated: false)
    }

    func calculateCellSize() -> CGSize {
        let collectionViewWidth = collectionView.bounds.width - (leftInsets + rightInsets)
        let cellWidth = floor(collectionViewWidth / numberOfItemsInRow)
        let cellHeight: CGFloat = 50
        return CGSize(width: cellWidth, height: cellHeight)
    }
}

// MARK: - UICollectionViewDataSource - UICollectionViewDelegate
extension VFGDeviceSpecificationView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.numberOfSpecifications() ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: specificationCellId,
            for: indexPath
        ) as? VFGDeviceSpecificationViewCell ?? VFGDeviceSpecificationViewCell()
        cell.updateUI(specification: dataSource?.specification(at: indexPath.row))
        return cell
    }
}

extension VFGDeviceSpecificationView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return calculateCellSize()
    }
}
