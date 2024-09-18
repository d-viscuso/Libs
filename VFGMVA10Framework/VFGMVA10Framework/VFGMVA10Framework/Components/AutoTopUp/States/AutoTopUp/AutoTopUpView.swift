//
//  AutoTopUpView.swift
//  VFGMVA10Framework
//
//  Created by Moataz Akram on 31/08/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import VFGMVA10Foundation
import CoreGraphics
/// Auto top up quick action view
public class AutoTopUpView: UIView {
    @IBOutlet weak var titleLabel: VFGLabel!
    @IBOutlet weak var subtitleLabel: VFGLabel!
    @IBOutlet weak var descriptionLabel: VFGLabel!
    @IBOutlet weak var autoTopUpTypeCollectionView: UICollectionView!
    @IBOutlet weak var occurenceCollectionView: UICollectionView!
    @IBOutlet weak var nextButton: VFGButton!
    @IBOutlet weak var cancelButton: VFGButton!
    /// *AutoTopUpView* view model
    var viewModel: AutoTopUpViewModel?
    let autoTopUpTypeCollectionViewCell = "AutoTopUpTypeCollectionViewCell"
    let autoBillDaysCollectionViewCell = "AutoBillDaysCollectionViewCell"
    let collectionViewCellHeight: CGFloat = 50
    var autoBillDaysCollectionViewCellWidth: CGFloat = 50
    var autoTopUpTypeCellWidth: CGFloat = 100
    let autoTopUpTypeCellSpacing: CGFloat = 8
    let collectionViewCellMargin: CGFloat = 16
    /// *AutoTopUpView* configuration
    /// - Parameters:
    ///    - viewModel: *AutoTopUpView* view model data
    func configure(viewModel: AutoTopUpViewModel) {
        self.viewModel = viewModel
        setupLabels()
        setupCollectionViews()
        setupAccessibilityLabels()
        setupCollectionViewCelldimentions()
    }

    private func setupCollectionViews() {
        autoTopUpTypeCollectionView.delegate = self
        autoTopUpTypeCollectionView.dataSource = self
        autoTopUpTypeCollectionView.register(
            UINib(
                nibName: autoTopUpTypeCollectionViewCell,
                bundle: .mva10Framework
            ),
            forCellWithReuseIdentifier: autoTopUpTypeCollectionViewCell)
        occurenceCollectionView.delegate = self
        occurenceCollectionView.dataSource = self
        occurenceCollectionView.register(
            UINib(
                nibName: autoBillDaysCollectionViewCell,
                bundle: .mva10Framework
            ),
            forCellWithReuseIdentifier: autoBillDaysCollectionViewCell)
        autoTopUpTypeCollectionView.reloadData()
        occurenceCollectionView.reloadData()
        scrollToSelectedDay(row: viewModel?.getSelectedCellIndex() ?? 0, animated: false)
    }

    private func setupLabels() {
        titleLabel.text = viewModel?.titleLabelText
        subtitleLabel.text = viewModel?.subTitleLabelText
        descriptionLabel.text = viewModel?.descriptionLabelText
        nextButton.setTitle(viewModel?.nextButtonText, for: .normal)
        cancelButton.setTitle(viewModel?.cancelButtonText, for: .normal)
    }
    /// Determine whether next button is enabled or not
    func isNextButtonEnabled() {
        if viewModel?.isNextButtonEnabled() ?? false {
            nextButton.isEnabled = true
            nextButton.backgroundColor = UIColor.VFGPrimaryButton
        } else {
            nextButton.isEnabled = false
            nextButton.backgroundColor = UIColor.VFGDisabledButtonRedBG
        }
    }

    @IBAction func nextButtonPressed(_ sender: Any) {
        viewModel?.nextButtonPressed()
    }

    @IBAction func cancelButtomPressed(_ sender: Any) {
        viewModel?.closeQuickAction()
    }
    /// UI update
    func updateLabels() {
        subtitleLabel.text = viewModel?.subTitleLabelText
        descriptionLabel.text = viewModel?.descriptionLabelText
    }

    /// Calculates collectionViews' cell width
    private func setupCollectionViewCelldimentions() {
        guard
            let exactOccurrenceArrayCount = viewModel?.exactOccurenceArray.count,
            let autoTopUpTypeCellCount = viewModel?.autoTopUpTypes.count
        else { return }

        let autoBillDaysCellDynamicWidth = (UIScreen.main.bounds.size.width
        - collectionViewCellMargin * 2
        ) / CGFloat(exactOccurrenceArrayCount)
        autoBillDaysCollectionViewCellWidth = max(
            autoBillDaysCollectionViewCellWidth, autoBillDaysCellDynamicWidth)

        autoTopUpTypeCellWidth = (UIScreen.main.bounds.size.width
            - (autoTopUpTypeCellSpacing * CGFloat(autoTopUpTypeCellCount - 1))
            - collectionViewCellMargin * 2
        ) / CGFloat(autoTopUpTypeCellCount)
    }

    private func setupAccessibilityLabels() {
        nextButton.isAccessibilityElement = true
        nextButton.accessibilityCustomActions = [nextButtonAXAction()]

        cancelButton.isAccessibilityElement = true
        cancelButton.accessibilityCustomActions = []
    }

    private func nextButtonAXAction() -> UIAccessibilityCustomAction {
        let actionName = "Next"
        return UIAccessibilityCustomAction(
            name: actionName,
            target: self,
            selector: #selector(nextButtonPressed))
    }

    private func cancelButtonAXAction() -> UIAccessibilityCustomAction {
        let actionName = "Cancel"
        return UIAccessibilityCustomAction(
            name: actionName,
            target: self,
            selector: #selector(cancelButtomPressed))
    }

    private func getAXLabelForExactOcurrenceCell(_ text: String) -> String {
        switch text {
        case "MO": return "Monday"
        case "TU": return "Tuesday"
        case "WE": return "Wednesday"
        case "TH": return "Thursday"
        case "FR": return "Friday"
        case "SA": return "Saturday"
        case "SU": return "Sunday"
        default: return text
        }
    }
}

// MARK: - CollectionViews

extension AutoTopUpView: UICollectionViewDelegate, UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == autoTopUpTypeCollectionView {
            return viewModel?.autoTopUpTypes.count ?? 0
        } else {
            return viewModel?.exactOccurenceArray.count ?? 0
        }
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == autoTopUpTypeCollectionView {
            return drawAutoTopUpTypeCell(collectionView, indexPath)
        } else {
            return drawExactOcurrenceCell(collectionView, indexPath)
        }
    }

    func drawAutoTopUpTypeCell(_ collectionView: UICollectionView, _ indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView
            .dequeueReusableCell(
                withReuseIdentifier: autoTopUpTypeCollectionViewCell,
                for: indexPath
            ) as? AutoTopUpTypeCollectionViewCell
        else { return UICollectionViewCell() }
        cell.autoTopUpTypeLabel.text = viewModel?.getTopupTypeCellText(index: indexPath.row)
        if viewModel?.isTypeSelected(index: indexPath.row) ?? false {
            cell.autoTopUpTypeLabel.layer.borderColor = UIColor.VFGSelectedInputOutline.cgColor
            cell.autoTopUpTypeLabel.layer.borderWidth = CGFloat(2)
            cell.autoTopUpTypeLabel.font = UIFont.vodafoneBold(CGFloat(19))
        } else {
            cell.autoTopUpTypeLabel.layer.borderColor = UIColor.VFGDefaultSelectionOutline.cgColor
            cell.autoTopUpTypeLabel.layer.borderWidth = CGFloat(1)
            cell.autoTopUpTypeLabel.font = UIFont.vodafoneRegular(CGFloat(19))
        }
        cell.isAccessibilityElement = true
        cell.accessibilityLabel = cell.autoTopUpTypeLabel.text ?? ""
        return cell
    }

    func drawExactOcurrenceCell(_ collectionView: UICollectionView, _ indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView
            .dequeueReusableCell(
                withReuseIdentifier: autoBillDaysCollectionViewCell,
                for: indexPath
            ) as? AutoBillDaysCollectionViewCell
        else { return UICollectionViewCell() }
        cell.dayLabel.text = viewModel?.getExactOcurrenceCellText(index: indexPath.row)
        if viewModel?.isCellSelected(index: indexPath.row) ?? false {
            cell.containerView.backgroundColor = .VFGFilterSelectedBg
            cell.dayLabel.textColor = .VFGFilterSelectedText
        } else {
            cell.containerView.backgroundColor = .VFGFilterUnselectedBgTwo
            cell.dayLabel.textColor = .VFGFilterUnselectedText
        }
        cell.isAccessibilityElement = true
        cell.accessibilityLabel = getAXLabelForExactOcurrenceCell(cell.dayLabel.text ?? "")
        return cell
    }

    fileprivate func scrollToSelectedDay(row: Int, animated: Bool = false) {
        DispatchQueue.main.async { [self] in
            occurenceCollectionView.scrollToItem(
                at: IndexPath(item: row, section: 0),
                at: .centeredHorizontally,
                animated: animated
            )
            occurenceCollectionView.setNeedsLayout()
            occurenceCollectionView.reloadData()
        }
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == autoTopUpTypeCollectionView {
            viewModel?.setSelectedTopUpType(index: indexPath.row)
            updateLabels()
            isNextButtonEnabled()
            scrollToSelectedDay(row: viewModel?.getSelectedCellIndex() ?? 0, animated: false)
            autoTopUpTypeCollectionView.reloadData()
            occurenceCollectionView.reloadData()
        } else {
            viewModel?.setExactOcurrence(index: indexPath.row)
            isNextButtonEnabled()
            scrollToSelectedDay(row: indexPath.row, animated: true)
            occurenceCollectionView.reloadData()
        }
    }
}

extension AutoTopUpView: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == autoTopUpTypeCollectionView {
            return CGSize(
                width: autoTopUpTypeCellWidth,
                height: collectionViewCellHeight)
        } else {
            return CGSize(
                width: autoBillDaysCollectionViewCellWidth,
                height: collectionViewCellHeight)
        }
    }
}
/// Auto top up quick action types
enum AutoTopUpType {
    static let weekly = "auto_top_up_weekly_text".localized(bundle: Bundle.mva10Framework)
    static let monthly = "auto_top_up_monthly_text".localized(bundle: Bundle.mva10Framework)
    static let amount = "auto_top_up_amount_text".localized(bundle: Bundle.mva10Framework)
}
