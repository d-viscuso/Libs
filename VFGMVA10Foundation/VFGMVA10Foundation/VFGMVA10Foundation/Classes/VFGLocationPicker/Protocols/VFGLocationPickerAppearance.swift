//
//  VFGLocationPickerAppearance.swift
//  VFGMVA10Foundation
//
//  Created by Ahmed AbdElnabi on 31/10/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import MapKit

/// An appearance protocol that manages the layout of your location picker
/// You can customize location cell, current location button, annotation and selected annotation styles
public protocol VFGLocationPickerAppearance: AnyObject {
    /// Customize location cell style.
    /// - Parameter cell: Location cell.
    func applyLocationCellStyle(for cell: VFGLocationCell)
    /// Customize current location button style.
    /// - Parameters:
    ///   - view: Current location picker view associated with the appearance.
    ///   - currentLocationButton: Current location button.
    func applyCurrentLocationButtonStyle(_ view: VFGLocationPicker, for currentLocationButton: VFGButton)
    /// Customize default annotation view style.
    /// - Parameters:
    ///   - view: Current location picker view associated with the appearance.
    ///   - annotationView: Annotation view.
    func applyDefaultAnnotationStyle(_ view: VFGLocationPicker, for annotationView: MKAnnotationView)
    /// Customize selected annotation view style.
    /// - Parameters:
    ///   - view: Current location picker view associated with the appearance.
    ///   - annotationView: Annotation view.
    func applySelectedAnnotationStyle(_ view: VFGLocationPicker, for annotationView: MKAnnotationView)
}

public extension VFGLocationPickerAppearance {
    func applyLocationCellStyle(for cell: VFGLocationCell) {
        cell.accessibilityTraits.remove(.selected)
        cell.accessibilityHint = nil

        // Title label
        cell.titleLabel.font = UIFont.vodafoneBold(16.6)
        // Address label
        cell.addressLabel.font = UIFont.vodafoneRegular(14)
        // Details label
        cell.detailsLabel.font = UIFont.vodafoneRegular(14)
        cell.detailsLabel.textColor = .VFGTimelineCellBorder
        // Open label
        cell.openLabel.attributedText = {
            if let localizedText = cell.openLabel.text {
                let openText = localizedText.appending(" · ")
                let attributedString = NSMutableAttributedString(
                    string: openText,
                    attributes: [
                        .font: UIFont.vodafoneRegular(14.56),
                        .foregroundColor: UIColor.VFGPrimaryText
                    ]
                )

                attributedString.addAttribute(
                    .font,
                    value: UIFont.vodafoneBold(17),
                    range: NSRange(location: 0, length: localizedText.count)
                )

                attributedString.addAttribute(
                    .font,
                    value: UIFont(name: "PingFangSC-Regular", size: 17) ?? UIFont.vodafoneBold(17),
                    range: NSRange(location: localizedText.count, length: 2)
                )

                return attributedString
            }
            return NSAttributedString(string: "")
        }()
        // Time label
        cell.timeLabel.font = UIFont.vodafoneRegular(17)
        cell.timeLabel.textColor = .VFGPrimaryText
        // CTA
        cell.CTAButton.backgroundColor = .VFGPrimaryButton
        cell.CTAButton.tintColor = .VFGPrimaryButtonText
        cell.CTAButton.titleLabel?.font = UIFont.vodafoneRegular(18.7)
        cell.CTAButton.titleLabel?.textColor = .VFGPrimaryButtonText
    }

    func applyCurrentLocationButtonStyle(_ view: VFGLocationPicker, for currentLocationButton: VFGButton) {
        currentLocationButton.accessibilityTraits.remove(.selected)
        currentLocationButton.accessibilityHint = nil

        currentLocationButton.type = .icon
        currentLocationButton.backgroundColor = .VFGPrimaryButton
        currentLocationButton.cornerRadius = 5
        currentLocationButton.setImage(VFGFoundationAsset.Image.icLocateMeWhite, for: .normal)
    }

    func applyDefaultAnnotationStyle(_ view: VFGLocationPicker, for annotationView: MKAnnotationView) {
        annotationView.accessibilityTraits.remove(.selected)
        annotationView.accessibilityHint = nil

        annotationView.image = VFGFoundationAsset.Image.redDot
    }

    func applySelectedAnnotationStyle(_ view: VFGLocationPicker, for annotationView: MKAnnotationView) {
        annotationView.accessibilityTraits.remove(.selected)
        annotationView.accessibilityHint = nil

        annotationView.image = VFGFoundationAsset.Image.redPin
    }
}
