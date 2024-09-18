//
//  VFFTEPageView.swift
//  MyVodafone
//
//  Created by Alberto Garcia-Muñoz on 24/07/2019.
//  Copyright © 2019 TSSE. All rights reserved.
//

import UIKit

class VFUserGuidesPageView: UIScrollView {
    var containerView: UIView
    var titleLabel: VFGLabel
    var subtitleLabel: UILabel
    var imageView: UIImageView
    var descriptionLabel: UILabel
    var imageHeightConstraint: NSLayoutConstraint?
    unowned let page: UserGuidesPage

    init(frame: CGRect, page: UserGuidesPage) {
        self.page = page
        self.containerView = UIView()
        self.titleLabel = VFGLabel()
        self.subtitleLabel = UILabel()
        self.imageView = UIImageView()
        self.descriptionLabel = UILabel()
        super.init(frame: frame)
        configure()
        applyModel()
        setupAccessibility()
    }

    required init?(coder: NSCoder) {
        // init(coder:) has not been implemented
        return nil
    }

    func setupAccessibility() {
        titleLabel.accessibilityLabel = page.title
        subtitleLabel.accessibilityLabel = page.subtitle
        imageView.isAccessibilityElement = true
        imageView.accessibilityLabel = page.imageDescription
        descriptionLabel.accessibilityLabel = page.details
    }

    public func applyModel() {
        let titleFont = "vodafone-regular"
        var html = page.title.convertToHtml(fontSize: 32, fontSizeType: .pixel, fontName: titleFont, color: .darkGray)
        titleLabel.attributedText = html
        let fontName = "vodafone-regular "
        html = page.subtitle.convertToHtml(fontSize: 20, fontSizeType: .pixel, fontName: fontName, color: .darkGray)
        subtitleLabel.attributedText = html
        let description = page.details ?? ""
        descriptionLabel.isHidden = description.isEmpty
        html = description.convertToHtml(fontSize: 20, fontSizeType: .point, fontName: fontName, color: .darkGray)
        descriptionLabel.attributedText = html
        layoutIfNeeded()
        let url = page.imageURL
        guard let urlR = url else {
            return
        }
        guard  let data = try? Data(contentsOf: urlR) else { self.imageView.isHidden = true
            return
        }
        self.imageView.image = UIImage(data: data)
        self.onImageFetched(self.imageView.image ?? UIImage())
    }

    private func onImageFetched(_ image: UIImage) {
        let aspectRatio = image.size.height / image.size.width
        imageHeightConstraint?.isActive = false
        let width = imageView.widthAnchor
        imageHeightConstraint = imageView.heightAnchor.constraint(equalTo: width, multiplier: aspectRatio)
        imageHeightConstraint?.isActive = true
        layoutIfNeeded()
    }
}
