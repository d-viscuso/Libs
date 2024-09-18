//
//  ManageAddOnViewController.swift
//  VFGMVA10Framework
//
//  Created by Ahmed Sultan on 5/8/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

public class ManageAddOnViewController: VFGBaseViewController {
    // MARK: IBOutlets
    @IBOutlet weak var headerView: ManageAddOnHeaderView!
    @IBOutlet weak var headerViewHeightConstriant: NSLayoutConstraint!
    @IBOutlet weak var scrollableHeaderView: ManageAddOnHeaderView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var actionButton: VFGButton!
    @IBOutlet weak var expirationDateTitleLabel: VFGLabel!
    @IBOutlet weak var addOnHeaderTitle: VFGLabel!
    @IBOutlet weak var priceDescLabel: VFGLabel!
    @IBOutlet weak var priceLabel: VFGLabel!
    @IBOutlet weak var addOnDesc: UITextView!
    @IBOutlet weak var addonDescTextViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var showMoreButton: VFGButton!
    @IBOutlet weak var showMoreButtonHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var autoRenewTitleLabel: VFGLabel!
    @IBOutlet weak var expirationDateLabel: VFGLabel!
    @IBOutlet weak var isRenewableSwitch: VFGButton!
    @IBOutlet weak var autoRenewSeparatorView: UIView!
    @IBOutlet weak var autoRenewStackViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var expirationStackView: UIStackView!
    @IBOutlet weak var expirationStackViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var expirationSeparatorView: UIView!
    @IBOutlet weak var topSeparatorView: UIView!
    @IBOutlet weak var infoStackView: UIStackView!
    public weak var uiDelegate: ManageAddOnUIDelegateProtocol?
    public weak var navigationDelegate: ManageAddOnNavigationProtocol?
    var toggleSwitchOn = false {
        didSet {
            setDescription()
            if toggleSwitchOn {
                isRenewableSwitch.setImage(
                    UIImage.VFGToggle.Medium.active,
                    for: .normal)
            } else {
                isRenewableSwitch.setImage(
                    UIImage.VFGToggle.Medium.inactive,
                    for: .normal)
            }
        }
    }

    // MARK: Properties
    var manageAddOnVM: ManageAddOnPlanViewModel?
    var descriptionMaxLines = 4
    var isDescriptionExpanded = false {
        didSet {
            adjustDescriptionHeight(willExpand: isDescriptionExpanded)
        }
    }
    var addOnIdentifier: String? {
        manageAddOnVM?.addOn?.identifier
    }
    var quickActionsViewController: VFQuickActionsViewController? {
        UIApplication.topViewController() as? VFQuickActionsViewController
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupHeader()
        setupAccessibilityIdentifier()
        setupAccessibilityLabels()
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        if let navigationController = navigationController as? MVA10NavigationController {
            navigationController.hasDivider = false
        }
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if let navigationController = navigationController as? MVA10NavigationController {
            navigationController.isTransparentBackground = true
            navigationController.hasDivider = false
        }
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(false)
        if let navigationController = navigationController as? MVA10NavigationController {
            navigationController.isTransparentBackground = false
            navigationController.isTranslucent = false
            navigationController.hasDivider = true
        }
    }

    func setupHeader() {
        let isScrollableHeaderView = uiDelegate?.isScrollableHeaderView ?? false
        let statusBarHeight = UIApplication.shared.statusBarFrameValue?.height ?? 0
        let navigationViewAddedHeight = UIScreen.screenHasNotch ? UIApplication.shared.keyWindow?.safeAreaInsets.top : 0
        let scrollTopInset = statusBarHeight + (navigationViewAddedHeight ?? 0)
        let scrollTopInsetDifference = isScrollableHeaderView ? scrollTopInset : 0
        let backgroundImage = UIImage(
            named: Constants.ManageAddOn.backgroundImageName,
            in: Bundle.mva10Framework,
            compatibleWith: nil)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentInsetAdjustmentBehavior = .always
        scrollView.contentInset = UIEdgeInsets(
            top: scrollView.contentInset.top - scrollTopInsetDifference,
            left: 0,
            bottom: scrollView.contentInset.bottom,
            right: 0)
        headerView.isHidden = isScrollableHeaderView
        scrollableHeaderView.isHidden = !isScrollableHeaderView
        (navigationController as? MVA10NavigationController)?.isTranslucent = isScrollableHeaderView
        headerViewHeightConstriant.constant = isScrollableHeaderView ? 0 : headerViewHeightConstriant.constant
        scrollableHeaderView.backGroundImage = backgroundImage
        headerView.backGroundImage = backgroundImage
        self.view.sizeToFit()
    }

    func setupUI() {
        addOnDesc.textContainerInset = UIEdgeInsets.zero
        addOnDesc.textContainer.lineFragmentPadding = 0
        addOnDesc.textContainer.lineBreakMode = .byTruncatingTail
        addOnDesc.isScrollEnabled = false
        adjustDescriptionHeight(willExpand: false)

        guard let addOnIdentifier = addOnIdentifier,
            let addOnDetails = manageAddOnVM?.addOn?.addOnDetails,
            let manageAction = manageAddOnVM?.actionType else { return }
        addOnHeaderTitle.text = addOnDetails.title
        priceLabel.text = addOnDetails.price
        priceDescLabel.text = addOnDetails.priceDetails
        let autoRenewTitle = uiDelegate?.autoRenewTitle(
            of: addOnIdentifier,
            mode: manageAction
        ) ?? manageAction.autoRenewTitle
        autoRenewTitleLabel.text = !autoRenewTitle.isEmpty ? autoRenewTitle : manageAction.autoRenewTitle
        setActionButtonTitle(for: manageAction)
        let expirationDateTitle = uiDelegate?.dateLabelTitle(
            of: addOnIdentifier,
            mode: manageAction
        ) ?? manageAction.dateLabelTitle
        expirationDateTitleLabel.text = !expirationDateTitle.isEmpty ? expirationDateTitle : manageAction.dateLabelTitle
        manageAddOnVM?.confirmationViewMessageText = uiDelegate?.confirmationViewMessageText
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        isRenewableSwitch.isHidden = addOnDetails.shouldHideAutoRenewView ?? false
        autoRenewTitleLabel.isHidden = addOnDetails.shouldHideAutoRenewView ?? false
        autoRenewSeparatorView.isHidden = addOnDetails.shouldHideAutoRenewView ?? false
        autoRenewStackViewHeightConstraint.constant = addOnDetails.shouldHideAutoRenewView ?? false ? 0 : 50
        expirationStackView.isHidden = addOnDetails.shouldHideExpirationDate ?? false
        expirationStackViewHeightConstraint.constant = addOnDetails.shouldHideExpirationDate ?? false ? 0 : 50
        expirationSeparatorView.isHidden = addOnDetails.shouldHideExpirationDate ?? false
        topSeparatorView.isHidden = (
            addOnDetails.shouldHideExpirationDate ?? false) && (addOnDetails.shouldHideAutoRenewView ?? false
        )
        if let infoView = uiDelegate?.infoView(of: addOnIdentifier, mode: manageAction) {
            infoView.heightAnchor.constraint(equalToConstant: infoView.frame.size.height).isActive = true
            infoStackView.addArrangedSubview(infoView)
        }
        actionButton.isHidden = addOnDetails.shouldHideActionButton ?? false
        setToggleSwitchOn()
        checkIfTextWillTruncate()
        if manageAction == .buy {
            expirationDateLabel.text = dateFormatter.string(from: Date())
            actionButton.buttonStyle = 0
        } else {
            setExpirationDate(expirationDate: addOnDetails.expirationDate)
            actionButton.buttonStyle = 2
        }

        guard let actionButtonStyle = uiDelegate?.actionButtonStyle(of: addOnIdentifier, mode: manageAction) else {
            return
        }
        actionButton.buttonStyle = actionButtonStyle.rawValue
    }

    func setToggleSwitchOn() {
        guard let addOnDetails = manageAddOnVM?.addOn?.addOnDetails,
            let manageAction = manageAddOnVM?.actionType else { return }
        toggleSwitchOn = manageAction == .buy ? false : addOnDetails.isAutoRenewable ?? false
    }

    func setDescription() {
        guard let addOnIdentifier = addOnIdentifier,
            let actionType = manageAddOnVM?.actionType,
            let addOnDetails = manageAddOnVM?.addOn?.addOnDetails else { return }
        let customDescription = uiDelegate?.getDescription(
            of: addOnIdentifier,
            autoRenewSwitch: toggleSwitchOn,
            mode: actionType
        )
        addOnDesc.text = customDescription ?? addOnDetails.description
        addOnDesc.layoutIfNeeded()
    }

    func setActionButtonTitle(for manageAction: ManageAddOnActions) {
        guard manageAction == .buy && manageAddOnVM?.addOn?.addOnDetails?.shouldShowActiveIndicatorView ?? false else {
            actionButton.setTitle(manageAction.buttonActionTitle, for: .normal)
            return
        }
        actionButton.setTitle(manageAddOnVM?.addOn?.addOnDetails?.activateButtonTitle, for: .normal)
    }

    func checkIfTextWillTruncate() {
        let text = NSString(string: addOnDesc.text ?? "")
        let font = addOnDesc.font ?? .systemFont(ofSize: 10)
        let textSize = text.boundingRect(
            with: CGSize(width: addOnDesc.frame.size.width, height: .greatestFiniteMagnitude),
            options: .usesLineFragmentOrigin,
            attributes: [.font: font],
            context: nil).size

        guard textSize.height < addOnDesc.bounds.size.height else { return }
        adjustDescriptionHeight(willExpand: true)
        showMoreButton.isHidden = true
        showMoreButtonHeightConstraint.constant = 0
    }

    // MARK: IbActions
    @IBAction func actionButtonPressed(_ sender: Any) {
        guard let manageAddOnVM = manageAddOnVM else {
            return
        }
        switch navigationDelegate?.buyAddOnNavigationType(viewController: self, addOnIdentifier) {
        case .customNavigation(let navigationAction):
            navigationAction()
            return
        default:
            break
        }
        VFQuickActionsViewController.presentQuickActionsViewController(with: manageAddOnVM)
    }

    @IBAction func switchIsRenewable(_ sender: VFGButton) {
        manageAddOnVM?.addOn?.addOnDetails?.isAutoRenewable = toggleSwitchOn
        manageAddOnVM?.updateAddOnDetails { [weak self] in
            self?.toggleSwitchOn.toggle()
        }
    }

    @IBAction func showMoreButtonPressed(_ sender: VFGButton) {
        isDescriptionExpanded.toggle()
    }

    func adjustDescriptionHeight(willExpand: Bool) {
        addOnDesc.textContainer.maximumNumberOfLines = willExpand ? 0 : descriptionMaxLines
        addOnDesc.sizeToFit()
        addonDescTextViewHeightConstraint.constant = addOnDesc.contentSize.height
        let title = willExpand ? "addons_show_less" : "addons_show_more"
        showMoreButton.setTitle(
            title.localized(bundle: .mva10Framework),
            for: .normal)
    }

    func changeQuickActionContentView(to view: UIView?) {
        guard let manageAddOnVM = manageAddOnVM, let view = view else { return }
        manageAddOnVM.changeQuickActionContentView(to: view)
        quickActionsViewController?.reloadQuickAction(model: manageAddOnVM)
    }
}

extension ManageAddOnViewController {
    func setExpirationDate(expirationDate: String?) {
        if let index = expirationDate?.range(of: "T")?.lowerBound {
            let substring = String(expirationDate?[..<index] ?? "")
            expirationDateLabel.text = formattedDateFromString(dateString: substring, withFormat: "dd/MM/yyyy")
        } else {
            expirationDateLabel.text = expirationDate
        }
    }

    func formattedDateFromString(dateString: String, withFormat format: String) -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"

        if let date = inputFormatter.date(from: dateString) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = format

            return outputFormatter.string(from: date)
        }

        return nil
    }
}
