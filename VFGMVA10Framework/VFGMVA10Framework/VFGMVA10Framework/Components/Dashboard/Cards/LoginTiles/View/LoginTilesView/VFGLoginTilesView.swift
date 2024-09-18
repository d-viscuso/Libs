//
//  VFGLoginTilesView.swift
//  VFGMVA10Framework
//
//  Created by Ahmed AbdElnabi on 06/11/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import VFGMVA10Foundation
import UIKit

/// An enum which represents the two login tiles types.
public enum VFGLoginTilesType {
    case first
    case second
}

/// A view which shows two tiles each tile holds title, description and CTA.
public class VFGLoginTilesView: UIView {
    /// Container stackView outlet
    @IBOutlet weak var containerStackView: UIStackView!
    /// First tile IBOutlet
    @IBOutlet weak var firstTileContainerView: UIView!
    @IBOutlet weak var firstTileBackground: UIView!
    @IBOutlet weak var firstTileTitle: VFGLabel!
    @IBOutlet weak var firstTileDescription: VFGLabel!
    @IBOutlet weak var firstTileCTA: VFGButton!
    /// Second tile IBOutlet
    @IBOutlet weak var secondTileContainerView: UIView!
    @IBOutlet weak var secondTileBackground: UIView!
    @IBOutlet weak var secondTileTitle: VFGLabel!
    @IBOutlet weak var secondTileDescription: VFGLabel!
    @IBOutlet weak var secondTileCTA: VFGButton!

    let startPoint = CGPoint(x: 0.8, y: 0)
    /// ErrorView height .
    let errorViewHeight: CGFloat = 232
    /// A completion handler that returns the dashboard login titles view height.
    var cardViewHeightCompletion: ((CGFloat) -> Void)?
    /// Instance of *VFGErrorView*.
    var errorView: VFGErrorView?
    /// shimmerView of *LoginTilesShimmerView*
    var shimmerView: LoginTilesShimmerView?

    lazy var contentHeight: CGFloat = {
        self.frame.height + self.frame.origin.y
    }()

    public weak var dataSource: VFGLoginTilesDataSource? {
        didSet {
            guard dataSource != nil else {
                state = .error
                return
            }
            state = .populated
            DispatchQueue.main.async {
                self.setupLoginTilesData()
                self.cardViewHeightCompletion?(self.contentHeight)
            }
        }
    }
    public weak var delegate: VFGLoginTilesDelegate?
    public weak var appearance: VFGLoginTilesAppearance? {
        didSet {
            setupAppearance()
        }
    }

    /// State of  the **LoginTilesView**
    public var state: VFGContentState = .loading {
        didSet {
            if state != .error {
                removeErrorView()
            }
            switch state {
            case .loading:
                self.containerStackView.isHidden = true
                showShimmerView()
                self.cardViewHeightCompletion?( self.containerStackView.bounds.height)
            case .populated:
                self.containerStackView.isHidden = false
                self.removeShimmerView()
                self.cardViewHeightCompletion?(self.bounds.height)
            case .error:
                self.containerStackView.isHidden = true
                self.removeShimmerView()
                self.cardViewHeightCompletion?(self.bounds.height)
            default:
                break
            }
        }
    }

    public override func awakeFromNib() {
        super.awakeFromNib()
        appearance = appearance == nil ? self : appearance
        setupTilesShadow()
        setupLoginTilesData()
    }

    public override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        CATransaction.withDisabledActions { [weak self] in
            guard let self = self else { return }
            self.updateBackgroundGradientLayerFrame()
        }
    }

    @IBAction func firstTileCTADidPress(_ sender: UIButton) {
        guard let tileData = dataSource?.loginTiles(self).firstTile else { return }
        delegate?.loginTiles(
            self,
            tileCTADidPress: tileData,
            forTile: .first)
    }

    @IBAction func secondTileCTADidPress(_ sender: UIButton) {
        guard let tileData = dataSource?.loginTiles(self).secondTile else { return }
        delegate?.loginTiles(
            self,
            tileCTADidPress: tileData,
            forTile: .second)
    }

    private func setupLoginTilesData() {
        guard state != .error else { return }
        setupFirstLoginTileData()
        setupSecondLoginTileData()
    }

    private func setupFirstLoginTileData() {
        guard let tileData = dataSource?.loginTiles(self).firstTile else { return }
        firstTileTitle.text = tileData.title
        firstTileDescription.text = tileData.description
        firstTileCTA.setTitle(tileData.ctaTitle, for: .normal)
    }

    private func setupSecondLoginTileData() {
        guard let tileData = dataSource?.loginTiles(self).secondTile else { return }
        secondTileTitle.text = tileData.title
        secondTileDescription.text = tileData.description
        secondTileCTA.setTitle(tileData.ctaTitle, for: .normal)
    }

    private func setupAppearance() {
        setupGradientBackground()
        setupTilesLabels()
        setupTilesBackgrounds()
    }

    private func setupTilesShadow() {
        firstTileContainerView.configureShadow()
        secondTileContainerView.configureShadow()
    }

    private func updateBackgroundGradientLayerFrame() {
        firstTileBackground.layer.sublayers?.first?.frame = firstTileBackground.bounds
        secondTileBackground.layer.sublayers?.first?.frame = secondTileBackground.bounds
    }

    private func setupTilesLabels() {
        setupFirstTileLabels()
        setupSecondTileLabels()
    }

    private func setupFirstTileLabels() {
        appearance?.applyFontStyle(forTile: .first, withTitle: firstTileTitle)
        appearance?.applyFontStyle(forTile: .first, withDescription: firstTileDescription)
        appearance?.applyStyle(forTile: .first, withButton: firstTileCTA)
    }

    private func setupSecondTileLabels() {
        appearance?.applyFontStyle(forTile: .second, withTitle: secondTileTitle)
        appearance?.applyFontStyle(forTile: .second, withDescription: secondTileDescription)
        appearance?.applyStyle(forTile: .second, withButton: secondTileCTA)
    }

    private func setupTilesBackgrounds() {
        setupFirstTileBackground()
        setupSecondTileBackground()
    }

    private func setupFirstTileBackground() {
        appearance?.applyBackgroundStyle(forTile: .first, background: firstTileBackground)
    }

    private func setupSecondTileBackground() {
        appearance?.applyBackgroundStyle(forTile: .second, background: secondTileBackground)
    }

    private func setupGradientBackground() {
        setupFirstTileGradientBackground()
        setupSecondTileGradientBackground()
    }

    private func setupFirstTileGradientBackground() {
        if appearance?.showGradientOverlay(self, forTile: .first) ?? false {
            firstTileBackground.setGradientBackgroundColor(
                colors: [
                    UIColor(red: 0, green: 0, blue: 0, alpha: 0).cgColor,
                    UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor
                ],
                startPoint: startPoint
            )
        }
    }

    private func setupSecondTileGradientBackground() {
        if appearance?.showGradientOverlay(self, forTile: .second) ?? false {
            secondTileBackground.setGradientBackgroundColor(
                colors: [
                    UIColor(red: 0, green: 0, blue: 0, alpha: 0).cgColor,
                    UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor
                ],
                startPoint: startPoint
            )
        }
    }

    public func showErrorCard(
        with errorConfig: VFGErrorModel,
        tryAgain completion: (() -> Void)?
    ) {
        state = .error
        errorView = VFGErrorView(error: errorConfig)
        errorView?.configureErrorViewConstraints(imageViewTop: 72, stackSpace: 40)
        errorView?.errorImageView.image = VFGFrameworkAsset.Image.warning
        errorView?.backgroundColor = .VFGWhiteText
        errorView?.configureShadow()
        embed(view: errorView ?? UIView())
        errorView?.refreshingClosure = {
            self.state = .loading
            completion?()
        }
        DispatchQueue.main.async { [weak self] in
            self?.cardViewHeightCompletion?(self?.errorViewHeight ?? 0.0)
        }
    }

    func showShimmerView() {
        shimmerView = .init(frame: .zero)
        guard let shimmerView else { return }
        shimmerView.startShimmer()
        self.embed(view: shimmerView)
        self.layoutIfNeeded()
    }

    func removeShimmerView() {
        shimmerView?.stopShimmer()
        shimmerView?.removeFromSuperview()
        shimmerView = nil
    }

    func removeErrorView() {
        errorView?.removeFromSuperview()
        errorView = nil
    }
}

extension VFGLoginTilesView: VFGLoginTilesAppearance {}
