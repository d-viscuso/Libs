//
//  VFGAppointmentsHistoryView.swift
//  lottie-ios
//
//  Created by Samar Younan on 17/02/2022.
//

import VFGMVA10Foundation

public class VFGAppointmentsHistoryView: UIView {
    @IBOutlet weak var tableContainerView: UIView!
    @IBOutlet weak var historyTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var historyTableView: UITableView!
    @IBOutlet weak var historyTitleLabel: VFGLabel!

    var tableViewHeightObserver: NSKeyValueObservation?
    public lazy var viewModel: VFGYourAppointmentsViewModelProtocol = {
        VFGYourAppointmentsViewModel()
    }()
    weak public var apppointmentsHistoryDelegate: VFGYourAppointmentsHistoryDelegate?
    public init() {
        super.init(frame: .zero)
        xibSetup()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        xibSetup()
    }
    func xibSetup() {
        guard let contentView = self.loadViewFromNib(nibName: className, in: .mva10Framework) else {
            return
        }
        xibSetup(contentView: contentView)
        historyTableView.delegate = self
        historyTableView.dataSource = self
        registerCells()
        observeHeight()
    }

    func registerCells() {
        let nib = UINib(nibName: "VFGYourAppointmentsHistoryTableViewCell", bundle: .mva10Framework)
        historyTableView.register(nib, forCellReuseIdentifier: "appointmentHistoryCell")
    }
    func observeHeight() {
        tableViewHeightObserver = historyTableView.observe(\.contentSize, options: [.new]) { [weak self]_, change in
            guard let self = self,
            let newHeight = change.newValue?.height else { return }
            self.historyTableViewHeight.constant = newHeight
        }
    }
    deinit {
        tableViewHeightObserver = nil
    }
}


extension VFGAppointmentsHistoryView: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfHistoryAppointments()
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if viewModel.numberOfHistoryAppointments() > 0 {
            historyTitleLabel.isHidden = false
        } else {
            historyTitleLabel.isHidden = true
        }
        historyTitleLabel.text = "your_appointments_history_header_title".localized(bundle: Bundle.mva10Framework)
        let cell = tableView.dequeueReusableCell(withIdentifier: "appointmentHistoryCell", for: indexPath)
        guard let cellItem = cell as? VFGYourAppointmentsHistoryTableViewCell else {
            return cell
        }

        setupActionsForCell(cell: cellItem, row: indexPath.row)
        cellItem.setupCell(appointment: viewModel.historyAppointment(at: indexPath.row))
        cell.isAccessibilityElement = true
        cell.accessibilityIdentifier = "APappointmentHistoryCell"
        return cellItem
    }

    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNonzeroMagnitude
    }
}

// MARK: Cell Actions
extension VFGAppointmentsHistoryView {
    func setupActionsForCell(cell: VFGYourAppointmentsHistoryTableViewCell, row: Int) {
        cell.reviewButtonPressedAction = { [weak self] appointmentId in
            self?.reviewAppointment(appointmentId: appointmentId)
        }
        cell.requestAgainButtonPressedAction = { [weak self] in
            self?.requestAgainAppointment()
        }
    }

    func reviewAppointment(appointmentId: String) {
        VFGDebugLog("review Appointment")
        apppointmentsHistoryDelegate?.reviewAppointmentDidPressed(appointmentId: appointmentId)
    }

    func requestAgainAppointment() {
        VFGDebugLog("request again Appointment")
        apppointmentsHistoryDelegate?.requestAppointmentAgainDidPressed()
    }
}


extension VFGAppointmentsHistoryView {
    func addShadow() {
        tableContainerView.layer.cornerRadius = 4
        tableContainerView.addingShadow(size: CGSize(width: 0, height: 1), radius: 4, opacity: 0.16)
        tableContainerView.layer.masksToBounds = true
    }
}
