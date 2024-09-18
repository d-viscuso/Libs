//
//  VFGReferAFriendViewController.swift
//  VFGReferAFriend
//
//  Created by Mustafa Güneş on 13.01.2021.
//

import UIKit
import VFGMVA10Foundation

/// Refer a friend view controller.
public class VFGReferAFriendViewController: UIViewController {
    // MARK: - DI
    /// View model.
    @LazyInjected public var viewModel: VFGReferAFriendViewModelProtocol?
    /// Terms and conditions view controller.
    @LazyInjected public var termsViewController: VFGReferAFriendTermsViewController?

    // MARK: - Global Definitions
    /// Computed property returns the number of friends the user has referred.
    public final var refferalListCount: Int {
        return viewModel?.referralsModel?.promotionContent.referralList?.count ?? 0
    }

    // MARK: - Outlets
    @IBOutlet weak public var urlView: UIView!
    @IBOutlet weak public var urlLabel: VFGLabel!
    @IBOutlet weak public var backButton: VFGButton!
    @IBOutlet weak public var shareButton: VFGButton!
    @IBOutlet weak public var readTermsButtonContainer: UIView!
    @IBOutlet weak public var readTermsButtonContainerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak public var readTermsButton: VFGButton!
    @IBOutlet weak public var tableView: IntrinsicTableView!
    @IBOutlet weak private var titleLabel: VFGLabel!
    @IBOutlet weak private var mainImageView: VFGImageView!
    @IBOutlet weak private var campaignTitleLabel: VFGLabel!
    @IBOutlet weak private var campaignDescLabel: VFGLabel!
    @IBOutlet weak private var referralsView: UIView!
    @IBOutlet weak private var referralsLabel: VFGLabel!
    @IBOutlet weak private var referralsDescLabel: VFGLabel!

    let termsAndConditionsContainerHeight: CGFloat = 70
    public weak var lifeCycleDelegate: VFGReferAFriendLifeCycleProtocol?

    // MARK: - Init
    public init() {
        super.init(nibName: VFGReferAFriendConstants.NibName.referAFriend, bundle: .mva10Framework)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override open func viewDidLoad() {
        super.viewDidLoad()
        lifeCycleDelegate?.referAFriendViewDidLoad()
        setConfigurations()
        VFGReferAFriendViewModel.trackView(pageName: VFGReferAFriendViewModel.journeyType)
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lifeCycleDelegate?.referAFriendViewWillAppear(animated)
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        lifeCycleDelegate?.referAFriendViewDidAppear(animated)
    }

    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        lifeCycleDelegate?.referAFriendViewDidDisappear(animated)
    }

    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setConfigurationsUrlView()
    }

    private func setConfigurations() {
        setConfigurationsTableView()
        setViewData(with: viewModel?.referralsModel)
        setTableViewData(acticationCount: viewModel?.referralsModel?.promotionContent.activationCount ?? 0)
        setReferralsView(with: viewModel?.inviteType)
        addAccessibilityForVoiceOver()
    }

    private func setViewData(with model: VFGReferAFriendResponse?) {
        guard let promotionContent = model?.promotionContent else { return }
        let referralsCount = promotionContent.activationCount

        titleLabel.text = promotionContent.title
        campaignTitleLabel.text = promotionContent.subtitle
        campaignDescLabel.text = promotionContent.promotionContentDescription
        urlLabel.text = promotionContent.shortlink
        shareButton.setTitle(promotionContent.buttonText, for: .normal)
        let referralsText = "refer_a_friend_activation_count".localized(bundle: .mva10Framework)
        referralsLabel.text = String(format: referralsText, referralsCount.toString() ?? "0")
        referralsDescLabel.text = promotionContent.activationCountTxt

        if let termsAndConditionsTitle = model?.termsAndConditionsTitle,
            model?.isTermsAndConditionsVisible ?? true {
            readTermsButton.setUnderlinedTitle(
                title: termsAndConditionsTitle,
                font: .vodafoneRegular(16.6),
                color: .VFGPrimaryText,
                state: .normal)
            readTermsButtonContainerHeightConstraint.constant = termsAndConditionsContainerHeight
            readTermsButtonContainer.isHidden = false
        } else {
            readTermsButtonContainerHeightConstraint.constant = 0
            readTermsButtonContainer.isHidden = true
        }
        if let urlString = promotionContent.imageUrl, let url = URL(string: urlString) {
            mainImageView.download(from: url, placeholder: VFGFrameworkAsset.Image.placeholder)
        }
    }

    private func setTableViewData(acticationCount: Int) {
        guard acticationCount > 0 else { return }
        referralsDescLabel.isHidden = true
        tableView.roundCorners()
        tableView.isHidden = false
        tableView.reloadData()
    }

    private func setConfigurationsUrlView() {
        urlLabel.addLongPressMenuItems()
        urlView.addLineDashedStroke(pattern: [5, 2], radius: 6, color: .VFGSecondaryButtonOutline)
    }

    private func setConfigurationsTableView() {
        let nib = UINib(nibName: "VFGReferralsCell", bundle: .mva10Framework)
        tableView.register(nib, forCellReuseIdentifier: "VFGReferralsCell")

        tableView.dataSource = self
        tableView.delegate = self
    }

    private func setReferralsView(with inviteType: VFGReferAFriendInviteType?) {
        guard let inviteType = inviteType else { return }
        referralsView.isHidden = (inviteType == .shareMyApp)
    }

    public func shareCampaignURL() {
        guard let model = viewModel?.referralsModel?.promotionContent else { return }
        let shareComponents = [model.promotionLink]
        let activityViewController = UIActivityViewController(
            activityItems: shareComponents as [Any],
            applicationActivities: nil
        )
        activityViewController.popoverPresentationController?.sourceView = view
        present(activityViewController, animated: true, completion: nil)
    }
}

// MARK: - Button Actions
extension VFGReferAFriendViewController {
    @IBAction public func shareButtonPressed(_ sender: VFGButton) {
        shareAction()
        lifeCycleDelegate?.referAFriendShareButtonPressed()
        let event = "analytics_framework_event_label_share".localized(bundle: .mva10Framework)
        VFGReferAFriendViewModel.trackAction(
            event: event,
            eventLabel: event,
            pageName: VFGReferAFriendViewModel.journeyType
        )
    }
    @objc public func shareAction() {
        shareCampaignURL()
    }

    @IBAction public func readTermsButtonPressed(_ sender: VFGButton) {
        readTermsAction()
        lifeCycleDelegate?.referAFriendReadTermsButtonPressed()
        let event = "analytics_framework_event_label_read_terms".localized(bundle: .mva10Framework)
        VFGReferAFriendViewModel.trackAction(
            event: event,
            eventLabel: event,
            pageName: VFGReferAFriendViewModel.journeyType
        )
    }
    @objc public func readTermsAction() {
        guard
            let termsAndConditions = viewModel?.referralsModel?.promotionContent.termsAndConditions
        else {
            return
        }

        if let url = URL(string: termsAndConditions), UIApplication.shared.canOpenURL(url) {
            let viewModel = VFGWebViewModel(urlString: termsAndConditions)
            let webViewController = VFGWebViewController.instance(with: viewModel)
            webViewController.modalPresentationStyle = .fullScreen
            present(webViewController, animated: true, completion: nil)
            return
        }

        guard let termsViewController = termsViewController else { return }
        termsViewController.viewModel?.create(with: termsAndConditions)
        termsViewController.modalPresentationStyle = .fullScreen
        present(termsViewController, animated: true, completion: nil)
    }
    @IBAction public func backButtonPressed(_ sender: VFGButton) {
        backAction()
        lifeCycleDelegate?.referAFriendBackButtonPressed()
    }
    @objc public func backAction() {
        if isModal {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
}

// MARK: - UITableViewDelegate
extension VFGReferAFriendViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 71
    }
}

// MARK: - UITableViewDataSource
extension VFGReferAFriendViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return refferalListCount
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "VFGReferralsCell"
            ) as? VFGReferralsCell
        else {
            return UITableViewCell()
        }

        let model = viewModel?.referralsModel?.promotionContent.referralList?[indexPath.row]
        if indexPath.row == refferalListCount - 1 {
            cell.setCell(with: model, isHideDivider: true)
        } else {
            cell.setCell(with: model)
        }
        return cell
    }
}
// MARK: Voice over
extension VFGReferAFriendViewController {
    /// Add accessibility for voice over
    func addAccessibilityForVoiceOver() {
        urlLabel.accessibilityLabel = urlLabel.text
        backButton.accessibilityLabel = "back"
        shareButton.accessibilityLabel = "share"
        readTermsButton.accessibilityLabel = readTermsButton.titleLabel?.text ?? ""
        titleLabel.accessibilityLabel = titleLabel.text ?? ""
        mainImageView.accessibilityLabel = "image for \(titleLabel.text ?? "")"
        campaignTitleLabel.accessibilityLabel = campaignTitleLabel.text ?? ""
        campaignDescLabel.accessibilityLabel = campaignDescLabel.text ?? ""
        referralsLabel.accessibilityLabel = referralsLabel.text ?? ""
        referralsDescLabel.accessibilityLabel = referralsDescLabel.text ?? ""
        accessibilityCustomActions = [backVoiceOverAction(), shareVoiceOverAction(), readTermsVoiceOverAction()]
    }
    /// action for share button in voice over
    /// - Returns: action for share button in voice over
    func shareVoiceOverAction() -> UIAccessibilityCustomAction {
        let actionName = "share"
        return UIAccessibilityCustomAction(name: actionName, target: self, selector: #selector(shareAction))
    }
    /// action for back button  in voice over
    /// - Returns: action for bak button in voice over
    func backVoiceOverAction() -> UIAccessibilityCustomAction {
        let actionName = "back"
        return UIAccessibilityCustomAction(name: actionName, target: self, selector: #selector(backAction))
    }
    /// action for read terms button  in voice over
    /// - Returns: action for readTerms button in voice over
    func readTermsVoiceOverAction() -> UIAccessibilityCustomAction {
        let actionName = "terms and conditions"
        return UIAccessibilityCustomAction(name: actionName, target: self, selector: #selector(readTermsAction))
    }
}
