//
//  VFGMVA12HeaderView.swift
//  VFGMVA10Framework
//
//  Created by Ihsan Kahramanoglu on 7.06.2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import Foundation
import UIKit
import VFGMVA10Foundation

class VFGMVA12HeaderView: UIView {
    @IBOutlet weak var menuItemsStackView: UIStackView!

    @IBOutlet weak var avatarHolderView: UIView!
    @IBOutlet weak var avatarImageView: VFGImageView!
    @IBOutlet weak var backgroundHeaderImageView: VFGImageView!

    @IBOutlet weak var avatarLabel: VFGLabel!
    @IBOutlet weak var avatarActionButton: VFGButton!

    @IBOutlet weak var welcomeMessageLabel: VFGLabel!

    @IBOutlet weak var accountActionHolderView: UIView!
    @IBOutlet weak var accountActionLabel: VFGLabel!
    @IBOutlet weak var accountActionButton: VFGButton!
    @IBOutlet weak var containerTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var menuIttemsStackViewHeight: NSLayoutConstraint!

    var headerViewModel: VFGMVA12HeaderViewModelProtocol?
    lazy var gradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.type = .radial
        gradient.colors = [
            UIColor.white.cgColor,
            UIColor.gray.cgColor
        ]
        gradient.startPoint = CGPoint(x: 0.5, y: 0.5)
        gradient.endPoint = CGPoint(x: 0.1, y: 1)
        return gradient
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        setupAvatar()
        avatarActionButton.setTitle("", for: .normal)
        accountActionButton.setTitle("", for: .normal)
    }

    private func setupAvatar() {
        let radius = (avatarHolderView.frame.size.width / 2)
        avatarHolderView.layer.masksToBounds = true
        avatarHolderView.layer.cornerRadius = radius
        avatarImageView.layer.masksToBounds = true
        avatarImageView.layer.cornerRadius = radius
    }

    func setHeaderViewModel(_ viewModel: VFGMVA12HeaderViewModelProtocol) {
        headerViewModel = viewModel
        welcomeMessageLabel.text = headerViewModel?.welcomeMessage
        setMenuItems()
        setAvatar()
        setAccountAction()
        setHeaderBackgroundImage()
        setHeaderBackgroundGradientColor()
    }

    private func setMenuItems() {
        guard let menuItems = headerViewModel?.menuItems, !menuItems.isEmpty else {
            menuIttemsStackViewHeight.constant = 0.0
            return
        }

        menuItemsStackView.removeAllArrangedSubviews()

        // Reverse menuItems so that they are displayed in the correct order
        let reverseMenuItems = menuItems.reversed()
        for menuItem in reverseMenuItems {
            guard let menuItemView: VFGMVA12HeaderMenuItemView = UIView.loadXib(bundle: .mva10Framework)
            else { continue }
            menuItemView.translatesAutoresizingMaskIntoConstraints = false
            menuItemView.heightAnchor.constraint(equalToConstant: 40).isActive = true
            menuItemView.widthAnchor.constraint(equalToConstant: 40).isActive = true
            menuItemView.setMenuItem(menuItem)
            menuItemsStackView.addArrangedSubview(menuItemView)
        }
    }

    private func setAvatar() {
        guard let headerViewModel = headerViewModel else { return }

        switch headerViewModel.type {
        case .noAvatar:
            avatarHolderView.isHidden = true
        case .avatarWithImage:
            avatarImageView.image = headerViewModel.avatarImage
            avatarImageView.isHidden = false
            avatarLabel.isHidden = true
            avatarHolderView.isHidden = false
        case .avatarWithUsername:
            avatarLabel.text = headerViewModel.username
            avatarLabel.isHidden = false
            avatarImageView.isHidden = true
            avatarHolderView.isHidden = false
        }
    }

    private func setAccountAction() {
        guard let headerViewModel = headerViewModel else { return }

        accountActionHolderView.isHidden = !headerViewModel.isAccountActionEnabled
        accountActionLabel.text = headerViewModel.accountActionText
    }

    private func setHeaderBackgroundImage() {
        guard let headerViewModel = headerViewModel, let image = headerViewModel.headerBackgroundImage else { return }
        backgroundHeaderImageView.image = image
    }

    private func setHeaderBackgroundGradientColor() {
        guard let headerViewModel = headerViewModel else { return }
        guard headerViewModel.isGradientBackgroundColorEnabled else { return }
        gradient.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: headerViewModel.headerViewHeight)
        self.layer.insertSublayer(gradient, at: 0)
    }

    @IBAction func avatarActionButtonClicked(_ sender: Any) {
        guard let headerViewModel = headerViewModel else { return }
        headerViewModel.avatarAction()
    }

    @IBAction func accountActionButtonClicked(_ sender: Any) {
        guard let headerViewModel = headerViewModel else { return }
        headerViewModel.accountAction()
    }

    func scrollContent(offset: CGFloat) {
        containerTopConstraint.constant = -offset
        containerBottomConstraint.constant = offset
    }
}
