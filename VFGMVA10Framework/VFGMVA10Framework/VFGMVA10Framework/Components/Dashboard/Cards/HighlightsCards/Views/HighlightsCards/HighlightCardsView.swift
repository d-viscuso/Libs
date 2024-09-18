//
//  HighlightCardsView.swift
//  VFGMVA10Framework
//
//  Created by Adel Aref on 29/08/2022.
//

import UIKit
import VFGMVA10Foundation

/// delegate to let the market configure an imageView
public protocol HighlightCardsViewImageViewDelegate: AnyObject {
    func configureImageView(imageView: UIImageView, imageUrl: String)
}

/// Highlights cards  view
public class HighlightCardsView: UIView {
    // MARK: - IBOutlet
    @IBOutlet weak var titleLabel: VFGLabel!
    @IBOutlet weak var iconImageView: VFGImageView!
    @IBOutlet weak var bottomTextLabel: VFGLabel!
    @IBOutlet weak var alertStatusView: UIView!
    @IBOutlet weak var contentAlertStatusView: UIView!
    @IBOutlet weak var centerStackView: UIStackView!
    @IBOutlet weak var backgroundImageView: VFGImageView!

    public weak var imageViewDelegate: HighlightCardsViewImageViewDelegate?
    public var viewModel: HighlightsCardsViewModel? {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.configure(with: self.viewModel?.model)
            }
        }
    }

    /// *HighlightCardsView* configuration
    func configure(with itemModel: HighlightCardModel?) {
        guard let model = itemModel else {
            return
        }
        titleLabel.text = model.title
        bottomTextLabel.text = model.bottomText
        if let iconName = model.iconName {
            iconImageView.download(by: iconName)
        }
        if let backgroundImageName = model.backgroundImageName {
            backgroundImageView.image = VFGImage(named: backgroundImageName )
        } else if let backgroundImageUrl = model.backgroundImageUrl {
            if let imageViewDelegate {
                imageViewDelegate.configureImageView(imageView: backgroundImageView, imageUrl: backgroundImageUrl)
            } else {
                backgroundImageView.download(by: backgroundImageUrl)
            }
        }
        setupLabelsTextColor(with: model.fontColorType)
        setupAlertStatus(color: viewModel?.alertStatusColor)
        setupCenterView()
    }

    func setupLabelsTextColor(with fontColor: HighlightCardModel.FontColor? = .dark) {
        switch fontColor {
        case .light:
            titleLabel.textColor = .VFGWhiteText
            bottomTextLabel.textColor = .VFGDarkGreyBackground
            self.backgroundColor = .clear
        default:
            titleLabel.textColor = .VFGPrimaryText
            bottomTextLabel.textColor = .VFGPageControlTint
        }
    }

    func setupAlertStatus(color: UIColor?) {
        alertStatusView.backgroundColor = color
        if color == nil {
            contentAlertStatusView.isHidden = true
            alertStatusView.isHidden = true
        }
    }

    func setupCenterView() {
        if let view = viewModel?.centerView {
            centerStackView.addArrangedSubview(view)
        }
    }
}
