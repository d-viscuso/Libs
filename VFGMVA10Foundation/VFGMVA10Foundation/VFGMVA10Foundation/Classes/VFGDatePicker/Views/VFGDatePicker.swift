//
//  VFGDatePicker.swift
//  VFGMVA10Foundation
//
//  Created by Yahya Saddiq on 13/09/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

/// A view that allows a user to pick a date in various ways,
/// you can selected one date or a range of dates
public class VFGDatePicker: UIView {
    // MARK: Views
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 6.5
        layout.minimumInteritemSpacing = 0

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isScrollEnabled = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()

    lazy var headerView = VFGDatePickerHeaderView(
        didTapLastMonthCompletionHandler: { [weak self] in
            guard let self = self else { return }

            self.baseDate = self.calendar.date(
                byAdding: .month,
                value: -1,
                to: self.baseDate
            ) ?? self.baseDate
        },
        didTapNextMonthCompletionHandler: { [weak self] in
            guard let self = self else { return }

            self.baseDate = self.calendar.date(
                byAdding: .month,
                value: 1,
                to: self.baseDate
            ) ?? self.baseDate
        },
        datePicker: self
    )

    // MARK: Non-public Properties
    lazy var calendar: Calendar = {
        var calendar = Calendar.current
        if let timeZone = TimeZone(secondsFromGMT: 0) {
            calendar.timeZone = timeZone
        }
        return calendar
    }()

    lazy var collectionViewTrailingAnchor = collectionView.trailingAnchor.constraint(
        equalTo: trailingAnchor
    )
    lazy var headerViewTrailingAnchor = headerView.trailingAnchor.constraint(
        equalTo: collectionView.trailingAnchor
    )

    lazy private var collectionViewHeightAnchor = collectionView.heightAnchor.constraint(
        equalToConstant: 0
    )

    lazy var days: [VFGDay] = generateDaysInMonth(for: baseDate)

    var numberOfWeeksInBaseDate: Int {
        calendar.range(of: .weekOfMonth, in: .month, for: baseDate)?.count ?? 0
    }

    lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d"
        return dateFormatter
    }()
    let cellHeight = 33
    let headerHeight: CGFloat = 75

    // MARK: - Public properties
    public weak var delegate: VFGDatePickerDelegate?
    public weak var dataSource: VFGDatePickerDataSource? {
        didSet {
            headerView.buildDayOfWeek()
            reloadData()
        }
    }
    public weak var appearance: VFGDatePickerAppearance?
    public var gapless = false
    public var mode = VFGDatePickerMode.singleSelection
    public var startDate: Date?
    public var endDate: Date?
    public var minimumDate: Date? {
        didSet {
            guard let minimumDate = minimumDate else {
                return
            }
            let minimumDateComponents = calendar.dateComponents([.day, .month, .year], from: minimumDate)
            self.minimumDate = calendar.date(from: minimumDateComponents)
            headerView.toggleChevronsVisibility()
        }
    }
    public var maximumDate: Date? {
        didSet {
            guard let maximumDate = maximumDate else {
                return
            }
            let maximumDateComponents = calendar.dateComponents([.day, .month, .year], from: maximumDate)
            self.maximumDate = calendar.date(from: maximumDateComponents)
            headerView.toggleChevronsVisibility()
        }
    }
    public var baseDate = Date() {
        didSet {
            days = generateDaysInMonth(for: baseDate)
            setupCollectionHeight()
            headerView.baseDate = baseDate
            DispatchQueue.main.async { [weak self] in
                self?.collectionView.reloadData()
            }
        }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    func setupView() {
        collectionView.backgroundColor = .VFGWhiteBackground
        backgroundColor = superview?.backgroundColor
        setupCollectionHeight()

        addSubview(collectionView)
        addSubview(headerView)

        var constraints = [
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionViewTrailingAnchor,
            collectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            collectionViewHeightAnchor
        ]

        constraints.append(contentsOf: [
            headerView.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor),
            headerViewTrailingAnchor,
            headerView.topAnchor.constraint(equalTo: topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: headerHeight)
        ])

        NSLayoutConstraint.activate(constraints)

        collectionView.register(
            VFGDatePickerCollectionViewCell.self,
            forCellWithReuseIdentifier: VFGDatePickerCollectionViewCell.reuseIdentifier
        )

        collectionView.dataSource = self
        collectionView.delegate = self
        headerView.baseDate = baseDate
    }

    private func setupCollectionHeight() {
        collectionViewHeightAnchor.constant = CGFloat(cellHeight * numberOfWeeksInBaseDate) +
            collectionView.layoutMargins.top * CGFloat(numberOfWeeksInBaseDate)
        layoutIfNeeded()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        adjustCollectionViewWidthIfNeeded()
    }

    public func reloadData() {
        days = generateDaysInMonth(for: baseDate)
        collectionView.reloadData()
    }
}

public enum VFGDatePickerMode {
    case singleSelection
    case rangeSelection
}
