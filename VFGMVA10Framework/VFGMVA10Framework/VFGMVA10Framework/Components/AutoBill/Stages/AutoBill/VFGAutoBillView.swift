//
//  VFGAutoBillView.swift
//  VFGMVA10Framework
//
//  Created by Hussein Kishk on 31/01/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation
/// Auto bill quick action view
class VFGAutoBillView: UIView {
    @IBOutlet weak var paymentMethodsCard: VFGPaymentMethodsCardView!
    @IBOutlet weak var titleLabel: VFGLabel!
    @IBOutlet weak var confirmButton: VFGButton!
    @IBOutlet weak var cancelButton: VFGButton!
    @IBOutlet weak var subtitleLabel: VFGLabel!
    @IBOutlet weak var daysCollectionView: UICollectionView! {
        didSet {
            daysCollectionView.delegate = self
            daysCollectionView.dataSource = self
            daysCollectionView.register(
                UINib(
                    nibName: "AutoBillDaysCollectionViewCell",
                    bundle: .mva10Framework
                ),
                forCellWithReuseIdentifier: "AutoBillDaysCollectionViewCell")
        }
    }
    /// Array list of days for the selected month
    var monthDaysArray: [Int] = []
    /// Shimmer view for *VFGAutoBillView*
    var autoBillShimmerView: VFGAutoBillShimmerView?
    /// An instance of *VFGAutoBillStateInternalProtocol*
    weak var delegate: VFGAutoBillStateInternalProtocol?
    /// Selected day for auto bill payment
    var selectedDay: Int = Calendar.current.component(.day, from: Date())

    override func awakeFromNib() {
        super.awakeFromNib()
        paymentMethodsCard?.collectionViewDelegate = self
        paymentMethodsCard?.paymentCardStateDelegate = self
    }

    fileprivate func scrollToSelectedDay(row: Int, animated: Bool = true) {
        DispatchQueue.main.async { [self] in
            daysCollectionView.scrollToItem(
                at: IndexPath(item: row, section: 0),
                at: .centeredHorizontally,
                animated: animated
            )
            daysCollectionView.setNeedsLayout()
            daysCollectionView.reloadData()
        }
    }
    /// Start shimmer view for *VFGAutoBillView*
    func showShimmer() {
        autoBillShimmerView = VFGAutoBillShimmerView(frame: bounds)
        autoBillShimmerView?.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        guard let autoBillShimmerView = autoBillShimmerView else {
            return
        }
        addSubview(autoBillShimmerView)
    }
    /// Stop shimmer view for *VFGAutoBillView*
    func hideShimmer() {
        autoBillShimmerView?.stopShimmer()
    }
    /// *VFGAutoBillView* configuration
    /// - Parameters:
    ///    - viewModel: *VFGAutoBillView* view model data
    ///    - completion: Optional closure to perform actions after finishing configuration
    func configure(
        viewModel: VFGAutoBillViewModel,
        completion: (() -> Void)? = nil
    ) {
        showShimmer()
        titleLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
        confirmButton.setTitle(viewModel.buttonTitle, for: .normal)
        cancelButton.setTitle(viewModel.cancelTitle, for: .normal)
        loadMonthDaysArray()
        if viewModel.isEditingMode, let selectedDay = viewModel.model?.selectedDay {
            self.selectedDay = selectedDay
        } else {
            selectedDay = Calendar.current.component(.day, from: Date())
        }
        scrollToSelectedDay(
            row: selectedDay - 1,
            animated: false)
        paymentMethodsCard.configure(
            title: viewModel.paymentMethodTitle,
            editText: viewModel.editLabel,
            presenterType: .autoBill)
        if
            let selectedCard = viewModel.model?.defaultPaymentMethod,
            selectedCard.cardNumber != nil {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.paymentMethodsCard.initialSelectedCard = selectedCard
                self.setAccessibilityForVoiceOver()
                completion?()
            }
        } else {
            setAccessibilityForVoiceOver()
            completion?()
        }
    }

    func setAccessibilityForVoiceOver() {
        guard let titleLabel = titleLabel,
            let daysCollectionView = daysCollectionView,
            let subtitleLabel = subtitleLabel,
            let paymentMethodsCard = paymentMethodsCard,
            let confirmButton = confirmButton,
            let cancelButton = cancelButton
        else { return }
        titleLabel.accessibilityLabel = titleLabel.text
        subtitleLabel.accessibilityLabel = subtitleLabel.text
        confirmButton.accessibilityLabel = confirmButton.titleLabel?.text
        cancelButton.accessibilityLabel = cancelButton.titleLabel?.text
        accessibilityElements = [
            titleLabel,
            daysCollectionView,
            subtitleLabel,
            paymentMethodsCard,
            confirmButton,
            cancelButton
        ]
        accessibilityCustomActions = [confirmButtonVoiceOverAction(), cancelButtonVoiceOverAction()]
    }

    // MARK: - Actions
    @IBAction func confirmAction(_ sender: Any) {
        VFGDebugLog("confirm button clicked")
        delegate?.initialAutoBillFinished(
            with: self.paymentMethodsCard.shownPaymentCards.first, selectedDay: self.selectedDay)
    }
    func confirmButtonVoiceOverAction() -> UIAccessibilityCustomAction {
        let actionName = confirmButton.titleLabel?.text ?? ""
        return UIAccessibilityCustomAction(name: actionName, target: self, selector: #selector(confirmAction))
    }

    @IBAction func cancel(_ sender: Any) {
        delegate?.dismiss()
    }
    func cancelButtonVoiceOverAction() -> UIAccessibilityCustomAction {
        let actionName = cancelButton.titleLabel?.text ?? ""
        return UIAccessibilityCustomAction(name: actionName, target: self, selector: #selector(cancel))
    }
    /// List month days in *monthDaysArray*
    func loadMonthDaysArray() {
        for index in 1...31 {
            monthDaysArray.append(index)
        }
    }
}

extension VFGAutoBillView: VFGPaymentMethodsCardViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didHeightChanged height: CGFloat) {
        layoutIfNeeded()
    }
}

extension VFGAutoBillView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Constants.AutoBill.daysCellsCount
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "AutoBillDaysCollectionViewCell",
                for: indexPath) as? AutoBillDaysCollectionViewCell else { return UICollectionViewCell() }
        let itemToShow = monthDaysArray[indexPath.row % monthDaysArray.count]

        cell.dayLabel.text = "\(itemToShow)"
        cell.dayLabel.accessibilityIdentifier = "ABdayLabel\(itemToShow)"
        cell.dayLabel.accessibilityLabel = "\(itemToShow)"
        if itemToShow == selectedDay {
            cell.dayLabel.accessibilityHint = "Currently selected day"
        } else {
            cell.dayLabel.accessibilityHint = ""
        }
        if indexPath.item > itemToShow {
            cell.dayLabel.isAccessibilityElement = false
        } else {
            cell.dayLabel.isAccessibilityElement = true
        }
        selectCell(monthDaysArray[indexPath.row % self.monthDaysArray.count], cell)
        return cell
    }

    fileprivate func selectCell(_ index: Int, _ cell: AutoBillDaysCollectionViewCell) {
        if index == selectedDay {
            cell.containerView.backgroundColor = .VFGFilterSelectedBg
            cell.dayLabel.textColor = .VFGFilterSelectedText
        } else {
            cell.containerView.backgroundColor = .VFGFilterUnselectedBgTwo
            cell.dayLabel.textColor = .VFGFilterUnselectedText
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedDay = monthDaysArray[indexPath.row % self.monthDaysArray.count]
        if let cell = collectionView.cellForItem(at: IndexPath( item: selectedDay, section: 0))
            as? AutoBillDaysCollectionViewCell {
                selectCell(monthDaysArray[selectedDay % self.monthDaysArray.count], cell)
            }
        scrollToSelectedDay(row: indexPath.row)
    }
}

extension VFGAutoBillView: VFGPaymentMethodCardStateDelegate {
    func fetchPaymentDidFinish(with error: Error?) {
        hideShimmer()
    }
}
