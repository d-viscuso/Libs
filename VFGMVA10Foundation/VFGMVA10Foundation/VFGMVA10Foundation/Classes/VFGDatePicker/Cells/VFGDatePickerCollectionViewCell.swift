//
//  VFGDatePickerCollectionViewCell.swift
//  VFGMVA10Foundation
//
//  Created by Yahya Saddiq on 13/09/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

public class VFGDatePickerCollectionViewCell: UICollectionViewCell {
    weak var appearance: VFGDatePickerAppearance?

    var rangeSelectionWidthConstraint = NSLayoutConstraint()
    lazy var rangeSelectionLeadingConstraint = rangeSelectionBackgroundView.leadingAnchor.constraint(
        equalTo: safeAreaLayoutGuide.leadingAnchor
    )
    lazy var rangeSelectionTrailingConstraint = rangeSelectionBackgroundView.trailingAnchor.constraint(
        equalTo: safeAreaLayoutGuide.trailingAnchor
    )

    public lazy var todayBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.VFGWhiterAquaBackground.cgColor
        return view
    }()

    public lazy var selectionBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.backgroundColor = .VFGWhiterAquaBackground
        return view
    }()

    public lazy var rangeSelectionBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.backgroundColor = .VFGFilterUnselectedBgTwo
        return view
    }()

    public lazy var numberLabel: VFGLabel = {
        let label = VFGLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.vodafoneRegular(14.6)
        label.textColor = .VFGPrimaryText
        return label
    }()

    public lazy var accessibilityDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.setLocalizedDateFormatFromTemplate("EEEE, MMMM d")
        return dateFormatter
    }()

    public var day: VFGDay? {
        didSet {
            guard let day = day else { return }

            isHidden = day.isHidden
            numberLabel.text = day.number
            numberLabel.accessibilityIdentifier = "DPCnumberLabel_\(day.number)"
            accessibilityLabel = accessibilityDateFormatter.string(from: day.date)
            updateSelectionStatus()
        }
    }

    var isEnabled = true {
        didSet {
            if !isEnabled {
                appearance?.applyDisabledStyle(for: self)
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        isAccessibilityElement = true
        accessibilityTraits = .button

        contentView.addSubview(rangeSelectionBackgroundView)
        contentView.addSubview(selectionBackgroundView)
        contentView.addSubview(todayBackgroundView)
        contentView.addSubview(numberLabel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        removeConstraint(rangeSelectionWidthConstraint)
        selectionBackgroundView.removeConstraints(selectionBackgroundView.constraints)
        todayBackgroundView.removeConstraints(todayBackgroundView.constraints)

        rangeSelectionWidthConstraint = rangeSelectionBackgroundView.widthAnchor.constraint(
            equalTo: widthAnchor,
            multiplier: selectionBackgroundViewWidthMultiplier
        )

        NSLayoutConstraint.activate([
            numberLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            numberLabel.centerXAnchor.constraint(equalTo: centerXAnchor),

            selectionBackgroundView.centerYAnchor.constraint(equalTo: numberLabel.centerYAnchor),
            selectionBackgroundView.centerXAnchor.constraint(equalTo: numberLabel.centerXAnchor),
            selectionBackgroundView.widthAnchor.constraint(equalToConstant: frame.height),
            selectionBackgroundView.heightAnchor.constraint(equalTo: selectionBackgroundView.widthAnchor),

            rangeSelectionBackgroundView.centerYAnchor.constraint(equalTo: centerYAnchor),
            rangeSelectionBackgroundView.heightAnchor.constraint(equalTo: selectionBackgroundView.widthAnchor),
            rangeSelectionWidthConstraint,

            todayBackgroundView.centerYAnchor.constraint(equalTo: numberLabel.centerYAnchor),
            todayBackgroundView.centerXAnchor.constraint(equalTo: numberLabel.centerXAnchor),
            todayBackgroundView.widthAnchor.constraint(equalToConstant: frame.height),
            todayBackgroundView.heightAnchor.constraint(equalTo: todayBackgroundView.widthAnchor)
        ])

        selectionBackgroundView.layer.cornerRadius = frame.height / 2
        todayBackgroundView.layer.cornerRadius = frame.height / 2
    }

    var selectionBackgroundViewWidthMultiplier: CGFloat {
        if day?.isFirstSelected ?? false {
            rangeSelectionTrailingConstraint.isActive = true
            rangeSelectionLeadingConstraint.isActive = false
            return 0.56
        } else if day?.isLastSelected ?? false {
            rangeSelectionLeadingConstraint.isActive = true
            rangeSelectionTrailingConstraint.isActive = false
            return 0.56
        } else {
            rangeSelectionLeadingConstraint.isActive = false
            rangeSelectionTrailingConstraint.isActive = false
            return 1
        }
    }
}

// MARK: - Appearance
extension VFGDatePickerCollectionViewCell {
    func updateSelectionStatus() {
        guard let day = day else { return }

        if day.isWithinSelectedRange {
            appearance?.applySelectedRangeStyle(for: self)
        } else if day.isFirstSelected {
            appearance?.applySelectedStyle(for: self)
        } else if day.isToday {
            appearance?.applyTodayStyle(for: self)
        } else if !day.isWithinMinMax {
            appearance?.applyDisabledStyle(for: self)
        } else {
            appearance?.applyDefaultStyle(for: self)
        }
    }

    var isSmallScreenSize: Bool {
        let isCompact = traitCollection.horizontalSizeClass == .compact
        let smallWidth: CGFloat = 350
        let isSmallWidth = UIScreen.main.bounds.width <= smallWidth
        let isWidthGreaterThanHeight = UIScreen.main.bounds.width > UIScreen.main.bounds.height

        return isCompact && (isSmallWidth || isWidthGreaterThanHeight)
    }
}
