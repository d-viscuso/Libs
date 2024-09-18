//
//  VFGShopViewController.swift
//  VFGMVA10Framework
//
//  Created by Ayman Ata on 25/01/2023.
//  Copyright © 2023 Vodafone. All rights reserved.
//

import UIKit

/// **VFGShopViewController** is view that can present shop items, it can be used independently or it can be embedded in the tabbar.
public final class VFGShopViewController: UIViewController {
    var viewModel: VFGShopViewModel?
    var collectionView: UICollectionView?
    private let cellIdentifier = "VFGShopViewCellIdentifier"

    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    /// Creates a new instance of VFGShopViewController depending on the given view-model.
    /// - Parameter viewModel: A view-model that contains required data to make this view controller works properly.
    public required init(viewModel: VFGShopViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupCollectionView() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = viewModel?.scrollDirection ?? .horizontal
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView?.backgroundColor = .white
        collectionView?.delegate = self
        collectionView?.dataSource = self
        let cellNib = UINib(
            nibName: String(describing: VFGShopViewCell.self),
            bundle: .mva10Framework
        )
        collectionView?.register(cellNib, forCellWithReuseIdentifier: cellIdentifier)
    }

    private func setupUI() {
        setupCollectionView()
        guard let collectionView else { return }
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - UICollectionView data source functions
extension VFGShopViewController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel?.numberOfItems ?? 0
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: cellIdentifier, for: indexPath) as? VFGShopViewCell,
            let model = viewModel?.modelAt(index: indexPath)
        else { return UICollectionViewCell() }
        cell.setupWith(model)
        return cell
    }
}

// MARK: - UICollectionView flow layout functions
extension VFGShopViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(
            width: viewModel?.cellWidth ?? 0,
            height: viewModel?.cellHeight ?? 0
        )
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        viewModel?.spaceBetweenCells ?? 0
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        viewModel?.inbetweenSpace ?? 0
    }
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        UIEdgeInsets(
            top: viewModel?.topInset ?? 0,
            left: viewModel?.rightLeftInsets ?? 0,
            bottom: viewModel?.bottomInset ?? 0,
            right: viewModel?.rightLeftInsets ?? 0
        )
    }
}
