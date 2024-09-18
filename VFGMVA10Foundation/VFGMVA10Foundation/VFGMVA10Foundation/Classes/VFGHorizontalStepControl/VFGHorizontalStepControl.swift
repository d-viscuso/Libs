//
//  VFGHorizontalStepControl.swift
//  VFGMVA10Foundation
//
//  Created by Yahya Saddiq on 8/25/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

/// A step control view is a UI component that displays a horizontal series of connected dots with titles, each of which should correspond to a view (or many) in your app.
/// The Step control advances only one step in either directions(left or right) programmatically or multiple steps backward on a passed dot touch.
open class VFGHorizontalStepControl: UIView {
    private(set) public var currentStepIndex = 0
    private let minNumberOfStepsPerScreen = 4
    lazy private var steps: [String] = {
        loadStepsData()
    }()

    lazy private(set) var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .top
        stackView.distribution = .fillEqually

        return stackView
    }()
    private let scrollView = UIScrollView()
    private var stepsWidthConstraints: [NSLayoutConstraint] = []
    /// The object that acts as the delegate of the horizontal step control of type *VFGHorizontalStepControlDelegate*.
    public weak var delegate: VFGHorizontalStepControlDelegate?
    /// The object that acts as the data source of the horizontal step control of type *VFGHorizontalStepControlDataSource*.
    public weak var dataSource: VFGHorizontalStepControlDataSource? {
        didSet {
            load()
        }
    }

    /// A method that is used to update the stepper view configuration and style by changing the current step state to completed and move the next step.
    /// The right separator and dot colors will change based on the state.
    @IBAction public func complete() {
        guard currentStepIndex < stackView.subviews.count else {
            return
        }

        var stepView = (stackView.subviews[currentStepIndex] as? VFGStepView)
        stepView?.updateUI(with: .complete)

        delegate?.stepControl(self, didCompleteStepAt: currentStepIndex)

        guard currentStepIndex + 1 < stackView.subviews.count else {
            return
        }
        currentStepIndex += 1

        stepView = (stackView.subviews[currentStepIndex] as? VFGStepView)
        stepView?.previousStepAction = .complete

        stepView?.updateUI(
            with: .inProgress,
            nextStepStatus: currentStepIndex + 1 < numberOfSteps() ?
                dataSource?.status(self, forStepAt: currentStepIndex + 1) : .pending)
        scrollIfNeeded()

        delegate?.stepControl(self, didMoveToStepAt: currentStepIndex)
    }

    /// A method that is used to update the stepper view configuration and style by changing the current step state to skipped and move to the next step.
    /// The right separator and dot colors will change based on the state.
    @IBAction public func skip() {
        guard currentStepIndex < stackView.subviews.count else {
            return
        }

        var stepView = (stackView.subviews[currentStepIndex] as? VFGStepView)
        stepView?.updateUI(with: .skip)

        delegate?.stepControl(self, didSkipStepAt: currentStepIndex)

        guard currentStepIndex + 1 < stackView.subviews.count else {
            return
        }

        currentStepIndex += 1

        stepView = (stackView.subviews[currentStepIndex] as? VFGStepView)
        stepView?.previousStepAction = .skip
        stepView?.updateUI(with: .inProgress)
        scrollIfNeeded()

        delegate?.stepControl(self, didMoveToStepAt: currentStepIndex)
    }

    /// A method that is used to update the stepper view configuration and style by changing the current step state to pending again and return back to previous step.
    /// The left separator and dot colors will change based on the state.
    @IBAction public func previous() {
        guard currentStepIndex - 1 >= 0 else {
            return
        }

        var stepView = (stackView.subviews[currentStepIndex] as? VFGStepView)
        stepView?.updateUI(with: .pending)

        currentStepIndex -= 1

        stepView = (stackView.subviews[currentStepIndex] as? VFGStepView)
        stepView?.updateUI(with: .inProgress)
        scrollIfNeeded()

        delegate?.stepControl(self, didReturnToStepAt: currentStepIndex)
    }

    /// A method that is used to update the stepper view configuration and style by keeping the state of the current and all the previous steps till the step at given index which is changed to inProgress.
    /// - Parameter stepIndex: An index that indicates the step corresponds to it.
    public func back(to stepIndex: Int) {
        (stepIndex...currentStepIndex).forEach { index in
            if let stepStatus = index == stepIndex ? .inProgress : dataSource?.status(self, forStepAt: index) {
                (stackView.subviews[safe: index] as? VFGStepView)?.updateUI(
                    with: stepStatus,
                    nextStepStatus: index + 1 < numberOfSteps() ?
                        dataSource?.status(self, forStepAt: index + 1) : .pending )
                    }
        currentStepIndex = stepIndex
        scrollIfNeeded()
        delegate?.stepControl(self, didReturnToStepAt: stepIndex)
        }
    }

    /// A method that is used to update the stepper view configuration and style by keeping the state of the current and all the next steps till the step at given index which is changed to inProgress.
    /// /// - Parameter stepIndex: An index that indicates the step corresponds to it.
    public func forward(to stepIndex: Int) {
        (currentStepIndex...stepIndex).forEach { index in
            if let stepStatus = index == stepIndex ? .inProgress : dataSource?.status(self, forStepAt: index) {
                (stackView.subviews[safe: index] as? VFGStepView)?.updateUI(
                    with: stepStatus,
                    nextStepStatus: index + 1 < numberOfSteps() ?
                        dataSource?.status(self, forStepAt: index + 1) : .pending)
                }
        }
        currentStepIndex = stepIndex
        scrollIfNeeded()
        delegate?.stepControl(self, didMoveToStepAt: stepIndex)
    }

    private func scrollIfNeeded() {
        let currentStep = stackView.subviews[currentStepIndex]
        let currentStepFrame = currentStep.convert(currentStep.bounds, to: superview)
        let superViewFrame = superview?.frame ?? .zero

        // Scroll to hidden part from the right side
        if currentStepFrame.maxX > superViewFrame.width {
            UIView.animate(withDuration: 0.5) { [weak self] in
                guard let self = self else { return }
                self.scrollView.contentOffset.x +=
                    currentStepFrame.maxX - superViewFrame.width
            }
        }

        // Scroll to hidden part from the left side
        if currentStepFrame.minX < superViewFrame.minX {
            UIView.animate(withDuration: 0.5) { [weak self] in
                guard let self = self else { return }
                self.scrollView.contentOffset.x -=
                    superViewFrame.minX - currentStepFrame.minX
            }
        }
    }

    /// A method that is used to update the stepper view configuration and style by reset the state of all steps except for the current step which will be inProgress.
    public func reset() {
        (currentStepIndex..<stackView.subviews.count).forEach { index in
            if let stepStatus = dataSource?.status(self, forStepAt: index) {
                (stackView.subviews[safe: index] as? VFGStepView)?.updateUI(
                    with: index == currentStepIndex ? .inProgress : stepStatus,
                    nextStepStatus: index + 1 < numberOfSteps() ?
                        dataSource?.status(self, forStepAt: index + 1) : .pending,
                    previousStepStatus: index - 1 >= 0 ?
                        dataSource?.status(self, forStepAt: index - 1) : .pending
                )
            }
        }
    }
}

extension VFGHorizontalStepControl {
    /// A method that is used to reload whole stepper view.
    public func reload() {
        if !stackView.subviews.isEmpty,
            stackView.subviews.count < numberOfSteps() {
            (stackView.subviews[stackView.subviews.count - 1] as? VFGStepView)?.updateUI(with: .link)
        }

        load()
    }

    private func load() {
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        if numberOfSteps() > minNumberOfStepsPerScreen {
            embedInScrollView()
        } else {
            embed(view: stackView)
        }

        for index in stackView.subviews.count..<numberOfSteps() {
            guard let stepView: VFGStepView = .loadXib(bundle: .foundation) else {
                return
            }

            stepView.setup(
                with: stepTitle(at: index),
                isFirstStep: index == 0,
                isLastStep: index == numberOfSteps() - 1,
                isInteractionEnabled: dataSource?.isInteractionEnabled ?? true)

            stepView.onStepDidPress = { [weak self] in
                guard let self = self else { return }
                if index > self.currentStepIndex {
                    self.forward(to: index)
                } else {
                    self.back(to: index)
                }
            }

            stackView.addArrangedSubview(stepView)

            delegate?.stepControl(self, didAddStepAt: index)
        }

        stackView.layoutIfNeeded()
        let stepWidth = stackView.arrangedSubviews.first?.frame.width ?? 80
        stackView.arrangedSubviews.forEach {
            stepsWidthConstraints.append($0.widthAnchor.constraint(greaterThanOrEqualToConstant: stepWidth))
        }
        NSLayoutConstraint.activate(stepsWidthConstraints)
        stackView.distribution = .fill
    }

    private func numberOfSteps() -> Int {
        if dataSource != nil,
            let dataSource = dataSource {
            return dataSource.numberOfSteps(self)
        } else {
            return steps.count
        }
    }

    private func stepTitle(at index: Int) -> String {
        if dataSource != nil,
            let dataSource = dataSource {
            return dataSource.title(self, forStepAt: index)
        } else {
            return steps[index]
        }
    }

    func loadStepsData() -> [String] {
        if let stepsFileURL = dataSource?.stepsDataURL(self) {
            do {
                let data = try Data(contentsOf: stepsFileURL, options: .mappedIfSafe)
                let decoder = JSONDecoder()
                guard let result = try? decoder.decode([String: [String]].self, from: data),
                    let steps = result["steps"] else {
                        VFGErrorLog("Failed to load steps from JSON file")
                        return []
                }

                return steps
            } catch {
                VFGErrorLog(error.localizedDescription)
            }
        }

        return []
    }

    private func embedInScrollView() {
        scrollView.isScrollEnabled = dataSource?.isInteractionEnabled ?? true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        embed(view: scrollView)
        scrollView.embed(view: stackView)
        stackView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        stackView.layoutIfNeeded()
    }
}
