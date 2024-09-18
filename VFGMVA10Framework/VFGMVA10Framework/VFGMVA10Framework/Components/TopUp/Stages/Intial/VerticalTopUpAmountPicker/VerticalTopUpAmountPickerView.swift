//
//  VerticalTopUpAmountPickerView.swift
//  VFGMVA10Framework
//
//  Created by Burak Çokyıldırım on 31.08.2023.
//  Copyright © 2023 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

class VerticalTopUpAmountPickerView: UIView, TopUpAmountPickerViewProtocol {
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var pickerViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var pickerViewCenterXConstraint: NSLayoutConstraint!
    @IBOutlet weak var currencyLabel: VFGLabel!
    @IBOutlet weak var leftCurrencyLabel: VFGLabel!
    @IBOutlet var currencyLabelLeadingConstraints: [NSLayoutConstraint]!

    var selectedAmount: Double {
        delegate?.model?.amounts?[safe: selectedRow] ?? 0
    }
    private weak var delegate: TopUpAmountPickerViewDelegate?
    private var selectedRow = 0
    private var hasOffer = false
    private let iconWidth: CGFloat = 34
    private let rowHeight: CGFloat = 54
    private let labelFontSize: CGFloat = 50
    private let numberOfComponents = 1
    private let cellCurrencyMargin: CGFloat = 78
    private let pickerViewCenterXConstant: CGFloat = 20

    override func awakeFromNib() {
        super.awakeFromNib()
        pickerView.delegate = self
        pickerView.dataSource = self

        if #available(iOS 14.0, *) {
            // Fix cropped text caused by new default margins
            let margins = Constants.TopUp.os14DefaultMargins
            self.currencyLabelLeadingConstraints.forEach { $0.constant -= margins }
        }
    }

    func configure(
        with delegate: TopUpAmountPickerViewDelegate?,
        hasOffer: Bool,
        completion: (() -> Void)?
    ) {
        self.delegate = delegate
        self.hasOffer = hasOffer
        guard let topupModel = delegate?.model else {
            completion?()
            return
        }
        currencyLabel.text = topupModel.currency
        currencyLabel.textColor = UIColor.VFGOceanText
        leftCurrencyLabel.text = topupModel.currency
        leftCurrencyLabel.textColor = UIColor.VFGOceanText

        pickerView.reloadInputViews()

        let minOfferAmount = topupModel.minOfferAmount ?? 0.0
        let offerAmount = topupModel.amounts?.lastIndex(of: minOfferAmount) ?? 0
        let noOfferAmount = ((topupModel.amounts?.count ?? 1) - 1) / 2
        let selectedRow = hasOffer ? offerAmount : noOfferAmount
        var initialSelectedRow: Int?
        if let initialSelectedAmount = topupModel.initialSelectedAmount,
            let amounts = topupModel.amounts {
            initialSelectedRow = amounts.firstIndex(of: initialSelectedAmount)
        }

        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.selectRow(initialSelectedRow ?? selectedRow)

            if #available(iOS 14.0, *) {
                self.pickerView.subviews.last?.backgroundColor = .clear
            }

            if let amounts = topupModel.amounts, !amounts.isEmpty {
                self.delegate?.didChangedPickerValue(
                    selectedAmount: Double(amounts[safe: self.selectedRow] ?? 0))
            }

            completion?()
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            guard let view: VerticalPickerCellView = self.pickerView.view(
                forRow: self.selectedRow,
                forComponent: 0
            ) as? VerticalPickerCellView else { return }
            view.label.textColor = UIColor.VFGOceanText
        }

        calculatePickerWidth()
        setAccessibilityForVoiceOver()
    }

    func selectRow(_ index: Int) {
        DispatchQueue.main.async { [weak self] in
            self?.pickerView.selectRow(index, inComponent: 0, animated: true)
        }
        selectedRow = index
    }

    func reload() {
        pickerView.reloadAllComponents()
    }

    private func setAccessibilityForVoiceOver() {
        currencyLabel.accessibilityLabel = currencyLabel.text ?? ""
        leftCurrencyLabel.accessibilityLabel = leftCurrencyLabel.text ?? ""
    }

    private func calculatePickerWidth() {
        guard let lastAmount = delegate?.model?.amounts?.last else { return }
        let isAmountInteger = lastAmount == floor(lastAmount)
        let lastRowText = isAmountInteger ? "\(Int(lastAmount))" : "\(lastAmount)"
        let labelSize = calculateAmountLabelSize(with: lastRowText)
        pickerViewWidthConstraint.constant = labelSize.width + cellCurrencyMargin
    }

    private func calculateAmountLabelSize(with text: String) -> CGSize {
        let font = UIFont.vodafoneBold(labelFontSize)
        let fontAttributes = [NSAttributedString.Key.font: font]
        return (text as NSString).size(withAttributes: fontAttributes)
    }
}

extension VerticalTopUpAmountPickerView: UIPickerViewDataSource, UIPickerViewDelegate {
    func pickerView(
        _ pickerView: UIPickerView,
        rowHeightForComponent component: Int
    ) -> CGFloat {
        return rowHeight
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        // removing separators from pickerView
        pickerView.subviews.forEach {
            $0.isHidden = $0.frame.height <= 1.0
        }

        return numberOfComponents
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedRow = row
        guard let view: VerticalPickerCellView = pickerView.view(
            forRow: row,
            forComponent: component
        ) as? VerticalPickerCellView else { return }
        view.label.textColor = UIColor.VFGOceanText
        guard let amounts = delegate?.model?.amounts else {
            return
        }
        delegate?.didChangedPickerValue(selectedAmount: amounts[safe: row] ?? 0)
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        delegate?.model?.amounts?.count ?? 0
    }

    func pickerView(
        _ pickerView: UIPickerView,
        viewForRow row: Int,
        forComponent component: Int,
        reusing view: UIView?
    ) -> UIView {
        guard let rowView: VerticalPickerCellView = UIView.loadXib(
            bundle: Bundle.mva10Framework)
        else {
            return UIView()
        }
        guard let amounts = delegate?.model?.amounts else {
            return UIView()
        }
        rowView.giftImageView.image = VFGImage(named: delegate?.iconImageName)
        rowView.rightGiftImageView.image = VFGImage(named: delegate?.iconImageName)
        if delegate?.model?.isIconRTL ?? false {
            rowView.giftImageView.isHidden = true
            rowView.rightGiftImageView.isHidden = false
            currencyLabel.isHidden = true
            leftCurrencyLabel.isHidden = false
            rowView.leftGiftImageWidthConstraint.constant = 0
            pickerViewCenterXConstraint.constant = pickerViewCenterXConstant
            rowView.rightGiftImageWidthConstraint.constant = iconWidth
            rowView.giftImageViewLeadingConstraint.constant = 0
            if let model = delegate?.model,
                let specificGiftedAmounts = model.specificGiftedAmounts {
                rowView.rightGiftImageView.isHidden = !specificGiftedAmounts.contains(amounts[row])
            } else {
                rowView.rightGiftImageView.isHidden =
                (!hasOffer || amounts[row] < delegate?.model?.minOfferAmount ?? 0.0)
            }
        } else {
            rowView.giftImageView.isHidden = false
            rowView.rightGiftImageView.isHidden = true
            currencyLabel.isHidden = false
            leftCurrencyLabel.isHidden = true
            rowView.leftGiftImageWidthConstraint.constant = iconWidth
            rowView.rightGiftImageWidthConstraint.constant = 0
            pickerViewCenterXConstraint.constant = UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft
            ? pickerViewCenterXConstant : -pickerViewCenterXConstant
            if let model = delegate?.model,
                let specificGiftedAmounts = model.specificGiftedAmounts {
                rowView.giftImageView.isHidden = !specificGiftedAmounts.contains(amounts[row])
            } else {
                rowView.giftImageView.isHidden =
                (!hasOffer || amounts[row] < delegate?.model?.minOfferAmount ?? 0.0)
            }
        }
        let isAmountInteger = amounts[row] == floor(amounts[row])
        rowView.label.text = isAmountInteger ?
        "\(String(describing: Int(amounts[row])))" : "\(String(describing: amounts[row]))"
        rowView.label.font = .vodafoneBold(labelFontSize)
        if row == amounts.count - 1 {
            guard let myText = rowView.label.text else { return rowView }
            let labelSize = calculateAmountLabelSize(with: myText)
            pickerViewWidthConstraint.constant = labelSize.width + cellCurrencyMargin
        }
        rowView.label.textColor = UIColor.VFGOceanText
        rowView.isAccessibilityElement = true
        pickerView.accessibilityIdentifier = "TPamountSum"
        rowView.giftImageView.accessibilityIdentifier = "TPmainGiftIcon"
        return rowView
    }
}

extension VerticalTopUpAmountPickerView: UIPickerViewAccessibilityDelegate {
    func pickerView(_ pickerView: UIPickerView, accessibilityHintForComponent component: Int) -> String? {
        "top_up_quick_action_picker_accessibility_hint".localized()
    }
}
