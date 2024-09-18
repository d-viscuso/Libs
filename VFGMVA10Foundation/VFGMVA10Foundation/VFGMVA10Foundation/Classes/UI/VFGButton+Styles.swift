//
//  VFGButton+Styles.swift
//  VFGMVA10Foundation
//
//  Created by Moustafa Hegazy on 04/08/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import UIKit
import Lottie

extension VFGButton {
    // MARK: - Primary
    func updatePrimaryLightBackgroundColor() {
        if isHighlighted {
            backgroundColor = .primaryButtonBGPressed
        } else if isEnabled {
            backgroundColor = .primaryButtonBGDefault
        } else {
            backgroundColor = .primaryButtonBGDisabled
        }
        loadingAnimationView.animation = Animation.vodafoneLogoWhite
    }

    func updatePrimaryLightTextColor() {
        let textColor: UIColor
        if isHighlighted || isEnabled {
            textColor = .white
        } else {
            textColor = .VFGDisabledButtonText
        }
        setTitleColor(textColor, for: .normal)
    }


    // MARK: Primary Colored
    func updatePrimaryColoredBackgroundColor() {
        if isHighlighted || isEnabled {
            backgroundColor = .primaryButtonColoredBG
        } else {
            backgroundColor = .VFGDisabledButtonRedBG
        }
    }

    func updatePrimaryColoredTextColor() {
        let textColor: UIColor
        if isHighlighted || isEnabled {
            textColor = .primaryButtonColoredText ?? .black
        } else {
            textColor = .VFGDisabledButtonText
        }
        setTitleColor(textColor, for: .normal)
    }

    // MARK: - Secondary
    func updateSecondaryLightBackgroundColor() {
        if isEnabled {
            backgroundColor = .secondaryButtonBGDefault
            if isHighlighted {
                backgroundColor = .secondaryButtonBGPressed
            }
        } else {
            backgroundColor = .secondaryButtonBGDisabled
        }
    }

    func updateSecondaryLightTextColor() {
        setTitleColor(.secondaryButtonTextColor, for: .normal)
    }

    // MARK: - Secondary Colored
    func updateSecondaryColoredBackgroundColor() {
        if isEnabled || isHighlighted {
            layer.borderWidth = 2
            backgroundColor = .clear
            layer.borderColor = UIColor.secondaryColoredButtonBoarder?.cgColor
        } else {
            backgroundColor = .VFGDisabledButtonRedBG
        }
    }

    func updateSecondaryColoredTextColor() {
        setTitleColor(.secondaryColoredButtonText, for: .normal)
        if !isEnabled {
            setTitleColor(.VFGDisabledButtonTextRedBG, for: .normal)
        }
    }

    // MARK: - Alt1 Light
    func updateAlt1LightBackgroundColor() {
        if isEnabled {
            layer.borderWidth = 2
            backgroundColor = .clear
            layer.borderColor = UIColor.alt1ButtonBoarder?.cgColor
            if isHighlighted {
                layer.borderWidth = 0
                backgroundColor = .alt1ButtonBGPressed
            }
        } else {
            layer.borderWidth = 2
            backgroundColor = .clear
            layer.borderColor = UIColor.alt1ButtonBoarderDisabled?.cgColor
        }
        if self.traitCollection.userInterfaceStyle == .light {
            loadingAnimationView.animation = Animation.vodafoneLogoRed
        } else {
            loadingAnimationView.animation = Animation.vodafoneLogoWhite
        }
    }

    func updateAlt1LightTextColor() {
        if isHighlighted {
            setTitleColor(.alt1PressedButtonTextColor, for: .normal)
        } else if isEnabled {
            setTitleColor(.alt1DefaultButtonTextColor, for: .normal)
        } else {
            setTitleColor(.alt1ButtonTextDisabled, for: .normal)
        }
    }

    // MARK: - Alt1 Colored
    func updateAlt1ColoredBackgroundColor() {
        if isEnabled {
            layer.borderWidth = 2
            backgroundColor = .clear
            layer.borderColor = UIColor.white.cgColor
            if isHighlighted {
                layer.borderWidth = 0
                backgroundColor = .alt1ButtonBGPressed
            }
        } else {
            layer.borderWidth = 2
            backgroundColor = .clear
            layer.borderColor = UIColor.alt1ButtonBoarderDisabled?.cgColor
        }
    }

    // MARK: - Alt2 Light
    func updateAlt2LightBackgroundColor() {
        if isEnabled {
            layer.borderWidth = 2
            backgroundColor = .clear
            layer.borderColor = UIColor.alt2ButtonBoarder?.cgColor
            if isHighlighted {
                layer.borderWidth = 0
                backgroundColor = .alt2ButtonBGPressed
            }
        } else {
            layer.borderWidth = 2
            backgroundColor = .clear
            layer.borderColor = UIColor.alt2ButtonBoarderDisabled?.cgColor
        }
    }

    func updateAlt2LightTextColor() {
        if isHighlighted {
            setTitleColor(.alt2PressedButtonTextColor, for: .normal)
        } else if isEnabled {
            setTitleColor(.alt2DefaultButtonTextColor, for: .normal)
        } else {
            setTitleColor(.alt2ButtonTextDisabled, for: .normal)
        }
    }

    // MARK: - Icon
    func updateIconButtonStyle() {
        contentEdgeInsets = UIEdgeInsets.zero
    }

    // MARK: - Choose
    func updateChooseButtonStyle() {
        if isChosen {
            backgroundColor = .clear
            layer.borderWidth = 2
            layer.borderColor = UIColor.selectedButtonBorder?.cgColor
        } else {
            backgroundColor = .clear
            layer.borderWidth = 1
            layer.borderColor = UIColor.unselectedButtonBorder?.cgColor
        }
    }

    func updateChooseButtonTextColorStyle() {
        if isChosen {
            setTitleColor(.selectedColoredButtonText, for: .normal)
            titleLabel?.font = UIFont.vodafoneBold(18)
        } else {
            setTitleColor(.unselectedColoredButtonText, for: .normal)
            titleLabel?.font = UIFont.vodafoneRegular(18)
        }
    }
}
