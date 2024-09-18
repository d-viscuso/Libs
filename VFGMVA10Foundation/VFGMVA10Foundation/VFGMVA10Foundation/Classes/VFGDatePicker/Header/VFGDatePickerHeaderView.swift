//
//  VFGDatePickerHeaderView.swift
//  VFGMVA10Foundation
//
//  Created by Yahya Saddiq on 13/09/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

class VFGDatePickerHeaderView: UIView {
    lazy var monthLabel: VFGLabel = {
        let label = VFGLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .vodafoneBold(18.7)
        label.text = "Month"
        label.accessibilityTraits = .header
        label.isAccessibilityElement = true
        return label
    }()

    lazy var previousMonthButton: VFGButton = {
        let button = VFGButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(VFGFoundationAsset.Image.icChevronLeft, for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        button.accessibilityLabel = "previous month"
        button.addTarget(self, action: #selector(didTapPreviousMonthButton), for: .touchUpInside)
        return button
    }()

    lazy var nextMonthButton: VFGButton = {
        let button = VFGButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(VFGFoundationAsset.Image.icChevronRight, for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        button.accessibilityLabel = "next month"
        button.addTarget(self, action: #selector(didTapNextMonthButton), for: .touchUpInside)
        return button
    }()

    lazy var dayOfWeekStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        return stackView
    }()

    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = datePicker?.calendar
        dateFormatter.locale = Locale.autoupdatingCurrent
        dateFormatter.setLocalizedDateFormatFromTemplate("MMMM y")
        return dateFormatter
    }()

    var baseDate = Date() {
        didSet {
            monthLabel.text = dateFormatter.string(from: baseDate)
            toggleChevronsVisibility()
        }
    }

    let didTapLastMonthCompletionHandler: (() -> Void)
    let didTapNextMonthCompletionHandler: (() -> Void)
    weak var datePicker: VFGDatePicker?

    init(
        didTapLastMonthCompletionHandler: @escaping (() -> Void),
        didTapNextMonthCompletionHandler: @escaping (() -> Void),
        datePicker: VFGDatePicker
    ) {
        self.datePicker = datePicker
        self.didTapLastMonthCompletionHandler = didTapLastMonthCompletionHandler
        self.didTapNextMonthCompletionHandler = didTapNextMonthCompletionHandler
        super.init(frame: CGRect.zero)

        translatesAutoresizingMaskIntoConstraints = false

        backgroundColor = .VFGWhiteBackground

        addSubview(monthLabel)
        addSubview(previousMonthButton)
        addSubview(nextMonthButton)
        addSubview(dayOfWeekStackView)
    }

    @objc func didTapPreviousMonthButton() {
        didTapLastMonthCompletionHandler()
    }

    @objc func didTapNextMonthButton() {
        didTapNextMonthCompletionHandler()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        NSLayoutConstraint.activate([
            monthLabel.topAnchor.constraint(equalTo: topAnchor),
            monthLabel.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),

            dayOfWeekStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            dayOfWeekStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            dayOfWeekStackView.topAnchor.constraint(equalTo: monthLabel.bottomAnchor, constant: 20),

            previousMonthButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            previousMonthButton.centerYAnchor.constraint(equalTo: monthLabel.centerYAnchor),

            nextMonthButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            nextMonthButton.centerYAnchor.constraint(equalTo: monthLabel.centerYAnchor)
        ])
    }

    func toggleChevronsVisibility() {
        guard let datePicker = datePicker else {
            return
        }

        if let nextMonthDate = datePicker.calendar.date(
            byAdding: DateComponents(month: +1),
            to: baseDate),
        let nextMonthFirstDay = datePicker.calendar.date(
            from: datePicker.calendar.dateComponents(
                [.year, .month],
                from: datePicker.calendar.startOfDay(for: nextMonthDate)
            )
        ) {
            nextMonthButton.isHidden = !datePicker.isEnabledDate(nextMonthFirstDay)
        }

        if let currentDay = datePicker.calendar.dateComponents([.day], from: baseDate).day,
        let previousMonthLastDay = datePicker.calendar.date(
            byAdding: DateComponents(day: -currentDay),
            to: baseDate
        ) {
            previousMonthButton.isHidden = !datePicker.isEnabledDate(previousMonthLastDay)
        }
    }

    func buildDayOfWeek() {
        guard let datePicker = datePicker else { return }
        dayOfWeekStackView.removeAllArrangedSubviews()

        let firstWeekDay = datePicker.calendar.firstWeekday
        (firstWeekDay...(7 + firstWeekDay))
            .map { $0 % 8 }
            .filter { $0 != 0 }
            .forEach { dayNumber in
                let dayLabel = VFGLabel()
                dayLabel.font = .vodafoneRegular(14.6)
                dayLabel.textColor = .VFGSecondaryText
                dayLabel.textAlignment = .center
                dayLabel.text = datePicker.dataSource?.dayOfWeekLetter(datePicker, for: dayNumber)

                dayLabel.isAccessibilityElement = false
                dayOfWeekStackView.addArrangedSubview(dayLabel)
            }
    }
}
