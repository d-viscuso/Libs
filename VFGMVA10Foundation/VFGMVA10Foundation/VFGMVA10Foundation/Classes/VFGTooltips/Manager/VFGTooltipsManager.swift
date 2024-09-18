//
//  VFGTooltipsManager.swift
//  VFGMVA10Group
//
//  Created by Yahya Saddiq on 16/01/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

/// Manages a list of Tooltips that provided through VFGTooltipsManagerDataSource
public class VFGTooltipsManager {
    private var tooltip: VFGTooltips?
    private var currentTooltipNumber = 0
    private let interactionBlockerView = UIView(frame: UIScreen.main.bounds)
    private let superview: UIView?
    var tooltipCardView: VFGTooltipCardView?

    /// Tooltips manager datasource
    public weak var dataSource: VFGTooltipsManagerDataSource?
    /// Tooltips manager delegate
    public weak var delegate: VFGTooltipsManagerDelegate?

    /// Tooltips manager initializer
    /// - Parameter superview:The superview of the target views,
    /// if superview is not provided, the first app's window will be used as superview.
    public init(superview: UIView? = nil) {
        self.superview = superview
    }

    /// Starts showing tooltips.
    /// You must implement VFGTooltipsManagerDataSource to display tooltips.
    public func showNextTooltip() {
        guard
            let tooltipItem = dataSource?.tooltipItem(of: currentTooltipNumber + 1),
            let numberOfTooltips = dataSource?.numberOfTooltips() else {
            tooltipsDidComplete()
            return
        }

        guard let target = tooltipItem.target else {
            VFGInfoLog("The supplied target parameter for \(tooltipItem.title) is nil.")
            tooltipsDidComplete()
            return
        }

        currentTooltipNumber += 1

        if currentTooltipNumber == 1 {
            if superview == nil {
                UIApplication.shared.windows.first?.addSubview(self.interactionBlockerView)
            } else {
                superview?.addSubview(self.interactionBlockerView)
            }
        }

        tooltipView(
            for: tooltipItem, numberOfTooltips
        )?.show(
            animated: false,
            forView: target,
            onFrame: tooltipItem.targetFrame,
            withinSuperview: superview
        )
        tooltipItem.action?()
    }

    private func tooltipView(for tooltipItem: VFGTooltipItem, _ numberOfTooltips: Int) -> VFGTooltips? {
        tooltipCardView = UIView.loadXib(bundle: .foundation)
        guard let tooltipCardView = tooltipCardView else {
            return nil
        }
        checkVisibilityOfDismissAllButton(numberOfTooltips)

        tooltip = VFGTooltips(
            contentView: tooltipCardView,
            preferences: tooltipItem.preferences ?? VFGTooltips.globalPreferences,
            delegate: self)

        tooltipCardView.configure(
            tooltipItem: tooltipItem,
            tooltipNumber: currentTooltipNumber,
            numberOfTooltips: numberOfTooltips
        )

        if tooltipCardView.onButtonPress == nil {
            tooltipCardView.onButtonPress = { [weak self] in
                guard let self = self else {
                    return
                }

                self.showNextTooltip()
            }
        }

        tooltipCardView.onDismiss = { [weak self] in
            guard let self = self else {
                return
            }

            self.tooltip?.dismiss { [weak self] in
                self?.showNextTooltip()
            }

            self.delegate?.tooltipDidComplete(self.currentTooltipNumber)
            if self.currentTooltipNumber == numberOfTooltips {
                self.tooltipsDidComplete()
            }
        }

        tooltipCardView.onDismissAll = { [weak self] in
            guard let self = self else {
                return
            }
            self.dismissAllTooltips()
        }
        return tooltip
    }

    /// Ends tooltips journey, Call this method to hide tooltips if there's an error occur during data loading
    public func endTooltipsJourney() {
        tooltipsDidComplete()
        tooltip?.dismiss(withCompletion: nil)
    }

    private func tooltipsDidComplete() {
        interactionBlockerView.removeFromSuperview()
        delegate?.tooltipsDidComplete()
    }

    private func dismissAllTooltips() {
        tooltip?.dismiss()
        interactionBlockerView.removeFromSuperview()
        delegate?.tooltipDimissAllButtonDidTap()
    }

    private func checkVisibilityOfDismissAllButton(_ numberOfTooltips: Int) {
        if currentTooltipNumber == numberOfTooltips {
            tooltipCardView?.dismissAllButton.isHidden = true
            return
        }
        tooltipCardView?.dismissAllButton.isHidden = delegate?.isDismissAllButtonHidden ?? true
    }
}

extension VFGTooltipsManager: VFGTooltipsDelegate {
    public func tooltipViewDidTap(_ tipView: VFGTooltips) {
        delegate?.tooltipViewDidTap(currentTooltipNumber)
    }

    public func tooltipViewDidDismiss(_ tipView: VFGTooltips) {
        delegate?.tooltipViewDidDismiss(currentTooltipNumber)
    }
}
