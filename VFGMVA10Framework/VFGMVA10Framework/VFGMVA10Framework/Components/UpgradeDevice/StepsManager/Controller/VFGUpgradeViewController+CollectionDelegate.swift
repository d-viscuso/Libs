//
//  VFGUpgradeViewController+CollectionDelegate.swift
//  VFGMVA10Framework
//
//  Created by Moustafa Hegazy on 18/05/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

extension VFGUpgradeViewController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        stepsViewControllers.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: stepsCollectionCellId,
            for: indexPath) as? StepsCollectionCell else {
            return UICollectionViewCell()
        }

        cell.hostedController = stepsViewControllers[indexPath.row]
        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension VFGUpgradeViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}
