//
//  AddOnsCVMCell.swift
//  VFGMVA10Framework
//
//  Created by Esraa Eldaltony on 8/25/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

class AddOnsCVMCell: UICollectionViewCell {
    @IBOutlet weak var cellContentView: UIView!
    @IBOutlet weak var title: VFGLabel!
    @IBOutlet weak var subtitle: VFGLabel!
    @IBOutlet weak var thumbnail: VFGImageView!
    @IBOutlet weak var cardImage: VFGImageView!
    @IBOutlet weak var descriptionLabel: VFGLabel!
    @IBOutlet weak var addButton: VFGButton!
    weak var delegate: AddOnsCVMProtocol?
    var itemVM: AddOnsCVMModelProtocol?

    override func awakeFromNib() {
        super.awakeFromNib()
        cellContentView.layer.borderWidth = 1
        cellContentView.layer.borderColor = UIColor.VFGVeryLightGreyBackground.cgColor
        cardImage.configureShadow()
    }

    @IBAction func addButton(_ sender: Any) {
        addButtonAction()
    }

    @objc func addButtonAction() {
        delegate?.addAction(itemVM: itemVM)
    }
    func setupCell(with itemVM: AddOnsCVMModelProtocol) {
        self.itemVM = itemVM
        title.text = itemVM.title
        subtitle.text = itemVM.subTitle
        descriptionLabel.text = itemVM.addOnDescription
        addButton.setTitle(itemVM.addOnButtonTitle, for: .normal)

        if let imageName = itemVM.imageName {
            thumbnail.image = UIImage(
                named: imageName,
                in: Bundle.mva10Framework,
                compatibleWith: nil)
        }
        if let cardImageName = itemVM.addOnCardName {
            cardImage.image = UIImage(
                named: cardImageName,
                in: Bundle.mva10Framework,
                compatibleWith: nil)
        }
        setupAccessibilityLabels()
    }
}

extension AddOnsCVMCell {
    func setupAccessibilityLabels() {
        title.accessibilityLabel = title.text ?? ""
        subtitle.accessibilityLabel = subtitle.text ?? ""
        descriptionLabel.accessibilityLabel = descriptionLabel.text ?? ""
        addButton.accessibilityLabel = addButton.titleLabel?.text ?? ""
        accessibilityCustomActions = [addButtonOnsVoiceOverAction()]
    }
    /// action for product AddOn  voice over
    /// - Returns: action for product AddOn  buttons in voice over
    func addButtonOnsVoiceOverAction() -> UIAccessibilityCustomAction {
        let actionName = "buyAddOns"
        return UIAccessibilityCustomAction(name: actionName, target: self, selector: #selector(addButtonAction))
    }
}
