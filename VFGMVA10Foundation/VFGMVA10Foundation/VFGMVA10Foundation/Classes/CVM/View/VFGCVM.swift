//
//  VFGCVM.swift
//  VFGMVA10Foundation
//
//  Created by Ahmed AbdElnabi on 29/08/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import UIKit

/// CVM which appear as view which contains icon, title, description, X button, action button that use on auto bills.
open class VFGCVM: UIView {
    // MARK: - properties
    @IBOutlet weak var cvmBannerView: UIView!
    @IBOutlet weak var cvmBackgroundView: UIView!
    @IBOutlet weak var cvmBannerIcon: VFGImageView!
    @IBOutlet weak var titleLabel: VFGLabel!
    @IBOutlet weak var closeButton: VFGButton!
    @IBOutlet weak var descriptionLabel: VFGLabel!
    @IBOutlet weak var setupButton: VFGButton!
    @IBOutlet weak var editButton: VFGButton!
    @IBOutlet weak var toggleButton: VFGButton!
    @IBOutlet weak var autoTopUpActiveCircle: VFGImageView!

    /// A delegate that is called when clicking on CVM's buttons
    weak var delegate: VFGCVMProtocol?
    /// A boolean that is presented  the status of the toggle
    var isToggleButtonEnabled = true
    /// A title for CVM when it's status is active
    var title: String?
    /// A title for CVM when it's status is disable
    var titleWhenDisabled: String?

    public override func awakeFromNib() {
        super.awakeFromNib()
        cvmBackgroundView.roundCorners()
        configureShadow()
    }

    // MARK: - initializers
    /// configure CVM views content and actions
    /// - Parameters:
    ///   - viewModel: Model that contain the content for view's and the delegate for the actions
    ///   - isActive: Boolean that present the status for CVM
    public func configure(with viewModel: VFGCVMViewModel, isActive: Bool = false) {
        cvmBannerIcon.enableDynamicDirection = false
        title = viewModel.title
        titleWhenDisabled = viewModel.titleWhenDisabled
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
        self.delegate = viewModel.delegate
        self.setupCVMView(isActive: isActive, buttonTitle: viewModel.buttonTitle)
    }

    /// setup CVMView views visibility
    /// - Parameters:
    ///   - isActive: Boolean that present the status for CVM (active-disable)
    ///   - buttonTitle: A text for edit button .

    func setupCVMView(isActive: Bool = false, buttonTitle: String) {
        setupButton.setTitle(buttonTitle, for: .normal)
        editButton.isHidden = !isActive
        toggleButton.isHidden = !isActive
        autoTopUpActiveCircle.isHidden = !isActive
        setupButton.isHidden = isActive
        closeButton.isHidden = isActive
        cvmBannerIcon.isHidden = isActive
        if isActive {
            editButton.setTitle(buttonTitle, for: .normal)
            titleLabel.textColor = .VFGPrimaryText
            descriptionLabel.textColor = .VFGPrimaryText
        } else {
            setupGradientBackground()
        }
    }

    func setupGradientBackground() {
        cvmBackgroundView.setGradientBackgroundColor(
            colors: UIColor.VFGCVMBlueGradient,
            startPoint: CGPoint(x: 1, y: 0),
            endPoint: CGPoint(x: 0, y: 0)
        )
    }
    /// Action that called when toggle is pressed 
    func toggleDidPress() {
        isToggleButtonEnabled.toggle()
        if isToggleButtonEnabled {
            titleLabel.text = title
            autoTopUpActiveCircle.image = VFGFoundationAsset.Image.greenCircle
            toggleButton.setImage(VFGFoundationAsset.Image.toggleSmallActive, for: .normal)
        } else {
            titleLabel.text = titleWhenDisabled
            autoTopUpActiveCircle.image = VFGFoundationAsset.Image.redCircle
            toggleButton.setImage(VFGFoundationAsset.Image.toggleSmallInactive, for: .normal)
        }
        descriptionLabel.isEnabled = isToggleButtonEnabled
    }

    // MARK: - actions
    @IBAction func closeDidPress(_ sender: VFGButton) {
        delegate?.closeButtonDidPress()
    }

    @IBAction func setupDidPress(_ sender: VFGButton) {
        delegate?.setupButtonDidPress()
    }

    @IBAction func editDidPress(_ sender: VFGButton) {
        delegate?.editButtonDidPress()
    }

    @IBAction func toggleDidPress(_ sender: VFGButton) {
        self.toggleDidPress()
        delegate?.toggleButtonDidPress(isToggleEnabled: isToggleButtonEnabled)
    }
}
