//
//  ProductsErrorTableViewCell.swift
//  VFGMVA10Framework
//
//  Created by Moustafa Hegazy on 02/07/2021.
//

import VFGMVA10Foundation

class ProductsErrorTableViewCell: UITableViewCell {
    @IBOutlet weak var errorImage: VFGImageView!
    @IBOutlet weak var errorLabel: VFGLabel!
    @IBOutlet weak var tryAgainLabel: VFGLabel!
    @IBOutlet weak var refreshIcon: VFGImageView!
    @IBOutlet weak var refreshButton: VFGButton!
    var refreshAction = {}

    func setupErrorCell() {
        refreshIcon.image = VFGFrameworkAsset.Image.icRefreshRed
        errorLabel.text = "my_plan_screen_error_message".localized(bundle: .mva10Framework)
        tryAgainLabel.text = "my_plan_screen_try_again".localized(bundle: .mva10Framework)
        setAccessibilityForVoiceOver()
    }

    @IBAction func refreshButtonDidPressed(_ sender: UIButton) {
        refreshButtonAction()
    }

    @objc func refreshButtonAction() {
        refreshAction()
    }
}

extension ProductsErrorTableViewCell {
    /// set accessibility for voice over
    func setAccessibilityForVoiceOver() {
        errorImage.accessibilityLabel = "Warning icon"
        errorLabel.accessibilityLabel = errorLabel.text
        refreshButton.accessibilityLabel = tryAgainLabel.text
        accessibilityCustomActions = [ refreshButtonVoiceOverAction() ]
    }

    /// action for refresh button in voice over
    /// - Returns: action for refresh button in voice over
    func refreshButtonVoiceOverAction() -> UIAccessibilityCustomAction {
        let actionName = "refresh"
        return UIAccessibilityCustomAction(name: actionName, target: self, selector: #selector(refreshButtonAction))
    }
}
