//
//  ProductSwitcherCollectionCell.swift
//  VFGMVA10Framework
//
//  Created by Tuncel, Pelin, Vodafone on 8/10/22.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

class ProductSwitcherCollectionCell: UICollectionViewCell {
    // MARK: - Header Views
    @IBOutlet weak var buttonsStackView: UIStackView!
    @IBOutlet weak var productImageView: VFGImageView!
    @IBOutlet weak var starredButton: VFGButton!
    @IBOutlet weak var editButton: VFGButton!
    @IBOutlet weak var nameLabel: VFGLabel!
    @IBOutlet weak var titleLabel: VFGLabel!
    @IBOutlet weak var descLabel: VFGLabel!
    @IBOutlet weak var statusStackView: UIStackView?
    @IBOutlet weak var contentStackHeight: NSLayoutConstraint!

    // MARK: - Content Views
    @IBOutlet weak var contentsStackView: UIStackView!

    // MARK: - Status Views
    @IBOutlet weak var statusDotHolderView: UIView!
    @IBOutlet weak var statusDotView: UIView!
    @IBOutlet weak var statusLabel: VFGLabel!

    // MARK: - Footer Views
    @IBOutlet weak var firstCTAButton: VFGButton!
    @IBOutlet weak var secondCTAButton: VFGButton!

    // MARK: - Static Properties
    static let progressBarMargin: CGFloat = 32

    // MARK: - Private Properties
    private var editAction: () -> Void = {}
    private var starredAction: () -> Void = {}
    private var firstCTAButtonAction: () -> Void = {}
    private var secondCTAButtonAction: () -> Void = {}
    private var cellWidth: CGFloat = 0

    // MARK: - Setup UI
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    private func setupUI() {
        setupCell()
        setupStatusUI()
        setupFooterUI()
    }

    private func setupCell() {
        configureShadow(radius: 6.0)
        starredButton.setImage(
            UIImage( named: "emptyStar", in: .mva10Framework), for: .normal)
        starredButton.setImage(
            UIImage(named: "filledStar", in: .mva10Framework), for: .selected)
        starredButton.tintColor = .clear
        self.layer.masksToBounds = false
    }

    private func setupStatusUI() {
        statusDotView.layer.masksToBounds = true
        statusDotView.layer.cornerRadius = 4
    }

    private func setupFooterUI() {
        firstCTAButton.setTitleColor(.VFGPrimaryText, for: .normal)
        firstCTAButton.titleLabel?.font = .vodafoneRegular(14)
        firstCTAButton.layer.borderColor = UIColor.VFGPrimaryText.cgColor
        firstCTAButton.layer.borderWidth = 2
        firstCTAButton.layer.cornerRadius = 6
        firstCTAButton.layer.masksToBounds = true

        secondCTAButton.setTitleColor(.white, for: .normal)
        secondCTAButton.titleLabel?.font = .vodafoneRegular(14)
        secondCTAButton.backgroundColor = .VFGRedBackground
        secondCTAButton.layer.borderColor = UIColor.clear.cgColor
        secondCTAButton.layer.borderWidth = 2
        secondCTAButton.layer.cornerRadius = 6
        secondCTAButton.layer.masksToBounds = true
    }

    // MARK: - Configure UI
    func setCardItem(
        itemModel: ProductSwitcherCardItemModel,
        for cellWidth: CGFloat,
        isEditNameEnabled: Bool,
        isStarredEnabled: Bool
    ) {
        self.cellWidth = cellWidth
        configureHeaderView(
            itemModel,
            isEditNameEnabled: isEditNameEnabled,
            isStarredEnabled: isStarredEnabled,
            isStarred: itemModel.isStarred)
        configureContentView(itemModel)
        configureStatusView(itemModel)
        configureFooterView(itemModel)
    }

    private func configureHeaderView(_ itemModel: ProductSwitcherCardItemModel, isEditNameEnabled: Bool, isStarredEnabled: Bool, isStarred: Bool) {
        if let imageURL = URL(string: itemModel.contentModel.image) {
            productImageView.download(from: imageURL)
        }

        nameLabel.text = itemModel.contentModel.name
        titleLabel.text = itemModel.contentModel.title
        descLabel.attributedText = itemModel.subtitle
        editButton.isUserInteractionEnabled = isEditNameEnabled
        editButton.isHidden = !isEditNameEnabled
        editAction = itemModel.editAction
        starredButton.isUserInteractionEnabled = isStarredEnabled
        starredButton.isHidden = !isStarredEnabled
        starredButton.isSelected = isStarred
        starredAction = itemModel.starredAction
    }

    private func configureContentView(_ itemModel: ProductSwitcherCardItemModel) {
        contentsStackView.removeAllArrangedSubviews()
        switch itemModel.type {
        case .usage:
            if itemModel.contentModel.items.count == 3 {
                updateContentForCompact(items: itemModel.contentItems)
            } else {
                updateContentForDetailed(items: itemModel.contentItems)
            }
        case .service:
            guard let contentView: ProductSwitcherServiceContentView = UIView.loadXib(bundle: .mva10Framework)
            else { return }
            contentView.setItemModel(itemModel)
            contentsStackView.addArrangedSubview(contentView)
        case .credit:
            contentStackHeight.constant = 18
            updateMultipleConfiguration(items: itemModel.contentItems)
        }
    }
    /// updateMultipleConfiguration
    private func updateMultipleConfiguration(items: [ProductSwitcherContentItem]) {
        for item in items {
            switch item.type {
            case .credit:
                let creditView = ProductSwitcherCreditView(frame: .zero)
                let itemCount = CGFloat(items.count)
                let usageViewWidth = (cellWidth / itemCount)
                let width = usageViewWidth - ProductSwitcherCollectionCell.progressBarMargin
                creditView.frame.size.width = usageViewWidth
                creditView.setContentItem(item, for: width)
                contentsStackView.addArrangedSubview(creditView)
            default:
                break
            }
        }
    }

    private func updateContentForCompact(items: [ProductSwitcherContentItem]) {
        for item in items {
            guard let usageView: ProductSwitcherCompactUsageView = UIView.loadXib(bundle: .mva10Framework)
            else { return }
            let itemCount = CGFloat(items.count)
            let usageViewWidth = (cellWidth / itemCount)
            let width = usageViewWidth - ProductSwitcherCollectionCell.progressBarMargin
            usageView.frame.size.width = usageViewWidth
            usageView.setContentItem(item, for: width)
            contentsStackView.addArrangedSubview(usageView)
        }
    }

    private func updateContentForDetailed(items: [ProductSwitcherContentItem]) {
        for item in items {
            guard let usageView: ProductSwitcherDetailedUsageView = UIView.loadXib(bundle: .mva10Framework)
            else { return }
            let itemCount = CGFloat(items.count)
            let usageViewWidth = (cellWidth / itemCount)
            let width = usageViewWidth - ProductSwitcherCollectionCell.progressBarMargin
            usageView.frame.size.width = usageViewWidth
            usageView.setContentItem(item, for: width)
            contentsStackView.addArrangedSubview(usageView)
        }
    }

    private func configureStatusView(_ itemModel: ProductSwitcherCardItemModel) {
        if let color = itemModel.contentModel.statusColor,
        let statusColor = UIColor(hexString: color) {
            statusDotHolderView.isHidden = false
            statusDotView.backgroundColor = statusColor
        } else {
            statusDotHolderView.isHidden = true
        }
        statusLabel.text = itemModel.contentModel.statusText
    }

    private func configureFooterView(_ itemModel: ProductSwitcherCardItemModel) {
        let firstCTAModel = itemModel.contentModel.firstCTAButton
        updateButtonAppearance(firstCTAButton, with: firstCTAModel)
        firstCTAButton.setTitle(firstCTAModel.text, for: .normal)
        firstCTAButtonAction = itemModel.firstCTAAction

        guard let secondCTAModel = itemModel.contentModel.secondCTAButton,
            let secondCTAAction = itemModel.secondCTAAction
        else {
            secondCTAButton.isHidden = true
            return
        }
        updateButtonAppearance(secondCTAButton, with: secondCTAModel)
        secondCTAButton.isHidden = false
        secondCTAButton.setTitle(secondCTAModel.text, for: .normal)
        secondCTAButtonAction = secondCTAAction
    }

    private func updateButtonAppearance(_ button: VFGButton, with ctaModel: ProductSwitcherCTAButtonModel) {
        if let color = ctaModel.textColor,
        let textColor = UIColor(hexString: color) {
            button.setTitleColor(textColor, for: .normal)
        }
        if let color = ctaModel.backgroundColor,
        let backgroundColor = UIColor(hexString: color) {
            button.backgroundColor = backgroundColor
        }
        if let color = ctaModel.borderColor,
        let borderColor = UIColor(hexString: color)?.cgColor {
            button.layer.borderColor = borderColor
        }
    }

    // MARK: - User Actions
    @IBAction func editButtonClicked(_ sender: UIButton) {
        editAction()
    }

    @IBAction func starredButtonClicked(_ sender: UIButton) {
        sender.isSelected.toggle()
        starredAction()
    }

    @IBAction func firstCTAButtonClicked(_ sender: UIButton) {
        firstCTAButtonAction()
    }

    @IBAction func secondCTAButtonClicked(_ sender: UIButton) {
        secondCTAButtonAction()
    }
}
