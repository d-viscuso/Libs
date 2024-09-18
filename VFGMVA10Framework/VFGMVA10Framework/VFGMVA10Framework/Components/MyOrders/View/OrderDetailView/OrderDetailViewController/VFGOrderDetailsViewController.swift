//
//  VFGOrderDetailsViewController.swift
//  VFGMVA10Framework
//
//  Created by Moataz Akram on 15/12/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import VFGMVA10Foundation
/// Display order details
class VFGOrderDetailsViewController: UIViewController, BaseMultiTabsViewController {
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var orderUpdatesLabel: VFGLabel!
    @IBOutlet weak var orderPlacedLabel: VFGLabel!
    @IBOutlet weak var viewOrderLabel: VFGLabel!
    @IBOutlet weak var getAlertsButton: VFGButton!
    /// An instance of *OrderDetailsViewModel*
    var viewModel: OrderDetailsViewModel?
    var enableTapAction = false
    var rootViewController: (UIViewController & BaseMultiTabsViewControllerDelegate)?
    var updateHeightClosure: ((CGFloat) -> Void)?
    var setHeightClosure: ((CGFloat) -> Void)?
    /// Displayed order number
    public var orderNumber: Int?
    /// Displayed order item number
    public var itemNumber: Int?
    func refresh() {}
    let headerHeight: CGFloat = 240
    /// Array of displayed steps
    var stepsArray: [VFGStepViewEntry] = []
    /// Array of previous steps states
    var previousStepsState: [VFGPreviousStepState] = []
    /// Vertical step view
    var stepperView = VFGVerticalStepControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = OrderDetailsViewModel()
        initViewModel()
        setupLocalization()
    }

    private func initViewModel() {
        viewModel?.updateLoadingStatus = { [weak self] in
            switch self?.viewModel?.contentState {
            case .populated:
                DispatchQueue.main.async {
                    self?.setupStepperView()
                }
                // here to add setup for view controller and reload stepper
            default:
                break
            }
        }
        // here to call api using delegate values
        viewModel?.fetchOrderItem(orderId: "\(orderNumber ?? 12345)", itemId: "\(itemNumber ?? 1)")
    }
    /// Step view configuration
    func setupStepperView() {
        orderPlacedLabel.text = String(
            format: "order_progress_timeline_subtitle".localized(bundle: .mva10Framework),
            "\(getStatusDate(with: viewModel?.orderItemModel?.placedDate ?? "") ?? "")"
        )
        stepperView.delegate = self
        stepperView.dataSource = self
        let stepsCount = viewModel?.orderItemModel?.stepsKeys.count ?? 1
        for index in 0..<stepsCount {
            let step = OrderDetailStepView(
                config:
                    [
                        "stepTitle": viewModel?.orderItemModel?
                        .stepsKeys[index] ?? "",
                        "updateDate": viewModel?.orderItemModel?.updateDate ?? "",
                        "updateTime": viewModel?.orderItemModel?.updateTime ?? ""
                    ]
            )
            step.stepEntryDelegate = self
            stepsArray.append(step)
            if index < viewModel?.orderItemModel?.currentStep ?? 1 {
                previousStepsState.append(.completed)
            }
        }
        stepperView.setup()
        if let startIndex = viewModel?.orderItemModel?.currentStep {
            stepperView.startAtIndex(
                index: startIndex,
                previousStepsState: previousStepsState
            )
        }
        stackView.removeAllArrangedSubviews()
        stackView.addArrangedSubview(stepperView)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.updateHeightClosure?(self.view.frame.height - self.headerHeight)
        }
        stepperView.setupStepsBackgroundColor(with: .VFGLightGreyBackground)
    }
    /// Localization Configuration
    func setupLocalization() {
        getAlertsButton.setTitle(
            "order_progress_alert_button".localized(bundle: .mva10Framework),
            for: .normal
        )
        orderUpdatesLabel.text = "order_progress_timeline_title".localized(bundle: .mva10Framework)
        viewOrderLabel.text = "order_progress_timeline_action".localized(bundle: .mva10Framework)
    }

    @IBAction func viewOrderDetailsDidPress(_ sender: Any) {
        // To be implemented in next sprints
    }
}

// MARK: - VFGVerticalStepControlDataSource
extension VFGOrderDetailsViewController: VFGVerticalStepControlDataSource {
    public func numberOfSteps(_ stepControl: VFGVerticalStepControl) -> Int {
        return stepsArray.count
    }

    public func stepEntry(_ stepControl: VFGVerticalStepControl, at index: Int) -> VFGStepViewEntry? {
        return stepsArray[index]
    }
}

// MARK: - VFGVerticalStepControlDelegate
extension VFGOrderDetailsViewController: VFGVerticalStepControlDelegate {
}

// MARK: - VFGStepViewEntryDelegate
extension VFGOrderDetailsViewController: VFGStepViewEntryDelegate {
    public func stepEntry(_ stepEntry: VFGStepViewEntry?, action: VFGStepAction, data: [String: Any]?) {
        stepperView.perform(action: action)
    }
}

extension VFGOrderDetailsViewController {
    // MARK: - getStatusDate
    private func getStatusDate(with date: String?) -> String? {
        var dayOrdinal = ""
        if let dateString = date,
        let date = VFGDateHelper.getDateFromString(dateString: dateString) {
            let ordinalFormatter = NumberFormatter()
            ordinalFormatter.numberStyle = .ordinal
            let day = Calendar.current.component(.day, from: date)
            dayOrdinal = ordinalFormatter.string(from: NSNumber(value: day)) ?? ""
        }
        return VFGDateHelper.changeDateStringFormat(
            dateString: date ?? "",
            format: "'\(dayOrdinal)' MMMM yyyy",
            dateFormatString: Constants.AddOnsTimeline.dateFormat,
            locale: Constants.AddOnsTimeline.localeUS)
    }
}
