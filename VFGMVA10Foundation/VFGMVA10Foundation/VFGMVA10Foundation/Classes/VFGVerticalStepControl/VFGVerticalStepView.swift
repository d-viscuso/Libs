//
//  VFGVerticalStepView.swift
//  VFGMVA10Foundation
//
//  Created by Sandra Morcos on 2/11/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import UIKit

/// A view that displays a vertical series of connected dots with titles, each of which should contains a view in your app.
/// The vertical step control advances only one step in either directions (up or down) programmatically or multiple steps backward on a passed step touch.
public class VFGVerticalStepView: UIView {
    @IBOutlet weak var tapButton: VFGButton!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var stateImageView: VFGImageView!
    @IBOutlet weak var titleLabel: VFGLabel!
    @IBOutlet weak var inProgressImageView: VFGImageView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var separator: UIView!
    @IBOutlet weak var separatorHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLabelTrailingConstrain: NSLayoutConstraint!
    var data: [String: Any]?
    weak var delegate: VFGVerticalStepViewDelegate?
    var isLastStep = false
    var isOnlyOneStep = false
    var shouldUpdateUI = true
    let fontSize: CGFloat = 18.7
    public var stepEntry: VFGStepViewEntry?
    var titleText = ""

    var action: VFGStepAction? {
        didSet {
            actionChanged()
        }
    }
    /// control title label trailing to avoid line break in case of Tobiless
    public func updateTitleTrailingConstrain(with constant: CGFloat) {
        titleLabelTrailingConstrain.constant = constant
    }

    private var stepNumber: Int = 0
    private var separatorLayer: CAShapeLayer?

    var animationDuration: Double = 0.25

    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }

    func xibSetup() {
        contentView = loadViewFromNib(nibName: "VFGVerticalStepView", in: .foundation)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(contentView)
    }

    private func setupContentView(view: VFGStepViewEntry?) {
        guard let stepView = view?.stepView else { return }
        let accessibilityID = ((stepView as? VFGStepViewEntry)?.stepView.accessibilityIdentifier ?? "")
        titleLabel.accessibilityIdentifier = accessibilityID + "Title"
        stackView.addArrangedSubview(stepView)
    }

    func setupStepView(
        isLastStep: Bool = false,
        isOnlyOneStep: Bool = false,
        stepNumber: Int,
        savedAction: VFGStepAction?
    ) {
        self.isLastStep = isLastStep
        self.isOnlyOneStep = isOnlyOneStep
        self.stepNumber = stepNumber
        action = savedAction
        setupAccessibility()
        guard isOnlyOneStep else { return }
        inProgressImageView?.isHidden = true
        stateImageView?.isHidden = true
    }

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if #available(iOS 13.0, *) {
            if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
                actionChanged()
            }
        }
    }

    private func setupCompleteImageView() {
        stateImageView?.isHidden = isOnlyOneStep
        stateImageView?.backgroundColor = .VFGStepControlSeparatorInProgress
        inProgressImageView?.isHidden = true
    }

    private func setupInProgressImageView() {
        stateImageView?.backgroundColor = .VFGStepControlSeparatorSkipAction
        inProgressImageView?.isHidden = isOnlyOneStep
        stateImageView?.isHidden = true
    }

    private func setupSkipImageView() {
        stateImageView?.isHidden = isOnlyOneStep
        stateImageView?.backgroundColor = .VFGStepControlSeparatorSkipAction
        stateImageView?.contentMode = .center
        inProgressImageView?.isHidden = true
    }

    private func setupTitleLabel() {
        titleText = stepEntry?.title ?? ""
        titleLabel.text = titleText
        titleLabel.textColor = .VFGSecondaryText
    }

    private func setupStateTitleLabel() {
        titleLabel.textColor = .VFGPrimaryText
        titleLabel.font = .vodafoneRegular(fontSize)
    }

    func setupSeparator(imageView: VFGImageView, strokeColor: CGColor) {
        guard !isLastStep, !isOnlyOneStep else { return }
        separatorLayer?.removeFromSuperlayer()
        separatorLayer = CAShapeLayer()
        guard let separatorLayer = separatorLayer else {
            return
        }
        separatorLayer.strokeColor = strokeColor
        separatorLayer.lineWidth = 1
        layoutIfNeeded()
        let path = CGMutablePath()

        guard let boundMaxY = subviews.last?.bounds.maxY else {
            return
        }
        let frameMaxY = stepEntry?.stepView.frame.maxY ?? 0
        let maxY = boundMaxY + frameMaxY
        let point1 = CGPoint(x: 0, y: imageView.frame.maxY - 1)
        let point2 = CGPoint(x: 0, y: maxY)
        path.addLines(between: [point1, point2])
        separatorLayer.path = path
        separator.layer.addSublayer(separatorLayer)
        separatorHeightConstraint.constant = maxY
    }

    /// A method that is used to trigger step navigation causing a change in the current step's status to pending and reset the previous one to in-progress.
    /// - Parameter animationCompletion: A closure that is invoked once the animation to previous step is finished.
    func previousAction(animationCompletion: (() -> Void)? = nil) {
        setupSkipImageView()
        UIView.animate(withDuration: animationDuration, animations: {
            self.stepTransparency(show: false)
        }, completion: { [weak self]_ in
            guard let self = self else {
                return
            }
            self.updateStepUI(color: .VFGStepControlSeparatorSkipAction)
            guard let animationCompletion = animationCompletion else { return }
            animationCompletion()
        })
    }

    /// A method that is used to trigger step navigation causing a change in the current step's status to in-progress.
    /// - Parameter animationCompletion: A closure that is invoked once the animation is finished.
    func inProgressAction(animationCompletion: (() -> Void)? = nil) {
        setupContentView(view: self.stepEntry)
        stepEntry?.stepView.alpha = 0
        let duration = stepNumber == 0 ? 0 : animationDuration
        UIView.animate(withDuration: duration, animations: {
            self.stepTransparency(show: true)
        }, completion: { [weak self]_ in
            guard let self = self else { return }
            self.layoutSubviews()
            self.setupInProgressImageView()
            self.titleLabel.textColor = UIColor.VFGPrimaryText
            self.titleLabel.font = .vodafoneBold(self.fontSize)
            if #available(iOS 13.0, *) {
                self.setupSeparator(
                    imageView: self.inProgressImageView,
                    strokeColor: UIColor.VFGStepControlSeparatorSkipAction.resolvedColor(with:
                        self.traitCollection).cgColor)
            } else {
                self.setupSeparator(
                    imageView: self.inProgressImageView,
                    strokeColor: UIColor.VFGStepControlSeparatorSkipAction.cgColor)
            }
            guard let animationCompletion = animationCompletion else { return }
            animationCompletion()
        })
    }

    /// A method that is used to trigger step navigation causing a change by completing the currently viewed step and step forward.
    /// - Parameter animationCompletion: A closure that is invoked once the animation to next step is finished.
    func completeAction(animationCompletion: (() -> Void)? = nil) {
        setupCompleteImageView()
        tapButton.accessibilityLabel = "\(titleText), step. Completed"
        UIView.animate(withDuration: animationDuration, animations: {
            self.stepTransparency(show: false)
        }, completion: { [weak self] _ in
            guard let self = self else { return }
            if #available(iOS 13.0, *) {
                self.updateStepUI(color: UIColor.VFGStepControlSeparatorInProgress.resolvedColor(with:
                    self.traitCollection))
            } else {
                self.updateStepUI(color: UIColor.VFGStepControlSeparatorInProgress)
            }
            guard let animationCompletion = animationCompletion else { return }
            animationCompletion()
        })
    }

    /// A method that is used to trigger step navigation causing a change by skipping to the next step and step forward.
    /// - Parameter animationCompletion: A closure that is invoked once the animation to next step is finished.
    func skipAction(animationCompletion: (() -> Void)? = nil) {
        setupSkipImageView()
        tapButton.accessibilityLabel = "\(titleText), step. Skipped"
        UIView.animate(withDuration: animationDuration, animations: {
            self.stepTransparency(show: false)
        }, completion: { [weak self]_ in
            guard let self = self else { return }
            self.updateStepUI(color: UIColor.VFGStepControlSeparatorSkipAction)
            guard let animationCompletion = animationCompletion else { return }
            animationCompletion()
        })
    }

    /// A method that is used to trigger step navigation causing a change in the current step's status to ready.
    func readyAction() {
        setupSeparator(imageView: stateImageView, strokeColor: UIColor.VFGStepControlSeparatorSkipAction.cgColor)
        stateImageView?.backgroundColor = .VFGStepControlSeparatorSkipAction
    }

    /// A method that is used to update the step to appear as unvisited.
    func markUnVisited() {
        skipAction()
        setupTitleLabel()
        titleLabel.font = .vodafoneRegular(fontSize)
        shouldUpdateUI = false
        action = nil
    }

    @IBAction func tapButtonDidPress(_ sender: VFGButton) {
        delegate?.didPress(at: stepNumber)
    }

    private func stepTransparency(show: Bool) {
        let alpha: CGFloat = show ? 1 : 0
        stepEntry?.stepView.alpha = alpha
        stepEntry?.stepView.isHidden = !show
    }

    private func updateStepUI(color: UIColor) {
        stepEntry?.stepView.removeFromSuperview()
        setupStateTitleLabel()
        if #available(iOS 13.0, *) {
            setupSeparator(
                imageView: self.stateImageView,
                strokeColor: color.resolvedColor(with:
                    self.traitCollection).cgColor)
        } else {
            setupSeparator(imageView: self.stateImageView, strokeColor: color.cgColor)
        }
    }

    private func actionChanged() {
        if !shouldUpdateUI {
            shouldUpdateUI = true
            return
        }
        setupTitleLabel()
        stepEntry?.data = data
        switch action {
        case nil:
            readyAction()
        case .start:
            inProgressAction()
        case .complete:
            completeAction()
        case .skip:
            skipAction()
        case .returnToPreviousStep:
            previousAction()
        case .link: break
        }
    }
}
