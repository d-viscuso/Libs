//
//  CounterView.swift
//  VFGMVA10Foundation
//
//  Created by Ahmed AbdElnabi on 15/06/2022.
//

import UIKit

public class VFGCountdownView: UIView {
    @IBOutlet var contentView: UIView?
    @IBOutlet weak var daysLabel: VFGLabel!
    @IBOutlet weak var daysTextLabel: VFGLabel!
    @IBOutlet weak var hoursLabel: VFGLabel!
    @IBOutlet weak var hoursTextLabel: VFGLabel!
    @IBOutlet weak var minutesLabel: VFGLabel!
    @IBOutlet weak var minutesTextLabel: VFGLabel!
    @IBOutlet weak var secondsLabel: VFGLabel!
    @IBOutlet weak var secondsTextLabel: VFGLabel!
    @IBOutlet var separatorViews: [UIView]!
    @IBOutlet var numberLabels: [VFGLabel]!
    @IBOutlet var textLabels: [VFGLabel]!

    var timerManager: VFGTimerManager?

    public weak var delegate: VFGCountdownDelegate?
    public weak var dataSource: VFGCountdownDataSource? {
        didSet {
            guard let dataSource = dataSource else {
                return
            }
            timerManager?.countDownTime = dataSource.countdownTime(self)
            timerManager?.effectiveValue = dataSource.effectiveValue(self)
            timerManager?.defaultValue = dataSource.defaultCountdownTime(self)
            timerManager?.timeInterval = dataSource.timeInterval(self)
            daysTextLabel.text = dataSource.daysText(self)
            hoursTextLabel.text = dataSource.hoursText(self)
            minutesTextLabel.text = dataSource.minutesText(self)
            secondsTextLabel.text = dataSource.secondsText(self)
        }
    }
    public weak var appearance: VFGCountdownAppearance? {
        didSet {
            setupSeparatorAppearance()
            setupNumberLabelsAppearance()
            setupTextLabelsAppearance()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
        setup()
    }

    private func xibSetup() {
        let bundle = Bundle.foundation
        loadViewFromNib(nibName: "VFGCountdownView", in: bundle)
        xibSetup(contentView: contentView ?? UIView())
    }

    private func setup() {
        uiSetup()
        countdownSetup()
    }

    private func uiSetup() {
        appearance = appearance == nil ? self : appearance
        setupSeparatorAppearance()
        setupNumberLabelsAppearance()
        setupTextLabelsAppearance()
    }

    private func countdownSetup() {
        timerManager = VFGTimerManager()
        observeState()
        observeTime()
    }

    private func setupSeparatorAppearance() {
        separatorViews.forEach { separator in
            appearance?.applyCountdownSeparatorStyle(self, for: separator)
        }
    }

    private func setupNumberLabelsAppearance() {
        numberLabels.forEach { label in
            appearance?.applyTimeNumberLabelStyle(self, for: label)
        }
    }

    private func setupTextLabelsAppearance() {
        textLabels.forEach { label in
            appearance?.applyTimeTextLabelStyle(self, for: label)
        }
    }

    private func observeState() {
        timerManager?.didStateChange = { [weak self] state in
            guard let self = self else { return }
            self.delegate?.countdown(self, stateDidChange: state)
        }
    }

    private func observeTime() {
        timerManager?.observeElapsedTime = { [weak self] timeInterval in
            guard let self = self else { return }
            self.delegate?.countdown(self, countdownTimeDidChange: timeInterval)
            self.updateTimer(with: timeInterval)
        }
    }

    private func updateTimer(with timeInterval: TimeInterval) {
        let days = Int(timeInterval) / 86400
        let hours = Int(timeInterval) / 3600 % 24
        let minutes = Int(timeInterval) / 60 % 60
        let seconds = Int(timeInterval) % 60

        self.daysLabel.text = String(format: "%02i", days)
        self.hoursLabel.text = String(format: "%02i", hours)
        self.minutesLabel.text = String(format: "%02i", minutes)
        self.secondsLabel.text = String(format: "%02i", seconds)
    }

    public func startCounting() {
        timerManager?.start()
    }

    public func stopCounting() {
        timerManager?.stop()
    }

    public func reset() {
        updateTimer(with: 0)
        timerManager?.reset()
    }

    public func resetToDefault() {
        updateTimer(with: timerManager?.defaultValue ?? 0)
        timerManager?.resetToDefault()
    }
}

extension VFGCountdownView: VFGCountdownAppearance {}
