//
//  VFGAddressView.swift
//  Airship
//
//  Created by Yahya Saddiq on 2/15/21.
//

import VFGMVA10Foundation

@IBDesignable
class VFGAddressView: UIView {
    @IBOutlet weak var iconImageView: VFGImageView!
    @IBOutlet weak var nameLabel: VFGLabel!
    @IBOutlet weak var addressLabel: VFGLabel!
    @IBOutlet weak var emailLabel: VFGLabel!
    @IBOutlet weak var phoneNumberLabel: VFGLabel!
    @IBOutlet weak var iconLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var iconTrailingConstraint: NSLayoutConstraint!

    @IBInspectable var iconLeadingConstant: CGFloat {
        get {
            return iconLeadingConstraint.constant
        }
        set {
            iconLeadingConstraint.constant = newValue
        }
    }

    @IBInspectable var iconTrailingConstant: CGFloat {
        get {
            return iconTrailingConstraint.constant
        }
        set {
            iconTrailingConstraint.constant = newValue
        }
    }

    init() {
        super.init(frame: CGRect.zero)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        commonInit()
    }

    private func commonInit() {
        guard let contentView = self.loadViewFromNib(nibName: className, in: .mva10Framework) else {
            return
        }

        xibSetup(contentView: contentView)
        configureUI()
    }

    func configureUI() {
        layer.borderWidth = 1
        layer.borderColor = UIColor.VFGGreyDividerOne.cgColor
        configureShadow()
    }

    private func hideEmptyLabels(_ store: VFGAppointmentStoreModel.Store) {
        nameLabel.isHidden = store.name.isEmpty
        addressLabel.isHidden = store.address.isEmpty
        emailLabel.isHidden = store.email.isEmpty
        phoneNumberLabel.isHidden = store.phoneNumber.isEmpty
    }

    func setup(with store: VFGAppointmentStoreModel.Store) {
        nameLabel.text = store.name
        addressLabel.text = store.address
        emailLabel.text = store.email
        phoneNumberLabel.text = store.phoneNumber

        hideEmptyLabels(store)
    }
}
