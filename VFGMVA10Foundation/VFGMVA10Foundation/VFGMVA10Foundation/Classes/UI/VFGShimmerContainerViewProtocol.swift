//
//  VFGShimmerContainerViewProtocol.swift
//  VFGMVA10Foundation
//
//  Created by Mohamed Abd ElNasser on 05/05/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import Foundation

public protocol VFGShimmerContainerViewProtocol: UIView {
    var shimmerViews: [VFGShimmerView]? { get }
}

extension VFGShimmerContainerViewProtocol {
    public func startShimmer() {
        shimmerViews?.forEach {
            $0.startAnimation()
        }
    }

    public func stopShimmer() {
        removeFromSuperview()
    }
}
