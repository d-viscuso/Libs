//
//  VFGSeasonalOffersErrorView.swift
//  VFGMVA10Framework
//
//  Created by Ayman Ata on 27/02/2023.
//  Copyright © 2023 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

class VFGSeasonalOffersErrorView: UIView {
    var errorView: VFGErrorView?
    override init(frame: CGRect) {
        super.init(frame: frame)
        roundCorners(cornerRadius: 6)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(errorModel: VFGErrorModel, tryAgainClosure: (() -> Void)?) {
        backgroundColor = .white
        errorView = VFGErrorView(error: errorModel)
        guard let errorView else { return }
        errorView.errorImageView.image = VFGFrameworkAsset.Image.warning
        errorView.configureErrorViewConstraints(imageViewTop: 20, stackSpace: 16)
        errorView.refreshingClosure = tryAgainClosure
        embed(view: errorView)
    }
}
