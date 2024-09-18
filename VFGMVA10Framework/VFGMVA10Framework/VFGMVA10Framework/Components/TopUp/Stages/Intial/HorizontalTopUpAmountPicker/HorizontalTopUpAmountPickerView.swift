//
//  HorizontalTopUpAmountPickerView.swift
//  VFGMVA10Framework
//
//  Created by Burak Çokyıldırım on 3.09.2023.
//  Copyright © 2023 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

class HorizontalTopUpAmountPickerView: UIView, TopUpAmountPickerViewProtocol {
    @IBOutlet weak var pickerView: UIPickerView!

    var selectedAmount: Double {
        delegate?.model?.amounts?[safe: selectedRow] ?? 0
    }

    private weak var delegate: TopUpAmountPickerViewDelegate?
    private var selectedRow = 0
    private var hasOffer = false
    private let rotationAngle: CGFloat = -90 * (.pi / 180)

    override func awakeFromNib() {
        super.awakeFromNib()
        clipsToBounds = true
        pickerView.delegate = self
        pickerView.dataSource = self

        configureFadeEffect()
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

        pickerView.transform = CGAffineTransform(rotationAngle: rotationAngle)
        pickerView.frame = CGRect(
            x: frame.origin.x - frame.width / 2,
            y: frame.origin.y,
            width: frame.width * 2,
            height: frame.height)

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
        selectRow(initialSelectedRow ?? selectedRow)

        if let amounts = topupModel.amounts, !amounts.isEmpty {
            self.delegate?.didChangedPickerValue(
                selectedAmount: Double(amounts[safe: self.selectedRow] ?? 0))
        }

        completion?()

        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            if #available(iOS 14.0, *) {
                self.pickerView.subviews.last?.backgroundColor = .clear
            }
        }
    }

    func selectRow(_ index: Int) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.pickerView.selectRow(index, inComponent: 0, animated: true)
        }
        selectedRow = index
    }

    func reload() {
        pickerView.reloadAllComponents()
    }

    private func configureFadeEffect() {
        let colors: [UIColor] = [.clear, .black, .black, .clear]
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.locations = [0, 0.08, 0.92, 1]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)

        layer.mask = gradientLayer
    }
}

extension HorizontalTopUpAmountPickerView: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
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
        guard let rowView: HorizontalPickerCellView = UIView.loadXib(
            bundle: Bundle.mva10Framework),
            let topupModel = delegate?.model,
            let amount = topupModel.amounts?[safe: row],
            let isIconRTL = topupModel.isIconRTL
        else { return UIView() }

        rowView.transform = CGAffineTransform(rotationAngle: -rotationAngle)

        let isAmountInteger = amount == floor(amount)
        let amountString = isAmountInteger ? "\(Int(amount))" : "\(amount)"
        let currencyPosition: AmountPickerCellViewModel.CurrencyPositon = isIconRTL ? .left : .right

        var hasGift = false
        if let specificGiftedAmounts = topupModel.specificGiftedAmounts {
            hasGift = specificGiftedAmounts.contains(amount)
        } else {
            hasGift = hasOffer && amount >= topupModel.minOfferAmount ?? 0.0
        }

        let model = AmountPickerCellViewModel(
            currencyText: topupModel.currency ?? "",
            currencyPosition: currencyPosition,
            amountText: amountString,
            hasGift: hasGift,
            giftIconImageName: delegate?.iconImageName ?? ""
        )
        rowView.configure(with: model)

        rowView.isAccessibilityElement = true
        pickerView.accessibilityIdentifier = "TPamountSum"
        return rowView
    }

    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        100
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedRow = row
        guard let amounts = delegate?.model?.amounts else {
            return
        }
        delegate?.didChangedPickerValue(selectedAmount: amounts[safe: row] ?? 0)
    }
}

extension HorizontalTopUpAmountPickerView: UIPickerViewAccessibilityDelegate {
    func pickerView(_ pickerView: UIPickerView, accessibilityHintForComponent component: Int) -> String? {
        "top_up_quick_action_picker_accessibility_hint".localized()
    }
}
