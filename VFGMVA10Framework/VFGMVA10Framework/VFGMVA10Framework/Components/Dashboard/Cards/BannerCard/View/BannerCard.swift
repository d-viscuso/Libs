//
//  BannerCard.swift
//  VFGMVA10Framework
//
//  Created by Ahmed AbdElnabi on 24/07/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

/// A view which represents the base view for the subtypes of first card type.
public class BannerCard: UIView {
    @IBOutlet weak var backgroundImageView: VFGImageView!
    @IBOutlet weak var actionLabel: VFGLabel!
    @IBOutlet weak var actionImageView: VFGImageView!
    @IBOutlet weak var pointsBadge: VFGPointsBadgeView!
    @IBOutlet weak var sideImageView: VFGImageView!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var contentView: UIView!

    /// Banner card delegate.
    public weak var delegate: BannerCardDelegate? {
        didSet {
            setupBackgroundImage()
        }
    }
    /// A flag which is used to show a vodafone background as a default if there is no "bgImage" provided through *BannerCardModel* model.
    public var showDefaultBackground = false {
        didSet {
            setupBackgroundImage()
        }
    }
    public var bannerAction: (() -> Void)?

    private var model: BannerCardModel?

    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }

    public override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        CATransaction.withDisabledActions {
            gradientView.layer.sublayers?.first?.frame = self.bounds
        }
    }

    /// A method used to configure view with data model.
    /// - Parameter model: A model of type *BannerCardModel* which holds view data.
    public func configure(with model: BannerCardModel) {
        self.model = model
        sideImageView.image = VFGImage(named: model.serviceIcon)
        setupActionElement()
        setupBackgroundImage()
        setupGradientOverlay()
        setupPointsElement()
    }

    /// A method to setup subview on the base banner view to create a new subtype view.
    /// - Parameter view: An instance of type *UIView* used as a content view for banner view.
    public func setup(contentView view: UIView) {
        contentView.removeSubviews()
        contentView.addSubview(view)
        view.fresh.makeConstraints { make in
            make.top == self.fresh.top
            make.left == self.fresh.left
            make.right == self.fresh.right
            make.bottom == self.fresh.bottom
        }
    }

    private func xibSetup() {
        let bundle = Bundle.mva10Framework
        guard let contentView = loadViewFromNib(
            nibName: String(describing: BannerCard.self),
            in: bundle
        ) else { return }
        xibSetup(contentView: contentView)
    }

    private func setupGradientOverlay() {
        if model?.showGradientOverlay ?? false {
            gradientView.layer.sublayers?.forEach { layer in
                layer.removeFromSuperlayer()
            }
            gradientView.addGradient(
                direction: model?.gradientDirection ?? .leftToRight,
                colors: [
                    UIColor(red: 0, green: 0, blue: 0, alpha: 0.7).cgColor,
                    UIColor(red: 0, green: 0, blue: 0, alpha: 0).cgColor
                ])
        }
    }

    private func setupPointsElement() {
        guard let points = model?.points else {
            pointsBadge.isHidden = true
            return
        }
        pointsBadge.isHidden = false
        pointsBadge.configure(with: points)
    }

    private func setupBackgroundImage() {
        guard let model = model,
            let bgImage = model.bgImage else {
            if showDefaultBackground {
                backgroundImageView.image = VFGFrameworkAsset.Image.bannerVodafoneBackground
            }
            return
        }
        backgroundImageView.image = VFGImage(named: bgImage)
        delegate?.bannerView(
            self,
            configureBackground: backgroundImageView,
            with: model)
    }

    private func setupActionElement() {
        guard let model = model else { return }
        actionLabel.text = model.link?.actionTitle
        actionImageView.image = VFGImage(named: model.link?.actionIcon)
        if let actionTitleColor = model.link?.actionTitleColor {
            actionLabel.textColor = UIColor(hexString: actionTitleColor)
        }
    }

    @IBAction func bannerViewDidPress(_ sender: Any) {
        bannerAction?()
    }
}
