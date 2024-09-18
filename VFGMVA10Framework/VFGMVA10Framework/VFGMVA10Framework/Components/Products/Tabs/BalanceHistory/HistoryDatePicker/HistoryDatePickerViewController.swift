//
//  HistoryDatePickerViewController.swift
//  VFGMVA10Framework
//
//  Created by Ayman Ata on 09/09/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

protocol HistoryDatePickerViewControllerDelegate: AnyObject {
    func dateRangeDidSelect(startDate: Date, endDate: Date?, dateRange: String)
}

class HistoryDatePickerViewController: UIViewController {
    @IBOutlet weak var titleLabel: VFGLabel!
    @IBOutlet weak var subtitleLabel: VFGLabel!
    @IBOutlet weak var datePicker: VFGDatePicker!
    @IBOutlet weak var selectedPeriodTitleLabel: VFGLabel!
    @IBOutlet weak var selectedPeriodLabel: VFGLabel!
    @IBOutlet weak var viewHistoryButton: VFGButton!

    weak var delegate: HistoryDatePickerViewControllerDelegate?
    let minimumDate: Date?
    let maximumDate: Date?
    var rangeStartDate: Date?
    var rangeEndDate: Date?

    public required init(
        minimumDate: Date? = Date(),
        maximumDate: Date? = Date(),
        rangeStartDate: Date? = nil,
        rangeEndDate: Date? = nil,
        nibName: String = String(describing: HistoryDatePickerViewController.self),
        bundle: Bundle = .mva10Framework
    ) {
        self.minimumDate = minimumDate
        self.maximumDate = maximumDate
        self.rangeStartDate = rangeStartDate
        self.rangeEndDate = rangeEndDate
        super.init(nibName: nibName, bundle: bundle)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    private func setupUI() {
        datePicker.baseDate = rangeStartDate ?? Date()
        datePicker.minimumDate = minimumDate
        datePicker.maximumDate = maximumDate
        datePicker.startDate = rangeStartDate
        datePicker.endDate = rangeEndDate
        datePicker.mode = .rangeSelection
        datePicker.delegate = self
        datePicker.dataSource = self
        datePicker.appearance = self

        selectedPeriodTitleLabel.isHidden = true
        selectedPeriodLabel.isHidden = true
        viewHistoryButton.isEnabled = false
        viewHistoryButton.setTitle(
            "balance_date_filter_screen_view_history".localized(bundle: .mva10Framework),
            for: .normal
        )
        titleLabel.text = "balance_date_filter_screen_title".localized(bundle: .mva10Framework)
        subtitleLabel.text = "balance_date_filter_screen_subtitle".localized(bundle: .mva10Framework)
        updateSelectedRangeLabel()
        setupAccessibilityLabels()
    }

    private func updateSelectedRangeLabel() {
        guard let rangeStartDate = rangeStartDate else {
            return
        }

        selectedPeriodTitleLabel.isHidden = false
        selectedPeriodLabel.isHidden = false
        viewHistoryButton.isEnabled = true

        let fullDateFormatter = DateFormatter()
        fullDateFormatter.dateFormat = "d MMM YYYY"

        var startDateString: String {
            let partialDateFormatter = DateFormatter()
            partialDateFormatter.dateFormat = fullDateFormatter.dateFormat

            if let endDate = rangeEndDate {
                let calendar = Calendar.current
                let startDateComponents = calendar.dateComponents([.month, .year], from: rangeStartDate)
                let endDateComponents = calendar.dateComponents([.month, .year], from: endDate)

                partialDateFormatter.dateFormat = ""
                partialDateFormatter.dateFormat
                    .append(startDateComponents.month == endDateComponents.month ? "d" : "d MMM")
                partialDateFormatter.dateFormat
                    .append(startDateComponents.year == endDateComponents.year ? " " : " YYYY")
            }

            return partialDateFormatter.string(from: rangeStartDate)
        }

        guard let endDate = rangeEndDate else {
            selectedPeriodLabel.text = startDateString
            selectedPeriodLabel.accessibilityLabel = selectedPeriodLabel.text ?? ""
            return
        }

        let range = startDateString + " - " + fullDateFormatter.string(from: endDate)
        selectedPeriodLabel.text = range
        selectedPeriodLabel.accessibilityLabel = selectedPeriodLabel.text ?? ""
    }

    @IBAction func viewHistoryButtonDidPress(_ sender: Any) {
        guard
            let rangeStartDate = rangeStartDate,
            let dateRangeString = selectedPeriodLabel.text else {
            return
        }

        delegate?.dateRangeDidSelect(
            startDate: rangeStartDate,
            endDate: rangeEndDate,
            dateRange: dateRangeString
        )
        dismiss(animated: true, completion: nil)
    }
}

extension HistoryDatePickerViewController: VFGDatePickerDelegate, VFGDatePickerDataSource, VFGDatePickerAppearance {
    func datePicker(_ view: VFGDatePicker, dateDidSelect date: Date) {
        rangeStartDate = date
        rangeEndDate = nil
        updateSelectedRangeLabel()
    }

    func datePicker(_ view: VFGDatePicker, rangeDidSelect startDate: Date, _ endDate: Date) {
        rangeStartDate = startDate
        rangeEndDate = endDate
        updateSelectedRangeLabel()
    }

    func dayOfWeekLetter(_ view: VFGDatePicker, for dayNumber: Int) -> String {
        switch dayNumber {
        case 1:
            return "date_picker_days_sunday".localized(bundle: .mva10Framework)
        case 2:
            return "date_picker_days_monday".localized(bundle: .mva10Framework)
        case 3:
            return "date_picker_days_tuesday".localized(bundle: .mva10Framework)
        case 4:
            return "date_picker_days_wednesday".localized(bundle: .mva10Framework)
        case 5:
            return "date_picker_days_thursday".localized(bundle: .mva10Framework)
        case 6:
            return "date_picker_days_friday".localized(bundle: .mva10Framework)
        case 7:
            return "date_picker_days_saturday".localized(bundle: .mva10Framework)
        default:
            return ""
        }
    }
}

extension HistoryDatePickerViewController: VFGTrayContainerProtocol {
    public var tobiKey: String {
        "\(HistoryDatePickerViewController.self)"
    }

    public var trayStyle: VFGTrayStyle {
        .TOBI
    }

    public var tobiContainerVC: UIViewController? {
        VFGManagerFramework
            .tobiDelegate?
            .helpViewController(for: "\(HistoryDatePickerViewController.self)")
    }
}

extension HistoryDatePickerViewController {
    func setupAccessibilityLabels() {
        titleLabel.accessibilityLabel = titleLabel.text ?? ""
        subtitleLabel.accessibilityLabel = subtitleLabel.text ?? ""
        selectedPeriodTitleLabel.accessibilityLabel = selectedPeriodTitleLabel.text ?? ""
        selectedPeriodLabel.accessibilityLabel = selectedPeriodLabel.text ?? ""
        viewHistoryButton.accessibilityLabel = viewHistoryButton.titleLabel?.text ?? ""
        accessibilityCustomActions = [viewHistoryVoiceOverAction()]
    }
    /// action for  Balance History voice over
    /// - Returns: action for Balance History clear  button in voice over
    func viewHistoryVoiceOverAction() -> UIAccessibilityCustomAction {
        let actionName = "viewHistory"
        return UIAccessibilityCustomAction(
            name: actionName,
            target: self,
            selector: #selector(viewHistoryButtonDidPress))
    }
}
