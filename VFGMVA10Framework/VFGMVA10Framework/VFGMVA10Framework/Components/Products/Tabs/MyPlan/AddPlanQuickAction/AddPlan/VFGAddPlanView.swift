//
//  VFGAddPlanView.swift
//  VFGMVA10Framework
//
//  Created by Hussein Kishk on 7/5/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

protocol VFGAddPlanViewProtocol: AnyObject {
    func confirmTapped(
        selectedPlanIndexPath: IndexPath,
        isRecurring: Bool,
        serviceType: String,
        with paymentCard: PaymentModelProtocol
    )
    func cancelTapped()
    func updateSelectedIndexPath(selectedPlanIndexPath: IndexPath?)
    func selectedAmount() -> Double?
}

enum AddPlanState: String {
    case populated
    case loading
    case error
}

class VFGAddPlanView: UIView {
    @IBOutlet weak var confirmButton: VFGButton!
    @IBOutlet weak var cancelButton: VFGButton!
    @IBOutlet weak var chooseOccurenceLabel: VFGLabel!
    @IBOutlet weak var oneOffOccurenceButton: VFGButton!
    @IBOutlet weak var recurringOccurenceButton: VFGButton!
    @IBOutlet weak var chooseAmountLabel: VFGLabel!
    @IBOutlet weak var chooseAmountCollectionView: UICollectionView!
    @IBOutlet weak var paymentInfoField: VFGLabel!
    @IBOutlet weak var paymentMethodsCard: VFGPaymentMethodsCardView!

    var model: VFGAddPlanModelProtocol?
    weak var delegate: VFGAddPlanViewProtocol?

    var isRecurring = false {
        didSet {
            updateButtonOutline()
        }
    }
    var selectedPlanIndexPath: IndexPath? {
        didSet {
            confirmButton.isEnabled = (selectedPlanIndexPath != nil) ? true : false
            delegate?.updateSelectedIndexPath(selectedPlanIndexPath: selectedPlanIndexPath)
        }
    }
    let amountCell = "AmountCell"
    let sectionInsetLeft: CGFloat = 16
    let sectionInsetRight: CGFloat = 16
    let minimumInteritemSpacing: CGFloat = 16
    let minimumLineSpacing: CGFloat = 7
    let numberOfCells: CGFloat = 3
    let amountCellHeight: CGFloat = 78
    let amountCellSpacing: CGFloat = 8

    var addPlanShimmerView: AddPlanShimmerView?
    var currentState: AddPlanState = .populated {
        didSet {
            if currentState == oldValue {
                return
            }
            switch currentState {
            case .loading:
                showShimmer()
            default:
                hideShimmer()
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        registerAmountCells()
        confirmButton.isEnabled = false
        if !isRecurring {
            updateButtonOutline()
        }
        currentState = .loading
        paymentMethodsCard?.collectionViewDelegate = self
        paymentMethodsCard.paymentCardStateDelegate = self
        setAccessibilityIDs()
        oneOffOccurenceButton.buttonStyle = 6
        recurringOccurenceButton.buttonStyle = 6
    }

    func configure(with model: VFGAddPlanModelProtocol?) {
        self.model = model
        let service = model?.serviceType
        switch service {
        case AddPlanType.data.rawValue:
            setupDataLabels()
        case AddPlanType.sms.rawValue:
            setupSMSLabels()
        case AddPlanType.calls.rawValue:
            setupCallsLabels()
        default:
            break
        }
        setupPaymentInfoFieldStyle()
    }

    func setupDataLabels() {
        chooseOccurenceLabel.text = "add_data_choose_occurrence_title".localized(bundle: Bundle.mva10Framework)
        oneOffOccurenceButton.setTitle(
            "add_data_occurrence_first_option_title".localized(bundle:
                Bundle.mva10Framework), for: .normal)
        recurringOccurenceButton.setTitle(
            "add_data_occurrence_second_option_title".localized(bundle:
                Bundle.mva10Framework), for: .normal)
        paymentMethodsCard.configure(
            title: "add_data_payment_method_title".localized(bundle: Bundle.mva10Framework),
            editText: "add_data_edit_title".localized(bundle: Bundle.mva10Framework),
            presenterType: .addPlan
        )
        chooseAmountLabel.text = "add_data_choose_amount_title".localized(bundle: Bundle.mva10Framework)
        paymentInfoField.text = "add_data_one_off_payment_statement".localized(bundle: Bundle.mva10Framework)
        confirmButton.setTitle("add_data_confirm_button_title".localized(bundle: Bundle.mva10Framework), for: .normal)
        cancelButton.setTitle("add_data_cancel_button_title".localized(bundle: Bundle.mva10Framework), for: .normal)
    }

    func setupPaymentInfoFieldStyle() {
        let attributedString = NSMutableAttributedString(
            string: paymentInfoField.text ?? "",
            attributes: [NSAttributedString.Key.font: UIFont.vodafoneLite(18)])

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 7
        paragraphStyle.alignment = .left
        attributedString.addAttribute(
            NSAttributedString.Key.paragraphStyle,
            value: paragraphStyle,
            range: NSRange(location: 0, length: attributedString.length)
        )
        paymentInfoField.attributedText = attributedString
    }

    func setupSMSLabels() {
        chooseOccurenceLabel.text = "add_sms_choose_occurrence_title".localized(bundle: Bundle.mva10Framework)
        oneOffOccurenceButton.setTitle(
            "add_sms_occurrence_first_option_title".localized(bundle:
                Bundle.mva10Framework), for: .normal)
        recurringOccurenceButton.setTitle(
            "add_sms_occurrence_second_option_title".localized(bundle:
                Bundle.mva10Framework), for: .normal)
        paymentMethodsCard.configure(
            title: "add_sms_payment_method_title".localized(bundle: Bundle.mva10Framework),
            editText: "add_sms_edit_title".localized(bundle: Bundle.mva10Framework),
            presenterType: .addPlan
        )
        chooseAmountLabel.text = "add_sms_choose_amount_title".localized(bundle: Bundle.mva10Framework)
        paymentInfoField.text = "add_sms_one_off_payment_statement".localized(bundle: Bundle.mva10Framework)
        confirmButton.setTitle("add_sms_confirm_button_title".localized(bundle: Bundle.mva10Framework), for: .normal)
        cancelButton.setTitle("add_sms_cancel_button_title".localized(bundle: Bundle.mva10Framework), for: .normal)
    }

    func setupCallsLabels() {
        chooseOccurenceLabel.text = "add_calls_choose_occurrence_title".localized(bundle: Bundle.mva10Framework)
        oneOffOccurenceButton.setTitle(
            "add_calls_occurrence_first_option_title".localized(bundle:
                Bundle.mva10Framework), for: .normal)
        recurringOccurenceButton.setTitle(
            "add_calls_occurrence_second_option_title".localized(bundle:
                Bundle.mva10Framework), for: .normal)
        paymentMethodsCard.configure(
            title: "add_calls_payment_method_title".localized(bundle: Bundle.mva10Framework),
            editText: "add_calls_edit_title".localized(bundle: Bundle.mva10Framework),
            presenterType: .addPlan
        )
        chooseAmountLabel.text = "add_calls_choose_amount_title".localized(bundle: Bundle.mva10Framework)
        paymentInfoField.text = "add_calls_one_off_payment_statement".localized(bundle: Bundle.mva10Framework)
        confirmButton.setTitle("add_calls_confirm_button_title".localized(bundle: Bundle.mva10Framework), for: .normal)
        cancelButton.setTitle("add_calls_cancel_button_title".localized(bundle: Bundle.mva10Framework), for: .normal)
    }

    func setAccessibilityIDs() {
        oneOffOccurenceButton.accessibilityIdentifier = "APoneOffOccurenceButton"
        recurringOccurenceButton.accessibilityIdentifier = "ADrecurringOccurenceButton"
        confirmButton.accessibilityIdentifier = "ADconfirmButton"
        cancelButton.accessibilityIdentifier = "ADcancelButton"
    }

    public func registerAmountCells() {
        chooseAmountCollectionView.delegate = self
        chooseAmountCollectionView.dataSource = self
        let nibName = UINib(nibName: amountCell, bundle: Bundle.mva10Framework)
        chooseAmountCollectionView.register(nibName, forCellWithReuseIdentifier: amountCell)
        chooseAmountCollectionView.allowsSelection = true
        chooseAmountCollectionView.isUserInteractionEnabled = true
    }

    func updateButtonOutline() {
        let service = model?.serviceType
        if isRecurring {
            recurringOccurenceButton.isChosen = true
            oneOffOccurenceButton.isChosen = false
            switch service {
            case AddPlanType.data.rawValue:
                paymentInfoField.text = "add_data_recurring_payment_statement".localized(bundle: Bundle.mva10Framework)
            case AddPlanType.sms.rawValue:
                paymentInfoField.text = "add_sms_recurring_payment_statement".localized(bundle: Bundle.mva10Framework)
            case AddPlanType.calls.rawValue:
                paymentInfoField.text = "add_sms_recurring_payment_statement".localized(bundle: Bundle.mva10Framework)
            default:
                break
            }
        } else {
            oneOffOccurenceButton.isChosen = true
            recurringOccurenceButton.isChosen = false
            switch service {
            case AddPlanType.data.rawValue:
                paymentInfoField.text = "add_data_one_off_payment_statement".localized(bundle: Bundle.mva10Framework)
            case AddPlanType.sms.rawValue:
                paymentInfoField.text = "add_sms_one_off_payment_statement".localized(bundle: Bundle.mva10Framework)
            case AddPlanType.calls.rawValue:
                paymentInfoField.text = "add_calls_one_off_payment_statement".localized(bundle: Bundle.mva10Framework)
            default:
                break
            }
        }
        chooseAmountCollectionView.reloadData()
    }

    func updateOutlineSelected(primaryLabel: UILabel?, secondaryLabel: UILabel? = nil, layer: CALayer?) {
        layer?.borderColor = UIColor.VFGSelectedCellBorder.cgColor
        layer?.borderWidth = 2
        primaryLabel?.textColor = UIColor.VFGSelectedText
        primaryLabel?.font = UIFont.vodafoneBold(18)
        secondaryLabel?.textColor = UIColor.VFGSelectedText
        secondaryLabel?.font = UIFont.vodafoneBold(14)
    }

    func updateOutlineUnselected(primaryLabel: UILabel?, secondaryLabel: UILabel? = nil, layer: CALayer?) {
        layer?.borderColor = UIColor.VFGDefaultSelectionOutline.cgColor
        layer?.borderWidth = 1
        primaryLabel?.textColor = UIColor.primaryTextColor
        primaryLabel?.font = UIFont.vodafoneRegular(18)
        secondaryLabel?.textColor = UIColor.VFGDarkGreyText
        secondaryLabel?.font = UIFont.vodafoneRegular(14)
    }

    @IBAction func oneOffTapped(_ sender: VFGButton) {
        selectedPlanIndexPath = isRecurring ? nil : selectedPlanIndexPath
        isRecurring = false
    }

    @IBAction func recurringTapped(_ sender: VFGButton) {
        selectedPlanIndexPath = isRecurring ? selectedPlanIndexPath : nil
        isRecurring = true
    }

    @IBAction func confirmTapped(_ sender: Any) {
        VFGDebugLog("Add plan clicked")
        if let card = paymentMethodsCard.shownPaymentCards.first {
            delegate?.confirmTapped(
                selectedPlanIndexPath: selectedPlanIndexPath ?? IndexPath(item: 0, section: 0),
                isRecurring: isRecurring,
                serviceType: model?.serviceType ?? "Data",
                with: card
            )
        }
    }
    @IBAction func cancelTapped(_ sender: Any) {
        delegate?.cancelTapped()
    }
}

extension VFGAddPlanView: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model?.dataBundles?.count ?? 0
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: amountCell,
            for: indexPath) as? AmountCell else {
                return UICollectionViewCell()
        }
        guard let bundle = model?.dataBundles?[indexPath.row] else {
            return cell
        }
        if let selected = selectedPlanIndexPath, selected == indexPath {
            updateOutlineSelected(
                primaryLabel: cell.amountLabel,
                secondaryLabel: cell.amountValueLabel,
                layer: cell.contentView.layer)
        } else {
            updateOutlineUnselected(
                primaryLabel: cell.amountLabel,
                secondaryLabel: cell.amountValueLabel,
                layer: cell.contentView.layer)
        }

        cell.setupCell(with: bundle, currency: model?.currency, isRecurring: isRecurring)
        cell.amountLabel.accessibilityIdentifier = "APamountLabel\(indexPath.row)"
        cell.amountValueLabel.accessibilityIdentifier = "APamountValueLabel\(indexPath.row)"
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var itemsToReload = [indexPath]
        if let previouslySelected = selectedPlanIndexPath, previouslySelected != indexPath {
            itemsToReload.append(previouslySelected)
        }
        selectedPlanIndexPath = indexPath

        UIView.performWithoutAnimation {
            collectionView.reloadItems(at: itemsToReload)
        }
    }
}

extension VFGAddPlanView: UICollectionViewDelegateFlowLayout {
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.sectionInset = UIEdgeInsets(top: 0, left: sectionInsetLeft, bottom: 0, right: sectionInsetRight)
        layout?.minimumInteritemSpacing = minimumInteritemSpacing
        layout?.minimumLineSpacing = minimumLineSpacing
        layout?.invalidateLayout()
        return CGSize(
            width: (collectionView.frame.width - sectionInsetLeft - sectionInsetRight
                - 2 * amountCellSpacing) / numberOfCells,
            height: amountCellHeight)
    }
}

extension VFGAddPlanView: VFGPaymentMethodCardStateDelegate {
    func fetchPaymentDidFinish(with error: Error?) {
        currentState = .populated
    }
}
