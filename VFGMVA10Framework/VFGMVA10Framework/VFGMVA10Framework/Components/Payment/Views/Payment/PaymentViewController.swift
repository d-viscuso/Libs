//
//  PaymentViewController.swift
//  VFGMVA10Framework
//
//  Created by Atta Amed on 8/25/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

/// Payment view controller.
public class PaymentViewController: UIViewController {
    let paymentCellId = "PaymentCardCell"
    let paymentShimmerCellId = "PaymentCardShimmerCell"
    var shimmerHeaderView: VFGShimmerView?
    var numberOfInitialSections = 2
    var numberOfShimmeredRowInSection = 1

    let sectionHeaderHeight: CGFloat = 35
    let otherCardsCellHeight: CGFloat = 312
    let preferredCardCellHeight: CGFloat = 280
    /// Payment view model.
    public var paymentListViewModel: PaymentViewModelProtocol?

    @IBOutlet weak var paymentsTableView: UITableView!
    @IBOutlet weak var addNewCardButton: VFGButton!
    @IBOutlet weak var noPaymentMethodsTitleLabel: VFGLabel!
    @IBOutlet weak var noPaymentMethodsDescriptionLabel: VFGLabel!

    var preferredCard: PaymentModelProtocol?
    var otherPaymentCards: [PaymentModelProtocol]?
    var allCards: [PaymentModelProtocol]? = [] {
        didSet {
            otherPaymentCards = allCards
            preferredCard = otherPaymentCards?.remove(at: 0)
            paymentsTableView.reloadData()
        }
    }
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        startShimmering()
        VFGPaymentManager.fetchPaymentCards { paymentCards, error in
            self.numberOfShimmeredRowInSection = 0
            self.setupAddCardButton()
            guard error == nil, paymentCards != nil else {
                self.numberOfInitialSections = 0
                return
            }
            if !(paymentCards?.isEmpty ?? false) {
                self.numberOfInitialSections = min(paymentCards?.count ?? 0, 2)
                self.allCards = paymentCards
            } else {
                self.numberOfInitialSections = 0
                self.allCards = nil
            }
        }
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        let paymentCardCell = UINib(nibName: paymentCellId, bundle: Bundle.mva10Framework)
        paymentsTableView.register(paymentCardCell, forCellReuseIdentifier: paymentCellId)
        let shimmerCell = UINib(nibName: paymentShimmerCellId, bundle: Bundle.mva10Framework)
        paymentsTableView.register(shimmerCell, forCellReuseIdentifier: paymentShimmerCellId)
        paymentsTableView.dataSource = self
        paymentsTableView.delegate = self
        setupLabels()
        VFGPaymentManager.trackView(
            pageName: "analytics_framework_sub_tray_payment_methods_title".localized(bundle: .mva10Framework))
        setVoiceOverAccessibility()
    }

    private func startShimmering() {
        setupShimmerHeader()
        allCards = nil
        numberOfInitialSections = 2
        numberOfShimmeredRowInSection = 1
        paymentsTableView.reloadData()
    }

    @objc func setPreferred(_ sender: VFGButton) {
        if let cardId = otherPaymentCards?[sender.tag].cardId {
            VFGPaymentManager.setPreferred(at: cardId) { paymentCards, error in
                guard error == nil, paymentCards != nil else {
                    return
                }
                self.allCards = (paymentCards?.isEmpty ?? true) ? nil : paymentCards
            }
        }
    }

    @IBAction func addNewCard(_ sender: VFGButton) {
        VFGPaymentManager.navigateToAddNewCard(
            navigation: (self.navigationController as? MVA10NavigationController)
        )
    }

    func setupLabels() {
        noPaymentMethodsTitleLabel.text = "payment_no_existing_methods_title".localized(bundle: .mva10Framework)
        noPaymentMethodsDescriptionLabel.text =
            "payment_no_existing_methods_description".localized(bundle: .mva10Framework)
    }
    func setupAddCardButton() {
        addNewCardButton.setTitle("payment_method_add_card".localized(bundle: .mva10Framework), for: .normal)
        shimmerHeaderView?.removeFromSuperview()
        shimmerHeaderView = nil
    }
    func setupShimmerHeader() {
        addNewCardButton.setTitle("", for: .normal)
        shimmerHeaderView = VFGShimmerView()
        guard let shimmerHeaderView = shimmerHeaderView  else {
            return
        }
        addNewCardButton.embed(view: shimmerHeaderView)
        shimmerHeaderView.startAnimation()
    }
    func switchLabelsState(isHidden: Bool) {
        noPaymentMethodsTitleLabel.isHidden = isHidden
        noPaymentMethodsDescriptionLabel.isHidden = isHidden
    }
}

extension PaymentViewController: UITableViewDataSource, UITableViewDelegate {
    public func numberOfSections(in tableView: UITableView) -> Int {
        let sectionsNumber = numberOfInitialSections
        switchLabelsState(isHidden: sectionsNumber > 0)
        return sectionsNumber
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return preferredCard == nil ? numberOfShimmeredRowInSection : 1
        } else {
            return otherPaymentCards?.count ?? numberOfShimmeredRowInSection
        }
    }

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .VFGLightGreyBackground
        let sectionLabel = VFGLabel(frame: CGRect(
            x: 16,
            y: 0,
            width: tableView.bounds.size.width,
            height: sectionHeaderHeight))
        sectionLabel.font = UIFont.vodafoneBold(25)
        sectionLabel.textColor = .VFGPrimaryText
        switch section {
        case 0:
            sectionLabel.text = "payment_preferred_payment_methods".localized(bundle: .mva10Framework)
        default:
            sectionLabel.text = "payment_other_payment_methods".localized(bundle: .mva10Framework)
        }
        headerView.addSubview(sectionLabel)
        return headerView
    }
    private func paymentCardTableView(
        _ tableView: UITableView,
        cellForItemAt indexPath: IndexPath,
        paymentCard: PaymentModelProtocol
    ) -> PaymentCardCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: paymentCellId,
            for: indexPath) as? PaymentCardCell
            else { return PaymentCardCell() }
        cell.configure(
            card: paymentCard,
            cardBackgroundImage: paymentListViewModel?.cardBackgroundImage(at: paymentCard.brand ?? .unknown),
            cardTextColor: paymentListViewModel?.cardTextColor(at: paymentCard.brand ?? .unknown))
        return cell
    }
    private func shimmerTableView(
        _ tableView: UITableView,
        cellForItemAt indexPath: IndexPath
    ) -> PaymentCardShimmerCell {
        guard let shimmerCell = tableView.dequeueReusableCell(
            withIdentifier: paymentShimmerCellId
            ) as? PaymentCardShimmerCell else {
                return PaymentCardShimmerCell()
        }
        shimmerCell.selectionStyle = .none
        return shimmerCell
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let shimmerCell = shimmerTableView(tableView, cellForItemAt: indexPath)
        switch indexPath.section {
        case 0:
            if let preferredCard = preferredCard {
                shimmerCell.stopShimmer()
                return paymentCardTableView(tableView, cellForItemAt: indexPath, paymentCard: preferredCard)
            } else {
                shimmerCell.startShimmer()
                return shimmerCell
            }
        default:
            if let otherCard = otherPaymentCards?[indexPath.row] {
                let cell = paymentCardTableView(tableView, cellForItemAt: indexPath, paymentCard: otherCard)
                cell.setPreferredButton.tag = indexPath.row
                cell.setPreferredButton.addTarget(
                    self,
                    action: #selector(setPreferred),
                    for: .touchUpInside)
                shimmerCell.stopShimmer()
                return cell
            } else {
                shimmerCell.startShimmer()
                return shimmerCell
            }
        }
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return preferredCardCellHeight
        } else {
            return otherCardsCellHeight
        }
    }

    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sectionHeaderHeight
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cardId = indexPath.section == 0 ? preferredCard?.cardId : otherPaymentCards?[indexPath.row].cardId,
            let cardName = indexPath.section == 0 ?
                preferredCard?.cardName : otherPaymentCards?[indexPath.row].cardName {
            VFGPaymentManager.navigateToEditCard(
                navigation: self.navigationController as? MVA10NavigationController,
                cardID: cardId,
                cardName: cardName
            )
        }
    }
}

// MARK: - VFGTrayContainerProtocol
extension PaymentViewController: VFGTrayContainerProtocol {
    public var tobiKey: String {
        "\(PaymentViewController.self)"
    }

    public var trayStyle: VFGTrayStyle {
        .TOBI
    }

    public var tobiContainerVC: UIViewController? {
        return VFGManagerFramework.tobiDelegate?.helpViewController(for:
            "\(PaymentViewController.self)")
    }
}

// MARK: - setVoiceOverAccessibility
extension PaymentViewController {
    private func setVoiceOverAccessibility() {
        noPaymentMethodsTitleLabel.accessibilityLabel = noPaymentMethodsTitleLabel.text ?? ""
        noPaymentMethodsDescriptionLabel.accessibilityLabel = noPaymentMethodsDescriptionLabel.text
        addNewCardButton.accessibilityLabel = addNewCardButton.titleLabel?.text
        accessibilityCustomActions = [addNewCardVoiceOverAction()]
    }

    func addNewCardVoiceOverAction() -> UIAccessibilityCustomAction {
        let actionName = addNewCardButton.titleLabel?.text ?? ""
        return UIAccessibilityCustomAction(
            name: actionName,
            target: self,
            selector: #selector(addNewCard))
    }
}
