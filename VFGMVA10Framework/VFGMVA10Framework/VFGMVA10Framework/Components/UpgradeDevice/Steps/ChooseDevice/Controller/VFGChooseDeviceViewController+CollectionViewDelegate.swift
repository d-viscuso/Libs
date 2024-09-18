//
//  VFGChooseDeviceViewController+CollectionViewDelegate.swift
//  VFGMVA10Framework
//
//  Created by Moamen Abd Elgawad on 18/05/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

extension VFGChooseDeviceViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfDevices()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: VFGChooseDeviceCollectionCellId,
                for: indexPath) as? VFGChooseDeviceCollectionCell else {
            return VFGChooseDeviceCollectionCell()
        }

        cell.setupCell(
            with: viewModel.device(at: indexPath.row),
            isSelected: viewModel.isDeviceSelected(indexPath.row)
        )

        cell.chooseButtonDidPress = { [weak self] in
            defer {
                self?.status = .passed
                self?.onStepComplete?(self?.viewModel.selectedDevice as Any)
            }

            guard
                let self = self,
                !self.viewModel.isSelectedDeviceEqualDevice(at: indexPath.row) else {
                return
            }

            self.onPriceChange?(self.viewModel.device(at: indexPath.row))
            self.viewModel.swapSelectedDeviceWithDevice(at: indexPath.row)
            self.onContentHeightChange?(self.contentHeight + 110)
            self.onStepStatusChange?(.pending)

            self.collectionView.reloadData()
            self.collectionView.selectItem(
                at: IndexPath(item: 0, section: 0),
                animated: false,
                scrollPosition: .centeredHorizontally
            )
        }

        return cell
    }
}

extension VFGChooseDeviceViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize
    }
}
