//
//  VFGAddPlanView+VFGPaymentMethodsDelegate.swift
//  VFGMVA10Framework
//
//  Created by Mohamed Abd ElNasser on 12/1/20.
//

import Foundation

extension VFGAddPlanView: VFGPaymentMethodsCardViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didHeightChanged height: CGFloat) {
        layoutIfNeeded()
    }
}
