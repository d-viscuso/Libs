//
//  VFPermissionsView.swift
//  VFGMVA10Group
//
//  Created by Mohamed Abd ElNasser on 6/29/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

/// Permissions view step in onBoarding.
public class VFPermissionsView: UIView, VFGStepViewEntry {
    public var sideView: UIView?
    public required init(config: [String: Any]?) {
        super.init(frame: CGRect.zero)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public var data: [String: Any]?
    public weak var stepEntryDelegate: VFGStepViewEntryDelegate?

    public var title: String?
    var viewModel: VFPermissionsViewModel?
    let cardHeight: CGFloat = 126
    let buttonHeight: CGFloat = 44
    let headerHeight: CGFloat = 93

    public var stepView: UIView {
        return self
    }

    @IBOutlet weak var titleLabel: VFGLabel!
    @IBOutlet weak var permissionsStackView: UIStackView!
    @IBOutlet weak var nextButton: VFGButton!

    /// *VFPermissionsView* data configuration.
    /// - Parameters:
    ///    - viewModel: *VFPermissionsViewModel*.
    public func configure(with viewModel: VFPermissionsViewModel) {
        self.viewModel = viewModel
        self.viewModel?.delegate = self
        title = viewModel.stepTitle
        titleLabel.text = viewModel.headerTitle
        configurePermissions()
        setupAccessibilityIds()
        nextButton.backgroundColor = viewModel.confirmationButtonColor
        nextButton.buttonStyle = 4 // to be custom
    }

    override public func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }

    func configureUI() {
        titleLabel.font = .vodafoneLite(25)
        nextButton.titleLabel?.font = .vodafoneRegular(16)
        nextButton.setTitle("permissions_button_title".localized(bundle: Bundle.mva10Framework), for: .normal)
    }
    func setupAccessibilityIds() {
        accessibilityIdentifier = "OBpermissionsStep"
        titleLabel.accessibilityIdentifier = "OBpermissionsStepDesc"
        nextButton.accessibilityIdentifier = "OBhappyButton"
    }

    func configurePermissions() {
        guard let permissionCards = viewModel?.permissionCards else {
            return
        }
        for (index, card) in permissionCards.enumerated() {
            addView(cardViewModel: card, at: index)

            // hide dependents if parent's status is false
            if let parentIndex = card.parentIndex,
            permissionCards[parentIndex].permissionStatus == .denied {
                hideView(at: index)
            }
        }
    }

    func addView(cardViewModel: VFPermissionCardViewModel, at index: Int) {
        guard let permissionCard: VFPermissionViewCard = UIView
            .loadXib(bundle: Bundle.mva10Framework) else { return }
        permissionCard.backgroundColor = .VFGWhiteBackgroundTwo
        permissionCard.accessibilityIdentifier = VFGPermissionTypeAccessibilityIdentifier
            .getPermissionCardId(type: cardViewModel.type)
        permissionCard.configureForOnboarding(
            with: cardViewModel,
            isFirstCell: index == 0)
        permissionsStackView.insertArrangedSubview(permissionCard, at: index)
    }

    @IBAction func onNextAction(_ sender: Any) {
        requestPermissions()
    }

    func requestPermissions(_ completion: (() -> Void)? = nil) {
        viewModel?.requestPermissions {
            let group = DispatchGroup()
            group.enter()
            DispatchQueue.global(qos: .background).async { [weak self] in
                guard let self = self else {
                    return
                }
                self.viewModel?.setPermissions()
                self.viewModel = nil
                group.leave()
            }
            group.enter()
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {
                    return
                }
                self.stepEntryDelegate?.stepEntry(self, action: .complete, data: ["": ""])

                group.leave()
            }
            group.notify(queue: .main) {
                // for testing purposes
                completion?()
            }
        }
    }
}

extension VFPermissionsView: VFPermissionViewModelProtocol {
    func hideView(at index: Int) {
        viewModel?.permissionCards[index].shouldRequestPermission = false
        switchViewState(isHidden: true, at: index)
    }

    func showView(at index: Int) {
        viewModel?.permissionCards[index].shouldRequestPermission = true
        switchViewState(isHidden: false, at: index)
    }

    private func switchViewState(isHidden: Bool, at index: Int) {
        guard let viewToShow = permissionsStackView.arrangedSubviews.first(where: { $0.tag == index })
            as? VFPermissionViewCard else {
                return
        }
        guard let viewModel = viewModel else {
            return
        }
        viewToShow.configureForOnboarding(
            with: viewModel.permissionCards[index],
            isFirstCell: index == 0)
        UIView.animate(
            withDuration: 0.3,
            animations: {
                viewToShow.isHidden = isHidden
                viewToShow.alpha = isHidden ? 0 : 1
            },
            completion: nil)
    }
}
