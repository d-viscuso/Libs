//
//  AutoTopUpQuickActionViewModel.swift
//  VFGMVA10Framework
//
//  Created by Moataz Akram on 30/08/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import VFGMVA10Foundation
/// Auto top up quick action view model
open class AutoTopUpViewModel {
    public var quickActionsTitle: String = ""
    public var quickActionsStyle: VFQuickActionsStyle = .white
    /// An instance of *VFQuickActionsProtocol*
    weak var delegate: VFQuickActionsProtocol?
    /// Auto top up model data
    var autoTopUpModel: AutoTopUpModelProtocol?
    /// Top up state manager
    var stateManager: VFGAutoTopUpStateInternalProtocol?
    /// Array list of auto top up types
    var autoTopUpTypes: [String] = []
    /// Array list of auto top up occurences
    var exactOccurenceArray: [String] = []
    /// Array list of days of week
    var daysOfWeekArray: [String] = []
    /// Array list of days of month
    var daysOfMonthArray: [String] = []
    /// Array list of avaiable amount to top up with
    var amountsArray: [String] = []
    /// Array list of auto top up subtitles
    var subtitleArray: [String] = []
    /// Array list of auto top up descriptions
    var descriptionArray: [String] = []
    /// Auto top up selected type
    var selectedAutoTopUpType: String?
    /// Auto top up selected occurence
    var selectedExactOccurence: String?
    /// Auto top up quick action subtitle
    var titleLabelText: String?
    /// Auto top up subtitle
    var subTitleLabelText: String?
    /// Auto top up description
    var descriptionLabelText: String?
    /// Auto top up quick action next button
    var nextButtonText: String?
    /// Auto top up quick action cancel button
    var cancelButtonText: String?
    /// Determine if auto bill is in editing mode or not
    var isEditingMode = false
    /// Active auto top up model
    var activeAutoTopUpModel: VFGActiveAutoTopUpProtocol?
    /// Index of previously selected cell
    var previousSelectedIndex: Int = 0
    /// *AutoTopUpViewModel* initializer
    /// - Parameters:
    ///    - model: Auto top up model data
    ///    - stateManager: Top up state manager
    ///    - isEditingMode: Determine if auto bill is in editing mode or not
    ///    - activeAutoTopUpModel: Active auto top up model data
    init(
        model: AutoTopUpModelProtocol? = nil,
        stateManager: VFGAutoTopUpStateInternalProtocol? = nil,
        isEditingMode: Bool = false,
        activeAutoTopUpModel: VFGActiveAutoTopUpProtocol? = nil
    ) {
        autoTopUpModel = model
        self.stateManager = stateManager
        self.isEditingMode = isEditingMode
        self.activeAutoTopUpModel = activeAutoTopUpModel
        loadArrays()
        setupLabels()
        if isEditingMode {
            setActiveModel()
        } else {
            setSelectedTopUpType(index: 0)
        }
    }
    /// Setup top up model based on top up type
    func setActiveModel() {
        guard let activeModel = activeAutoTopUpModel else { return }
        switch activeModel.autoTopUpType {
        case AutoTopUpType.weekly:
            setSelectedTopUpType(index: 0)
            previousSelectedIndex = daysOfWeekArray.firstIndex(of: activeModel.exactOccurrence)
                ?? getSelectedCellIndex()
            setExactOcurrence(index: previousSelectedIndex)
        case AutoTopUpType.monthly:
            setSelectedTopUpType(index: 1)
            daysOfMonthArray = loadDaysOfMonthArray()
            previousSelectedIndex = daysOfMonthArray.firstIndex(of: activeModel.exactOccurrence)
                ?? getSelectedCellIndex()
            setExactOcurrence(index: previousSelectedIndex)
        default:
            setSelectedTopUpType(index: 2)
            let previousSelectedAmount = Int(activeModel.exactOccurrence) ?? 1
            previousSelectedIndex = autoTopUpModel?.amounts.firstIndex(of: previousSelectedAmount)
                ?? getSelectedCellIndex()
            setExactOcurrence(index: previousSelectedIndex)
        }
    }
    /// Handle next button action
    func nextButtonPressed() {
        if selectedAutoTopUpType?.elementsEqual(AutoTopUpType.amount) ?? false {
            guard let autoTopUpModel = autoTopUpModel else { return }
            selectedExactOccurence = String("\(autoTopUpModel.amounts[getSelectedCellIndex()])")
        }
        guard let selectedExactOccurence = selectedExactOccurence,
            let selectedAutoTopUpType = selectedAutoTopUpType else { return }
        stateManager?.initialAutoTopUpFinished(
            autoTopUpType: selectedAutoTopUpType,
            exactOcurrence: selectedExactOccurence
        )
    }
    /// Load array list of days of week &
    /// array list of days of month &
    /// array list of avaiable amount to top up with
    func loadArrays() {
        autoTopUpTypes = [AutoTopUpType.weekly, AutoTopUpType.monthly, AutoTopUpType.amount]
        daysOfWeekArray = [
            "auto_top_up_days_list_monday".localized(bundle: Bundle.mva10Framework),
            "auto_top_up_days_list_tuesday".localized(bundle: Bundle.mva10Framework),
            "auto_top_up_days_list_wednesday".localized(bundle: Bundle.mva10Framework),
            "auto_top_up_days_list_thursday".localized(bundle: Bundle.mva10Framework),
            "auto_top_up_days_list_friday".localized(bundle: Bundle.mva10Framework),
            "auto_top_up_days_list_saturday".localized(bundle: Bundle.mva10Framework),
            "auto_top_up_days_list_sunday".localized(bundle: Bundle.mva10Framework)
        ]
        subtitleArray = [
            "auto_top_up_weekly_subtitle".localized(bundle: Bundle.mva10Framework),
            "auto_top_up_monthly_subtitle".localized(bundle: Bundle.mva10Framework),
            "auto_top_up_amount_subtitle".localized(bundle: Bundle.mva10Framework)
        ]
        descriptionArray = [
            "auto_top_up_weekly_description".localized(bundle: Bundle.mva10Framework),
            "auto_top_up_monthly_description".localized(bundle: Bundle.mva10Framework),
            "auto_top_up_amount_description".localized(bundle: Bundle.mva10Framework)
        ]
        exactOccurenceArray = daysOfWeekArray
    }
    /// Return array list of days of month
    func loadDaysOfMonthArray() -> [String] {
        if daysOfMonthArray.isEmpty {
            for index in 1...31 {
                daysOfMonthArray.append("\(index)")
            }
        }
        return daysOfMonthArray
    }
    /// Return array list of avaiable amount to top up with
    func loadAmountArray() -> [String] {
        if amountsArray.isEmpty {
            if let autoTopUpModel = autoTopUpModel {
                for amount in autoTopUpModel.amounts {
                    let currencyFormatter = VFGMVA10CurrencyFormatter(bundle: Bundle.mva10Framework)
                    if autoTopUpModel.isIconRTL {
                        amountsArray.append(currencyFormatter.formatAmountToString(
                            amount: "\(amount)",
                            sign: autoTopUpModel.currency,
                            mode: .prefix
                        ))
                    } else {
                        amountsArray.append(currencyFormatter.formatAmountToString(
                            amount: "\(amount)",
                            sign: autoTopUpModel.currency
                        ))
                    }
                }
            } else {
                amountsArray = ["1€", "2€", "3€", "4€", "5€", "10€", "15€"]
            }
        }
        return amountsArray
    }
    /// Return array list of days of week
    func loadDaysOfWeekArray() -> [String] {
        return daysOfWeekArray
    }
    /// Return current cell index
    func getSelectedCellIndex() -> Int {
        return exactOccurenceArray.firstIndex(of: selectedExactOccurence ?? "") ?? 0
    }
    /// Localization setup
    func setupLabels() {
        quickActionsTitle = isEditingMode ?
            "auto_top_up_quick_action_edit_title".localized(bundle: Bundle.mva10Framework) :
            "auto_top_up_quick_action_title".localized(bundle: Bundle.mva10Framework)
        titleLabelText = "auto_top_up_quick_action_subtitle".localized(bundle: Bundle.mva10Framework)
        descriptionLabelText = descriptionArray[0]
        nextButtonText = "auto_top_up_quick_action_next_button".localized(bundle: Bundle.mva10Framework)
        cancelButtonText = "auto_top_up_quick_action_cancel_button".localized(bundle: Bundle.mva10Framework)
    }
    /// Determine which top up cell is selected
    func isCellSelected(index: Int) -> Bool {
        if selectedExactOccurence == exactOccurenceArray[index] {
            return true
        }
        return false
    }
    /// Determine which top up type is selected
    func isTypeSelected(index: Int) -> Bool {
        if selectedAutoTopUpType == autoTopUpTypes[index] {
            return true
        }
        return false
    }
    /// Set current cell ocurrence type
    func setExactOcurrence(index: Int) {
        selectedExactOccurence = exactOccurenceArray[index]
    }
    /// UI configuration based on selected top up type
    func setSelectedTopUpType(index: Int) {
        selectedAutoTopUpType = autoTopUpTypes[index]
        switch selectedAutoTopUpType {
        case AutoTopUpType.monthly:
            exactOccurenceArray = loadDaysOfMonthArray()
            descriptionLabelText = descriptionArray[1]
            subTitleLabelText = subtitleArray[1]
            let date = Date()
            let calendar = Calendar.current
            let components = calendar.dateComponents([.day], from: date)
            let dayOfMonth = components.day ?? 1
            selectedExactOccurence = exactOccurenceArray[dayOfMonth - 1]
        case AutoTopUpType.amount:
            exactOccurenceArray = loadAmountArray()
            descriptionLabelText = descriptionArray[2]
            subTitleLabelText = subtitleArray[2]
            selectedExactOccurence = nil
        default:
            exactOccurenceArray = loadDaysOfWeekArray()
            descriptionLabelText = descriptionArray[0]
            subTitleLabelText = subtitleArray[0]
            let date = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE"
            let dayInWeek = dateFormatter.string(from: date)
            selectedExactOccurence = String("\(dayInWeek.prefix(2).uppercased())")
        }
    }
    /// Determine whether next button is enabled or not
    func isNextButtonEnabled() -> Bool {
        if selectedAutoTopUpType == AutoTopUpType.amount && selectedExactOccurence == nil {
            return false
        } else {
            return true
        }
    }
    /// Return current cell top up type
    func getTopupTypeCellText(index: Int) -> String {
        return autoTopUpTypes[index]
    }
    /// Return current cell ocurrence type
    func getExactOcurrenceCellText(index: Int) -> String {
        return exactOccurenceArray[index]
    }
}

extension AutoTopUpViewModel: VFQuickActionsModel {
    public var quickActionsContentView: UIView {
        guard let autoTopUpCview: AutoTopUpView =
            AutoTopUpView.loadXib(
                bundle: Bundle.mva10Framework
            ) else {
                return UIView()
            }
        autoTopUpCview.configure(viewModel: self)
        return autoTopUpCview
    }
    public func quickActionsProtocol(delegate: VFQuickActionsProtocol) {
        self.delegate = delegate
    }
    public func closeQuickAction() {
        delegate?.closeQuickAction(completion: nil)
    }
}
