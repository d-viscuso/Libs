//
//  VFGReferAFriendSuccessViewController.swift
//  VFGReferAFriend
//
//  Created by Mustafa Güneş on 29.01.2021.
//

import UIKit
import VFGMVA10Foundation

public class VFGReferAFriendSuccessViewController: UIViewController {
    // MARK: - DI
    @LazyInjected public var viewModel: VFGReferAFriendSuccessViewModelProtocol?
    @LazyInjected public var referAFriendViewController: VFGReferAFriendViewController?

    // MARK: - Outlets
    @IBOutlet weak var headerLabel: VFGLabel!
    @IBOutlet weak var titleLabel: VFGLabel!
    @IBOutlet weak var descLabel: VFGLabel!
    @IBOutlet weak var closeButton: VFGButton!
    @IBOutlet weak var referralsButton: VFGButton!
    @IBOutlet weak var returnToDashboardButton: VFGButton!
    @IBOutlet weak var notchedTop: NSLayoutConstraint!

    public init() {
        super.init(nibName: VFGReferAFriendConstants.NibName.referAFriendSuccess, bundle: .mva10Framework)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override open func viewDidLoad() {
        super.viewDidLoad()
        setConfigurations()
        VFGReferAFriendSuccessViewModel.trackView(pageName: VFGReferAFriendSuccessViewModel.journeyType)
    }

    private func setConfigurations() {
        setLayoutData()
        reConfiguredConstraints()
    }

    private func reConfiguredConstraints() {
        switch UIScreen.screenHasNotch {
        case false:
            notchedTop.constant = 30
        default: break
        }
    }

    private func setLayoutData() {
        headerLabel.text = "refer_a_friend_successful_referral_title".localized(bundle: .mva10Framework)
        let referralsButtonTitle = "refer_a_friend_refer_more_friends_button".localized(bundle: .mva10Framework)
        referralsButton.setTitle(referralsButtonTitle, for: .normal)
        let returnToDashboardTitle = "refer_a_friend_return_to_dashboard_button".localized(bundle: .mva10Framework)
        returnToDashboardButton.setTitle(returnToDashboardTitle, for: .normal)
        let titleText = "refer_a_friend_successful_referral_message".localized(bundle: .mva10Framework)
        let name = viewModel?.name ?? ""
        titleLabel.text = String(format: titleText, name)
        let descriptionText = "refer_a_friend_referral_message_description".localized(bundle: .mva10Framework)
        let description = viewModel?.description ?? ""
        let attributedDesc = String(format: descriptionText, description).boldify(subText: description, size: 17)
        descLabel.attributedText = attributedDesc

        let closeImage = VFGFrameworkAsset.Image.icClose?.withRenderingMode(.alwaysTemplate)
        closeButton.setImage(closeImage, for: .normal)
        closeButton.tintColor = .VFGGreyTint
    }

    private func closeController() {
        if isModal {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
}

// MARK: - Actions
extension VFGReferAFriendSuccessViewController {
    @IBAction func closeButtonPressed(_ sender: VFGButton) {
        closeController()
    }

    @IBAction func returnDashboardButtonPressed(_ sender: VFGButton) {
        closeController()
        let eventName = "analytics_framework_event_label_return_dashboard".localized(bundle: .mva10Framework)
        VFGReferAFriendSuccessViewModel.trackAction(
            event: eventName,
            eventLabel: eventName,
            pageName: VFGReferAFriendSuccessViewModel.journeyType
        )
    }

    @IBAction func referMoreButtonPressed(_ sender: VFGButton) {
        guard let referAFriendViewController = referAFriendViewController, let viewModel = viewModel else { return }
        referAFriendViewController.viewModel?.create(with: viewModel.referralsModel, inviteType: viewModel.inviteType)
        referAFriendViewController.modalPresentationStyle = .fullScreen
        present(referAFriendViewController, animated: true)
        let eventName = "analytics_framework_event_label_refer_more".localized(bundle: .mva10Framework)
        VFGReferAFriendSuccessViewModel.trackAction(
            event: eventName,
            eventLabel: eventName,
            pageName: VFGReferAFriendSuccessViewModel.journeyType
        )
    }
}
