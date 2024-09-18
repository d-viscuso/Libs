//
//  FunFactView.swift
//  VFGMVA10Framework
//
//  Created by Ramy Nasser on 09/02/2022.
//

import UIKit
import VFGMVA10Foundation

/// A view that used to show fun fact at the end of dashboard
public class VFGFunFactView: UIView {
    @IBOutlet weak var imageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var hintView: BubbleView!
    @IBOutlet weak var topImageView: VFGImageView!
    @IBOutlet weak var descriptionLabel: VFGLabel!
    @IBOutlet weak var titleLabel: VFGLabel!

    /// the space between the image view and the hint view.
    var initialImageViewTopConstraint: CGFloat = 40
    /// the ratio for changing the space between the image view and the hint view.
    var parallexRatio: CGFloat = 10

    /// Configure fun fact views content
    /// - Parameters:
    ///   - model: Model that contain the content for view's
    public func configure(model: VFGFunFactModel?) {
        titleLabel.text = model?.title?.localized(bundle: Bundle.mva10Framework)
        formatDescription(description: model?.description?.localized(bundle: Bundle.mva10Framework) ?? "" )
        topImageView.image = model?.image
    }
    /// Configure fun fact views when the card will displayed and notify the delegate that fun fact will start
    public func willDisplay() {
        hintView?.setNeedsDisplay()
        VFGManagerFramework.funFactDelegate?.funFactWillStart()
    }
    ///  Change alpha for fun facts view while scrolling and also notify the delegate that fun fact did finish scrolling and that scrolling didChange
    /// - Parameters:
    ///   - percentage: percentage of the pulling for fun facts
    public func didScroll(percentage: CGFloat) {
        alpha = percentage
        parallexAnimation(offset: percentage)
        if percentage == 1 {
            VFGManagerFramework.funFactDelegate?.funFactDidFinish()
        } else {
            VFGManagerFramework.funFactDelegate?.funFactScrollingDidChange(ratio: percentage)
        }
    }
    ///  Change the image constraint while scrolling
    private func parallexAnimation(offset: CGFloat) {
        if offset < 1 {
            imageViewTopConstraint.constant = -initialImageViewTopConstraint + (offset * parallexRatio)
        } else if offset >= 1 {
            imageViewTopConstraint.constant = -initialImageViewTopConstraint
        }
    }
    ///  format  the description(
    private func formatDescription(description: String) {
        let attributedString = NSMutableAttributedString(
            string: description,
            attributes: [
                .font: UIFont.vodafoneRegular(16),
                .foregroundColor: UIColor.VFGPrimaryText
            ]
            )
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        paragraphStyle.alignment = .left
        attributedString.addAttribute(
            NSAttributedString.Key.paragraphStyle,
            value: paragraphStyle,
            range: NSRange(location: 0, length: attributedString.length)
        )
        descriptionLabel.attributedText = attributedString
    }
}
