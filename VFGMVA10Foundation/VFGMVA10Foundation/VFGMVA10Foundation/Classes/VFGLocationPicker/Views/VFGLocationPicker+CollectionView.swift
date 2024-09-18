//
//  VFGLocationPicker+CollectionView.swift
//  VFGMVA10Framework
//
//  Created by Yahya Saddiq on 2/8/21.
//  Copyright © 2021 Vodafone. All rights reserved.
//

extension VFGLocationPicker: UICollectionViewDelegate, UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch contentState {
        case .empty:
            return 0
        case .loading:
            return 2
        case .populated:
            return dataSource?.numberOfLocations(self) ?? 0
        case .error:
            return 0
        }
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let reuseId = String(
            describing: contentState == .loading ? VFGLocationShimmerCell.self : VFGLocationCell.self
        )
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: reuseId,
            for: indexPath
        )

        if let location = dataSource?.locationPicker(self, locationAt: indexPath.row) {
            (cell as? VFGLocationCell)?.appearance = appearance
            (cell as? VFGLocationCell)?.setup(with: location)
            (cell as? VFGLocationCell)?.setupAccessibilityIds(at: indexPath.row)
            (cell as? VFGLocationCell)?.onCTAButtonDidPress = { [weak self] in
                guard let self = self else { return }
                self.delegate?.locationPicker(
                    self,
                    locationCTADidPress: location,
                    at: indexPath.row
                )
            }
            cell.isAccessibilityElement = false
            cell.accessibilityIdentifier = "APlocationCell_\(indexPath.row)"
        }

        (cell as? VFGLocationShimmerCell)?.startShimmer()

        return cell
    }

    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isUserScrolling = true
    }

    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        isUserScrolling = false
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let locationsCollectionView = locationsCollectionView else {
            return
        }

        if scrollView is UICollectionView {
            let xPosition = locationsCollectionView.bounds.size.width / 2 + locationsCollectionView.contentOffset.x
            let yPosition = locationsCollectionView.bounds.size.height / 2 + locationsCollectionView.contentOffset.y
            let collectionViewCenter = CGPoint(x: xPosition, y: yPosition)
            let centeredCellIndexPath = locationsCollectionView.indexPathForItem(at: collectionViewCenter)

            guard let path = centeredCellIndexPath else {
                return
            }

            if isUserScrolling {
                selectAnnotation(at: path.row)
                if let location = dataSource?.locationPicker(self, locationAt: path.row) {
                    delegate?.locationPicker(
                        self,
                        locationCellDidSelect: location,
                        at: path.row
                    )
                }
            }
        }
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectAnnotation(at: indexPath.row)
    }
}

extension VFGLocationPicker: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellHeight: CGFloat = 200
        let horizontalSideInset: CGFloat = 16

        return CGSize(
            width: UIScreen.main.bounds.width - (horizontalSideInset * 2),
            height: cellHeight
        )
    }
}

extension VFGLocationPicker: VFGLocationPickerAppearance {}
