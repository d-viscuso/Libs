//
//  OrderDetailStepView.swift
//  VFGMVA10Framework
//
//  Created by Moataz Akram on 12/12/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import VFGMVA10Foundation
/// Step view delegate for *OrderDetailStepView*
public protocol OrderDetailStepViewDelegate: AnyObject {
    /// Primary button action
    func primaryButtonDidPress()
    /// Secondary button action
    func secondaryButtonDidPress()
}
/// Step view for *VFGOrderDetailsViewController*
class OrderDetailStepView: UIView, VFGStepViewEntry {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var buttonsView: UIView!
    @IBOutlet weak var buttonsStack: UIStackView!
    @IBOutlet weak var primaryButton: VFGButton!
    @IBOutlet weak var secondaryButton: VFGButton!
    @IBOutlet weak var footerStackView: UIStackView!
    @IBOutlet weak var updateTimeTitle: VFGLabel!
    @IBOutlet weak var updateTimeLabel: VFGLabel!
    @IBOutlet weak var stepImageView: VFGImageView!
    /// An instance of *OrderDetailStepViewDelegate*
    weak var delegate: OrderDetailStepViewDelegate?
    /// Step view details dictionary
    var config: [String: Any]?

    weak var stepEntryDelegate: VFGStepViewEntryDelegate?
    var data: [String: Any]?
    var title: String?
    /// Order item update date
    var updateDate: String?
    /// Order item update time
    var updateTime: String?
    var sideView: UIView?
    var stepView: UIView {
        self
    }
    /// Primary button action
    var primaryButtonAction: (() -> Void)?
    /// Secondary button action
    var secondaryButtonAction: (() -> Void)?

    public required init(config: [String: Any]?) {
        super.init(frame: CGRect.zero)
        self.config = config
        let stepTitle = config?["stepTitle"] as? String ?? ""
        title = ("\(stepTitle)")
        updateDate = config?["updateDate"] as? String ?? ""
        updateTime = config?["updateTime"] as? String ?? ""
        xibSetup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    /// *OrderDetailStepView* configuration
    func xibSetup() {
        guard let view = loadViewFromNib(nibName: "OrderDetailStepView") else { return }
        contentView = view
        xibSetup(contentView: contentView)
        configureShadow()
        configureCard()
    }
    // TODO: update logic & call it when receiving the itemInfoModel
    /// Step view card configuration
    func configureCard() {
        // title and time should be updated
        updateTimeTitle.text = "order_progress_timeline_step_update_time".localized(bundle: .mva10Framework)
        updateTimeLabel.text = "\(getStatusDate(with: updateDate) ?? ""), \(updateTime ?? "")"

        let cardType = OrderDetailCardType.buttonsState
        switch cardType {
        case .noButtons:
            footerStackView.arrangedSubviews[0].removeFromSuperview()
        case .oneButton:
            primaryButton
                .setTitle(
                    VFGMyOrdersManager
                        .shared.stepModel?.primaryButtonTitle ?? "",
                    for: .normal
                )
            primaryButtonAction = VFGMyOrdersManager
                .shared.stepModel?.primaryButtonAction
            buttonsStack.arrangedSubviews[1].removeFromSuperview()
        default:
            primaryButton
                .setTitle(
                    VFGMyOrdersManager
                        .shared.stepModel?.primaryButtonTitle ?? "",
                    for: .normal
                )
            primaryButtonAction = VFGMyOrdersManager
                .shared.stepModel?.primaryButtonAction
            secondaryButton
                .setTitle(
                    VFGMyOrdersManager
                        .shared.stepModel?.secondaryButtonTitle ?? "",
                    for: .normal
                )
            secondaryButtonAction = VFGMyOrdersManager
                .shared.stepModel?.secondaryButtonAction
        }
        stepImageView.image = VFGImage(
            named:
                VFGMyOrdersManager
                .shared.stepModel?.stepImageName
        )
    }

    @IBAction func primaryButtonDidPress(_ sender: Any) {
        guard let primaryButtonAction = primaryButtonAction else {
            return
        }
        primaryButtonAction()
    }

    @IBAction func secondaryButtonDidPress(_ sender: Any) {
        guard let secondaryButtonAction = secondaryButtonAction else {
            return
        }
        secondaryButtonAction()
    }
}
/// Order detail card buttons States
enum OrderDetailCardType {
    case noButtons
    case oneButton
    case twoButtons

    static var buttonsState: OrderDetailCardType {
        if !(VFGMyOrdersManager.shared.stepModel?.primaryButtonTitle.isEmptyOrNil ?? true),
        !(VFGMyOrdersManager.shared.stepModel?.secondaryButtonTitle.isEmptyOrNil ?? true) {
            return .twoButtons
        } else if !(VFGMyOrdersManager.shared.stepModel?.primaryButtonTitle.isEmptyOrNil ?? true) {
            return .oneButton
        } else {
            return .noButtons
        }
    }
}

extension OrderDetailStepView {
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
            format: "'\(dayOrdinal)' MMMM",
            dateFormatString: Constants.AddOnsTimeline.dateFormat,
            locale: Constants.AddOnsTimeline.localeUS)
    }
}
