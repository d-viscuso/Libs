//
//  VFGPaymentMethodsCard.swift
//  VFGMVA10Framework
//
//  Created by Ahmed Sultan on 9/28/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

/// Cards preview mode.
public enum CardsPreviewMode {
    /// Large card preview.
    case large
    /// Compact card preview.
    case compact
    /// Empty card preview.
    case empty
}

/// Payment methods card presenter type.
public enum VFGPresenterType {
    /// TopUp.
    case topUp
    /// Billing.
    case billing
    /// AddPlan.
    case addPlan
    /// AutoBill.
    case autoBill
    /// AutoTopUp.
    case autoTopUp
}

/// Payment method card state delegate.
protocol VFGPaymentMethodCardStateDelegate: AnyObject {
    /// Method called after fetching payment methods is finished.
    /// - Parameters:
    ///    - error: Error type if fetching payment method didn't succeed or nil if fetching was successful.
    func fetchPaymentDidFinish(with error: Error?)
}

/// Payment methods card view delegate.
public protocol VFGPaymentMethodsCardViewDelegate: AnyObject {
    func collectionView(
        _ collectionView: UICollectionView,
        didHeightChanged height: CGFloat
    )
    func collectionView(
        _ collectionView: UICollectionView,
        didHeightChanged height: CGFloat,
        viewHeight: CGFloat
    )
    /// Method called after fetching payment methods is finished.
    /// - Parameters:
    ///    - cardsCount: Number of payment cards fetched.
    func fetchPaymentDidFinish(with cardsCount: Int)
}

public extension VFGPaymentMethodsCardViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        didHeightChanged height: CGFloat
    ) {}
    func collectionView(
        _ collectionView: UICollectionView,
        didHeightChanged height: CGFloat,
        viewHeight: CGFloat
    ) {
        self.collectionView(collectionView, didHeightChanged: height)
    }

    func fetchPaymentDidFinish(with cardsCount: Int) {}
}

/// Payment methods card view.
public class VFGPaymentMethodsCardView: UIView, AlternativePaymentMethodDelegate {
    @IBOutlet weak var editWithPinView: UIStackView!
    @IBOutlet weak var editButton: VFGButton!
    @IBOutlet weak var editLabel: VFGLabel!
    @IBOutlet weak var titleLabel: VFGLabel!
    @IBOutlet weak var titleLabelBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var paymentMethodsCollectionView: UICollectionView!
    @IBOutlet weak var allPaymentMethodsStack: UIStackView!
    @IBOutlet weak var firstPaymentHeaderView: UIView!
    @IBOutlet weak var firstPaymentRadioButton: VFGRadioButton!
    @IBOutlet weak var firstPaymentTitle: VFGLabel!
    @IBOutlet weak var paymentCardsCollectionHeightConstraint: NSLayoutConstraint!

    let nibName = "VFGPaymentMethodsCardView"
    let paymentMethodLargeCellNibName = "VFGPaymentMethodLargeCell"
    let paymentMethodLargeCellId = "VFGPaymentMethodLargeCellId"
    let paymentMethodCompactCellNibName = "VFGPaymentMethodCompactCell"
    let paymentMethodCompactCellId = "VFGPaymentMethodCompactCellId"
    let addPaymentMethodCellNibName = "VFGAddPaymentMethodCell"
    let addPaymentMethodCellId = "VFGAddPaymentMethodCellId"
    let estimatedCompactCellSize = CGSize(width: 200, height: 100)
    let estimatedLargeCellHeight: CGFloat = 71
    let collectionHeightWhenCardSelected: CGFloat = 89
    let paymentCardsCollectionHeight: CGFloat = 80
    var allAlternativeViews: [VFGAlternativePaymentMethodView] = []
    var selectedViewId: String?
    var isEditingEnabled = false {
        didSet {
            editButton.isHidden = isEditingEnabled
            editWithPinView.isHidden = isEditingEnabled
        }
    }

    /// Collection view delegate.
    weak public var collectionViewDelegate: VFGPaymentMethodsCardViewDelegate?
    weak var paymentCardStateDelegate: VFGPaymentMethodCardStateDelegate?
    var didPurchaseGift = false
    var cardsPreviewMode: CardsPreviewMode = .empty {
        didSet {
            titleLabelBottomConstraint.constant = cardsPreviewMode == .large ? 0 : titleBottomMargin
            paymentCardsCollectionHeightConstraint.constant =
            cardsPreviewMode == .empty ? estimatedCompactCellSize.height : paymentCardsCollectionHeight
        }
    }
    var lastSelectedCardIndex: Int = 0
    var presenterType: VFGPresenterType = .topUp
    var initialSelectedCard: PaymentModelProtocol?
    var shouldHideAlternativePayments = false
    let titleBottomMargin: CGFloat = 16

    var shownPaymentCards: [PaymentModelProtocol] = [] {
        didSet {
            if isEditingEnabled || shownPaymentCards.count > 1 {
                cardsPreviewMode = shownPaymentCards.isEmpty ? .empty : .compact
                if shownPaymentCards.first?.isTempCard ?? false {
                    scrollToFirstCell()
                }
            } else {
                cardsPreviewMode = .large
            }
            paymentMethodsCollectionView.alpha = 0
            paymentMethodsCollectionView?.reloadData()
            UIView.animate(withDuration: 0.3) { [weak self] in
                self?.paymentMethodsCollectionView.alpha = 1
            }
        }
    }

    var paymentCards: [PaymentModelProtocol] = [] {
        didSet {
            guard let preferredCard = paymentCards.first else {
                isEditingEnabled = true
                shownPaymentCards = paymentCards
                return
            }
            if shownPaymentCards.isEmpty {
                shownPaymentCards = [preferredCard]
            } else {
                shownPaymentCards = paymentCards
            }
            lastSelectedCardIndex = 0
        }
    }

    func getSortedCards() -> [PaymentModelProtocol] {
        guard lastSelectedCardIndex != 0 else { return paymentCards }
        paymentCards = [paymentCards.remove(at: lastSelectedCardIndex)] + paymentCards
        return paymentCards
    }

    private func scrollToFirstCell() {
        paymentMethodsCollectionView.contentOffset.x = 0
    }

    func loadCards() {
        VFGPaymentManager.fetchPaymentCards { [weak self] cards, error in
            self?.paymentCards = cards ?? []
            if
                let cardNumber = self?.initialSelectedCard?.cardNumber,
                let selectCard = self?.paymentCards.first(where: { $0.cardNumber == cardNumber }) {
                self?.lastSelectedCardIndex = self?.paymentCards.firstIndex { $0.cardNumber == cardNumber } ?? 0
                self?.showSelected(card: selectCard)
            }
            self?.paymentCardStateDelegate?.fetchPaymentDidFinish(with: error)
            self?.collectionViewDelegate?.fetchPaymentDidFinish(with: self?.paymentCards.count ?? 0)
        }
    }

    func radioButtonDidSelect(view: VFGAlternativePaymentMethodView) {
        handleRadioButtonClick(hideFirstPayment: true, selectedViewId: view.cardId)
        view.alternativePaymentMethodCardView.isHidden = false
        view.radioButton.setImage(UIImage.VFGRadioButton.active, for: .normal)
    }

    func loadAlternativeCards() {
        VFGPaymentManager.fetchAlternativePaymentMethods { alternativeCards in
            if alternativeCards == nil {
                return
            }
            firstPaymentHeaderView.isHidden = false
            firstPaymentTitle.text = VFGPaymentManager.alternativePaymentProvider?.firstSectionTitle
            alternativeCards?.forEach { alternativeCard in
                let alternativeView = VFGAlternativePaymentMethodView()
                alternativeView.delegate = self
                allAlternativeViews.append(alternativeView)
                alternativeView.alternativePaymentMethodCardView.embed(view: alternativeCard.view ?? UIView())
                alternativeView.title.text = alternativeCard.title
                alternativeView.cardId = alternativeCard.id
                allPaymentMethodsStack.addArrangedSubview(alternativeView)
            }
        }
    }

    func setupPaymentMethodsCollectionView() {
        paymentMethodsCollectionView?.delegate = self
        paymentMethodsCollectionView?.dataSource = self
        let paymentMethodLargeCell = UINib(nibName: paymentMethodLargeCellNibName, bundle: Bundle.foundation)
        let addPaymentMethodCell = UINib(nibName: addPaymentMethodCellNibName, bundle: Bundle.foundation)
        let paymentMethodCompactCell = UINib(nibName: paymentMethodCompactCellNibName, bundle: Bundle.foundation)
        paymentMethodsCollectionView?.register(
            paymentMethodLargeCell,
            forCellWithReuseIdentifier: paymentMethodLargeCellId)
        paymentMethodsCollectionView?.register(
            addPaymentMethodCell,
            forCellWithReuseIdentifier: addPaymentMethodCellId)
        paymentMethodsCollectionView?.register(
            paymentMethodCompactCell,
            forCellWithReuseIdentifier: paymentMethodCompactCellId)
    }

    func configure(title: String, editText: String, presenterType: VFGPresenterType = .topUp) {
        loadCards()
        if !shouldHideAlternativePayments {
            loadAlternativeCards()
        }
        titleLabel.text = title
        editLabel.text = editText
        editButton.accessibilityIdentifier = "TPeditPaymentButton"
        self.presenterType = presenterType
        setAccessibilityForVoiceOver()
    }

    func setAccessibilityForVoiceOver() {
        titleLabel.accessibilityLabel = titleLabel.text ?? ""
        editLabel.accessibilityLabel = " "
        editButton.accessibilityLabel = editLabel.text ?? ""
        editButton.accessibilityHint = "Change your selected payment method or add a new one"
        accessibilityCustomActions = [editButtonVoiceOverAction()]
    }

    func showAllCards() {
        shownPaymentCards = getSortedCards()
    }

    func showSelected(card: PaymentModelProtocol) {
        isEditingEnabled = false
        shownPaymentCards = [card]
    }

    public override func awakeFromNib() {
        super.awakeFromNib()
        setupPaymentMethodsCollectionView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }

    func xibSetup() {
        guard let view = loadViewFromNib(nibName: nibName) else {
            VFGErrorLog("VFGPaymentMethodsCardView is nil")
            return
        }
        xibSetup(contentView: view)
    }

    @IBAction func editButtonAction(_ sender: Any) {
        editButtonPressed()
        paymentCardsCollectionHeightConstraint.constant = estimatedCompactCellSize.height
    }
    @objc func editButtonPressed() {
        isEditingEnabled = true
        showAllCards()
    }
    func editButtonVoiceOverAction() -> UIAccessibilityCustomAction {
        let actionName = editLabel.text ?? "Edit"
        return UIAccessibilityCustomAction(name: actionName, target: self, selector: #selector(editButtonPressed))
    }

    @IBAction func radioButton(_ sender: Any) {
        handleRadioButtonClick(hideFirstPayment: false, selectedViewId: nil)
    }

    func handleRadioButtonClick(hideFirstPayment: Bool, selectedViewId: String?) {
        let activeImage = UIImage.VFGRadioButton.active
        let inActiveImage = UIImage.VFGRadioButton.inactive
        allAlternativeViews.forEach {
            $0.radioButton.setImage(inActiveImage, for: .normal)
            $0.alternativePaymentMethodCardView.isHidden = true
        }
        paymentMethodsCollectionView.isHidden = hideFirstPayment
        editWithPinView.isHidden = hideFirstPayment
        firstPaymentRadioButton.setImage(hideFirstPayment ? inActiveImage : activeImage, for: .normal)
        self.selectedViewId = selectedViewId
    }
}

extension VFGPaymentMethodsCardView: VFGPaymentMethodCompactCellDelegate {
    public func deleteCard(with cardId: String?) {
        guard let id = cardId else { return }

        VFGPaymentManager.deletePaymentCard(by: id) { [weak self] error in
            if error == nil {
                self?.shownPaymentCards.removeAll { $0.cardId == id }
            }
        }
    }
}
