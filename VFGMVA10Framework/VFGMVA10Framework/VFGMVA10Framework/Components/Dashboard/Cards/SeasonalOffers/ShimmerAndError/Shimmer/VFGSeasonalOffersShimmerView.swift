//
//  VFGSeasonalOffersShimmerView.swift
//  VFGMVA10Framework
//
//  Created by Ayman Ata on 27/02/2023.
//  Copyright © 2023 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

class VFGSeasonalOffersShimmerView: UIView {
    private let padding: CGFloat = 16
    lazy var shimmerView: VFGShimmerView = {
        let shimmer = VFGShimmerView()
        shimmer.translatesAutoresizingMaskIntoConstraints = false
        return shimmer
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        shimmerView.frame = bounds
        addSubview(shimmerView)
        NSLayoutConstraint.activate([
            shimmerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            shimmerView.topAnchor.constraint(equalTo: topAnchor),
            shimmerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            shimmerView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    func startShimmering() {
        shimmerView.theme = .mva12
        shimmerView.startAnimation()
    }

    func stopShimmering() {
        removeFromSuperview()
    }
}
