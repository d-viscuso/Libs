//
//  VFGChevronCell.swift
//  VFGMVA10Framework
//
//  Created by Hamsa Hassan on 1/19/21.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import VFGMVA10Foundation
/// Chevron cell position types
public enum VFGChevronCellPosition: Equatable {
    case firstCard
    case middleCard
    case lastCard
}
/// Chevron cell types
public enum VFGChevronCellType: Equatable {
    case multiCard(position: VFGChevronCellPosition)
    case multiSeparateCard
    case oneCard
}
/// Chevron card table view cell
class VFGChevronCell: UITableViewCell {
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var titleLabel: VFGLabel!
    @IBOutlet weak var subTitleLabel: VFGLabel!
    @IBOutlet weak var iconImageView: VFGImageView!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var cardViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var cardViewTopConstraints: NSLayoutConstraint!
    /// Chevron cell type
    var type: VFGChevronCellType = .oneCard

    override func awakeFromNib() {
        super.awakeFromNib()
        addShadowToCard()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        configureCornerRadius()
        configureCardViewConstraints()
        configureSeparator()
    }
    /// *VFGChevronCell* configuration
    /// - Parameters:
    ///    - title: Chevron cell title
    ///    - subtitle:Chevron cell subtitle
    ///    - iconImageName: Chevron cell image icon
    ///    - type: Chevron cell type
    func configure(
        title: String,
        titleFont: UIFont = .vodafoneRegular(18),
        subtitle: String? = nil,
        iconImageName: String,
        type: VFGChevronCellType = .oneCard
    ) {
        self.type = type
        titleLabel.text = title
        titleLabel.font = titleFont
        subTitleLabel.text = subtitle
        iconImageView.image = VFGImage(named: iconImageName)

        subTitleLabel.isHidden = subtitle == nil ? true : false
        configureCardViewConstraints()
        setAccessibilityForVoiceOver()
    }
    // MARK: Private Methods
    private func addShadowToCard() {
        cardView.layer.cornerRadius = 4
        cardView.addingShadow(size: CGSize(width: 0, height: 1), radius: 4, opacity: 0.16)
    }

    private func configureCardViewConstraints() {
        switch type {
        case .multiCard(let position) where position == .firstCard:
            cardViewBottomConstraint.constant = 0
        case .multiCard(let position) where position == .lastCard:
            cardViewTopConstraints.constant = 0
            cardViewBottomConstraint.constant = 6
        case .multiCard(let position) where position == .middleCard:
            cardViewTopConstraints.constant = 0
            cardViewBottomConstraint.constant = 0
        case .multiSeparateCard:
            cardViewTopConstraints.constant = 6
            cardViewBottomConstraint.constant = 6
        default:
            cardViewTopConstraints.constant = 16
            cardViewBottomConstraint.constant = 6
        }
    }

    private func configureSeparator() {
        switch type {
        case .multiCard(let position) where position == .lastCard || position == .middleCard:
            separatorView.isHidden = false
        default:
            separatorView.isHidden = true
        }
    }

    private func configureCornerRadius() {
        var cornersToRound = CACornerMask()
        switch type {
        case .multiCard(let position) where position == .firstCard:
            cornersToRound.insert(.layerMinXMinYCorner)
            cornersToRound.insert(.layerMaxXMinYCorner)

        case .multiCard(let position) where position == .lastCard:
            cornersToRound.insert(.layerMinXMaxYCorner)
            cornersToRound.insert(.layerMaxXMaxYCorner)

        default:
            cornersToRound.insert(.layerMinXMinYCorner)
            cornersToRound.insert(.layerMaxXMinYCorner)
            cornersToRound.insert(.layerMinXMaxYCorner)
            cornersToRound.insert(.layerMaxXMaxYCorner)
        }

        cardView.layer.maskedCorners = cornersToRound
        cardView.layer.cornerRadius = self.type == .multiCard(position: .middleCard) ? 0 : 6
    }
}

extension VFGChevronCell {
    /// set accessibility for voice over
    func setAccessibilityForVoiceOver() {
        titleLabel.accessibilityLabel = titleLabel.text
        subTitleLabel.accessibilityLabel = subTitleLabel.text
    }
}
