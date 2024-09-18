//
//  PaymentModel.swift
//  VFGMVA10Framework
//
//  Created by Atta Amed on 8/25/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation

/// Card type e.g.( Visa, MasterCard, ....), depend on a certain regex
public enum CardType: String {
    case unknown
    case masterCard = "Mastercard"
    case diners = "Diners"
    case discover = "Discover"
    case hiperCard = "HiperCard"
    case unionPay = "UnionPay"
    case amex = "AMEX"
    case visa = "VISA"
    case jcb = "JCB"
    case elo = "ELO"
    static let allCards = [amex, visa, masterCard, diners, discover, jcb, elo, hiperCard, unionPay]

    var regex: String {
        switch self {
        case .amex:
            return "^3[47][0-9]{5,}$"
        case .visa:
            return "^4[0-9]{6,}([0-9]{3})?$"
        case .masterCard:
            return "^(5[1-5][0-9]{4}|677189)[0-9]{5,}$"
        case .diners:
            return "^3(?:0[0-5]|[68][0-9])[0-9]{4,}$"
        case .discover:
            return "^6(?:011|5[0-9]{2})[0-9]{3,}$"
        case .jcb:
            return "^(?:2131|1800|35[0-9]{3})[0-9]{3,}$"
        case .unionPay:
            return "^(62|88)[0-9]{5,}$"
        case .hiperCard:
            return "^(606282|3841)[0-9]{5,}$"
        case .elo:
            return "^((((636368)|(438935)|(504175)|(451416)|(636297))[0-9]{0,10})|((5067)|(4576)|(4011))[0-9]{0,12})$"
        default:
            return ""
        }
    }
}
extension CardType: Codable {}

/// This protocol represents the data model for the credit card object.
/// It contains basic and required properties which are shown in the payment list view
/// or will be added from add new payment card fields
public protocol PaymentModelProtocol {
    /// Payment card Id.
    var cardId: String? { get set }
    /// Payment card number.
    var cardNumber: String? { get set }
    /// Payment card masked number, like ************1234
    var securedDigits: String? { get set }
    /// Name on payment card.
    var nameOnCard: String? { get set }
    /// Name of your card if it will be saved.
    var cardName: String? { get set }
    /// expiration date, like "02/23".
    var expiry: String? { get set }
    /// Brand of the card
    var brand: CardType? { get set }
    /// ImageName of the card
    var cardImageName: String? { get }
    /// ImageData of the card
    var cardImageData: Data? { get }
    /// Enables card image large size
    var enableLargeImageSize: Bool? { get }
    /// Last four digits of the cards number.
    var lastFourDigits: String? { get set }
    /// Number of appearing digits in the masked number, default is 4.
    var numberOfAppearedDigits: Int? { get set }
    /// CVV number.
    var cvv: String? { get set }
    /// Boolean to determine which card to selected by default.
    var isPreferred: Bool? { get set }
    /// Boolean to determine which card to be Temporary.
    var isTempCard: Bool? { get set }
}

public extension PaymentModelProtocol {
    var cardImageName: String? { nil }
    var cardImageData: Data? { nil }
    var enableLargeImageSize: Bool? { nil }
    var isTempCard: Bool? { nil }
}

public class PaymentModel: Codable {
    private static let visaImageName = "visaColorLarge"
    private static let masterCardImageName = "mastercardLight"
    public static var allCards: [PaymentModel] = [
        PaymentModel(
            cardId: "1",
            cardNumber: "4242424242424242",
            numberOfAppearedDigits: 4,
            nameOnCard: "Family  Card",
            cardName: "Family's card",
            expiry: "02/23",
            brand: .visa,
            cardImageName: visaImageName,
            cvv: "123",
            isPreferred: true
        ),
        PaymentModel(
            cardId: "2",
            cardNumber: "4000056655665556",
            numberOfAppearedDigits: 4,
            nameOnCard: "Work card",
            cardName: "Work's card",
            expiry: "",
            brand: .masterCard,
            cardImageName: masterCardImageName,
            cvv: "125",
            isPreferred: false
        ),
        PaymentModel(
            cardId: "3",
            cardNumber: "4000056655665444",
            nameOnCard: "business card",
            cardName: "business's card",
            expiry: nil,
            brand: .masterCard,
            cardImageName: masterCardImageName,
            cvv: "125",
            isPreferred: false
        )
    ]

    public var cardId: String?
    public var cardNumber: String?
    public var lastFourDigits: String?
    public var securedDigits: String?
    public var nameOnCard: String?
    public var cardName: String?
    public var expiry: String?
    public var brand: CardType?
    public var cardImageName: String?
    public var cardImageData: Data?
    public var enableLargeImageSize: Bool?
    public var cvv: String?
    public var isPreferred: Bool?
    public var numberOfAppearedDigits: Int?
    public var isTempCard: Bool?
    public init(
        cardId: String? = String(Date().timeIntervalSinceReferenceDate),
        cardNumber: String?,
        numberOfAppearedDigits: Int = 4,
        nameOnCard: String?,
        cardName: String?,
        expiry: String?,
        brand: CardType?,
        cardImageName: String? = nil,
        cardImageData: Data? = nil,
        enableLargeImageSize: Bool? = false,
        cvv: String?,
        isPreferred: Bool?,
        isTempCard: Bool? = false
    ) {
        self.cardId = cardId
        self.cardNumber = cardNumber
        self.nameOnCard = nameOnCard
        self.cardName = cardName
        self.expiry = expiry
        self.brand = brand
        self.cardImageName = cardImageName
        self.cardImageData = cardImageData
        self.enableLargeImageSize = enableLargeImageSize
        self.cvv = cvv
        self.isPreferred = isPreferred
        self.isTempCard = isTempCard
        self.lastFourDigits = String(cardNumber?.suffix(4) ?? "")
        self.numberOfAppearedDigits = numberOfAppearedDigits
        self.securedDigits = hideCardNumber()
    }

    public init(cardNumber: String?) {
        self.cardNumber = cardNumber
    }
}

extension PaymentModel: PaymentModelProtocol {}

extension PaymentModelProtocol {
    func hideCardNumber() -> String {
        var secureDigits = "**** **** **** ****"
        secureDigits.removeLast(numberOfAppearedDigits ?? 0)
        secureDigits.append(String(cardNumber?.suffix(numberOfAppearedDigits ?? 0) ?? ""))
        return secureDigits
    }

    func hideCardNumberWithText() -> String {
        let cardBrand = brand?.rawValue ?? ""
        var lastAppearedDigits = "****"
        lastAppearedDigits.removeLast(numberOfAppearedDigits ?? 0)
        lastAppearedDigits.append(String(cardNumber?.suffix(numberOfAppearedDigits ?? 0) ?? ""))
        let paymentDetails = "top_up_quick_action_payment_method".localized(bundle: Bundle.mva10Framework)
        return String(format: paymentDetails, cardBrand, lastAppearedDigits)
    }
}

extension PaymentModelProtocol {
    func formatExpiryDate() -> String {
        guard let expiry = self.expiry, !expiry.isEmpty else {
            return ""
        }
        return "\("top_up_card_expired".localized(bundle: .mva10Framework)) \(expiry)"
    }
}
