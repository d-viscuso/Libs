//
//  VFGStoreCollectionViewCell.swift
//  VFGMVA10Framework
//
//  Created by Moustafa Hegazy on 09/02/2021.
//

import UIKit

public class VFGLocationCell: UICollectionViewCell {
    @IBOutlet public weak var titleLabel: VFGLabel!
    @IBOutlet public weak var addressLabel: VFGLabel!
    @IBOutlet public weak var detailsLabel: VFGLabel!
    @IBOutlet public weak var openLabel: VFGLabel!
    @IBOutlet public weak var timeLabel: VFGLabel!
    @IBOutlet public weak var CTAButton: VFGButton!

    var onCTAButtonDidPress: (() -> Void)?
    weak var appearance: VFGLocationPickerAppearance?

    public override func awakeFromNib() {
        super.awakeFromNib()

        configureShadow()
    }

    func setup(with location: VFGLocation) {
        titleLabel.text = location.name
        addressLabel.text = location.address
        detailsLabel.text = location.details
        timeLabel.text = location.openingTime
        openLabel.text = location.status
        CTAButton.setTitle(
            location.ctaTitle,
            for: .normal
        )
        addAccessibilityForVoiceOver()
    }

    @IBAction func ctaButtonDidPress(_ sender: VFGButton) {
        ctaButtonAction()
    }

    @objc func ctaButtonAction() {
        onCTAButtonDidPress?()
    }

    func setupAccessibilityIds(at index: Int) {
        titleLabel.accessibilityIdentifier = "LCtitleLabel_\(index)"
        addressLabel.accessibilityIdentifier = "LCaddressLabel_\(index)"
        detailsLabel.accessibilityIdentifier = "LCdetailsLabel_\(index)"
        openLabel.accessibilityIdentifier = "LCopenLabel_\(index)"
        timeLabel.accessibilityIdentifier = "LCtimeLabel_\(index)"
        CTAButton.accessibilityIdentifier = "LCctaButton_\(index)"
    }
}
public extension VFGLocationCell {
    func addAccessibilityForVoiceOver() {
        titleLabel.accessibilityLabel = titleLabel.text
        addressLabel.accessibilityLabel = addressLabel.text
        detailsLabel.accessibilityLabel = detailsLabel.text
        timeLabel.accessibilityLabel = timeLabel.text
        openLabel.accessibilityLabel = openLabel.text
        accessibilityCustomActions = [ctaVoiceOverAction()]
    }
    /// action for book appointment voice over
    /// - Returns: action for cta button in voice over
    func ctaVoiceOverAction() -> UIAccessibilityCustomAction {
        let actionName = CTAButton.titleLabel?.text ?? ""
        return UIAccessibilityCustomAction(name: actionName, target: self, selector: #selector(ctaButtonAction))
    }
}
