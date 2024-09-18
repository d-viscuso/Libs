//
//  VFGAppointmentDateViewController.swift
//  VFGMVA10Framework
//
//  Created by Yahya Saddiq on 2/8/21.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

class VFGAppointmentDateViewController: UIViewController, VFGBaseStepsViewControllerProtocol {
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var datePicker: VFGDatePicker!
    @IBOutlet weak var availableSlotLabel: VFGLabel!
    @IBOutlet weak var selectedDateLabel: VFGLabel!
    @IBOutlet weak var timeSlotsCollectionView: UICollectionView!
    @IBOutlet weak var CTAButton: VFGButton!
    @IBOutlet weak var subtitleLabel: VFGLabel!

    static var instance: VFGBaseStepsViewControllerProtocol {
        UIStoryboard(
            name: "VFGAppointmentDateViewController",
            bundle: .mva10Framework
        ).instantiateViewController(withIdentifier: "DateView")
        as? VFGAppointmentDateViewController ?? VFGAppointmentDateViewController()
    }

    var onStepComplete: ((Any) -> Void)?
    var onContentHeightChange: ((CGFloat) -> Void)?
    var selectedTimeSlotIndexPath: IndexPath?
    var stepTitle: String = "book_appointment_date_step_title".localized(bundle: .mva10Framework)
    lazy var viewModel: VFGAppointmentDateViewModel = {
        VFGAppointmentDateViewModel(
            dataProvider: VFGYourAppointmentsManager
                .shared
                .dateTimeProvider ?? VFGAppointmentDateDataProvider(baseURL: ""))
    }()

    lazy var contentHeight: CGFloat = {
        contentView.frame.height + contentView.frame.origin.y
    }()

    var selectedDate = Date() {
        didSet {
            selectedDateLabel.text = VFGBookAppointmentViewController.stringFrom(date: selectedDate)
            unselectTimeSlot()
            timeSlotsCollectionView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureDatePicker()
        configureUI()
        disableCTA()
        addAccessibilityForVoiceOver()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if viewModel.contentState == .populated {
            onContentHeightChange?(contentHeight)
        }
    }

    private func configureDatePicker() {
        datePicker.delegate = self
        datePicker.dataSource = self
        datePicker.appearance = self
        datePicker.minimumDate = Date()
        datePicker.maximumDate = Date().addingTimeInterval((60 * 60 * 24 * 5))
        datePicker.reloadData()
    }

    func fetchData() {
        initViewModel()
        resetDate()
    }

    private func initViewModel() {
        viewModel.updateLoadingStatus = { [weak self] in
            guard let self = self else {
                return
            }

            switch self.viewModel.contentState {
            case .loading:
                self.startShimmer()
                self.onContentHeightChange?(0)
            case .populated:
                self.timeSlotsCollectionView.reloadData()
                self.stopShimmer()
                self.onContentHeightChange?(self.contentHeight)
            case .empty:
                VFGDebugLog("empty")
            case .error:
                VFGDebugLog("error")
            case .filtered:
                VFGDebugLog("filter")
            }
        }

        viewModel.fetchAvailableAppointments()
    }

    private func resetDate() {
        selectedDate = Date()
    }

    private func startShimmer() {
        let view = UIView.loadXib(bundle: .mva10Framework, nibName: "VFGAppointmentDateShimmerView")
        guard let shimmerView: VFGAppointmentDateShimmerView = view as? VFGAppointmentDateShimmerView else {
            return
        }

        shimmerView.startShimmer()
        contentView?.embed(view: shimmerView)
    }

    private func stopShimmer() {
        contentView.subviews.last?.removeFromSuperview()
    }

    func dateDidChange() {
        selectedDateLabel.text = VFGBookAppointmentViewController.stringFrom(date: selectedDate)
        unselectTimeSlot()
        timeSlotsCollectionView.reloadData()
    }

    @IBAction func setDateTimeButtonDidPress() {
        setDateTimeButtonAction()
    }

    @objc func setDateTimeButtonAction() {
        guard let selectedTimeSlot = selectedTimeSlotIndexPath else {
            return
        }

        onStepComplete?(
            VFGAppointmentModel.DateTime(
                date: selectedDate,
                timeSlot: viewModel.timeSlot(at: selectedTimeSlot.row)
            )
        )
    }

    private func configureUI() {
        contentView.configureShadow()
        selectedDateLabel.text = VFGBookAppointmentViewController.stringFrom(date: selectedDate)
        availableSlotLabel.text = "book_appointment_date_available_slots".localized(bundle: .mva10Framework)
        CTAButton.setTitle("book_appointment_date_cta_button_title".localized(bundle: .mva10Framework), for: .normal)
        CTAButton.accessibilityIdentifier = "APselectDateTimeButton"
        subtitleLabel.text = "book_appointment_date_step_subtile".localized(bundle: .mva10Framework)
    }

    private func selectTimeSlot(at indexPath: IndexPath) {
        let cell = timeSlotsCollectionView.cellForItem(at: indexPath)
        cell?.layer.borderWidth = 2.1
        cell?.layer.borderColor = UIColor.VFGOceanText.cgColor
        (cell?.contentView.subviews.first as? VFGLabel)?.font = .vodafoneBold(15)
        selectedTimeSlotIndexPath = indexPath
        enableCTA()
    }

    private func unselectTimeSlot() {
        guard let selectedTimeSlot = selectedTimeSlotIndexPath else {
            return
        }

        let cell = timeSlotsCollectionView.cellForItem(at: selectedTimeSlot)
        cell?.layer.borderWidth = 1
        cell?.layer.borderColor = UIColor.VFGTimelineSeparator.cgColor
        (cell?.contentView.subviews.first as? VFGLabel)?.font = .vodafoneRegular(15)
        self.selectedTimeSlotIndexPath = nil
        disableCTA()
    }

    private func enableCTA() {
        CTAButton.isEnabled = true
    }

    private func disableCTA() {
        CTAButton.isEnabled = false
    }
}

// MARK: UICollectionViewDataSource
extension VFGAppointmentDateViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.contentState == .populated ? viewModel.numberOfTimeSlots() : 3
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "TimeSlotCell",
            for: indexPath)

        if viewModel.contentState == .populated {
            (cell.contentView.subviews.first as? VFGLabel)?.text = viewModel.timeSlotAsString(on: 0, at: indexPath.row)
            cell.isAccessibilityElement = true
            cell.accessibilityIdentifier = "APtimeSlot_\(indexPath.row)"
            cell.accessibilityLabel = viewModel.timeSlotAsString(on: 0, at: indexPath.row)
            cell.accessibilityHint = "tap to select this time slot"
        }

        return cell
    }
}

// MARK: UICollectionViewDelegate
extension VFGAppointmentDateViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        unselectTimeSlot()
        selectTimeSlot(at: indexPath)
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension VFGAppointmentDateViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(
            width: Constants.Appointment.Size.TimeSlotCell.width,
            height: Constants.Appointment.Size.TimeSlotCell.height
        )
    }
}
// MARK: date picker
extension VFGAppointmentDateViewController: VFGDatePickerDelegate, VFGDatePickerDataSource, VFGDatePickerAppearance {
    func datePicker(_ viewController: VFGDatePicker, dateDidSelect date: Date) {
        selectedDate = date
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
// MARK: Voice over
extension VFGAppointmentDateViewController {
    /// add accessibility for voice over
    func addAccessibilityForVoiceOver() {
        availableSlotLabel.accessibilityLabel = availableSlotLabel.text
        selectedDateLabel.accessibilityLabel = selectedDateLabel.text
        subtitleLabel.accessibilityLabel = subtitleLabel.text
        accessibilityCustomActions = [setDateTimeVoiceOverAction()]
    }
    /// action for set date time voice over
    /// - Returns: action for set date time  button in voice over
    func setDateTimeVoiceOverAction() -> UIAccessibilityCustomAction {
        let actionName = CTAButton.titleLabel?.text ?? ""
        return UIAccessibilityCustomAction(name: actionName, target: self, selector: #selector(setDateTimeButtonAction))
    }
}
