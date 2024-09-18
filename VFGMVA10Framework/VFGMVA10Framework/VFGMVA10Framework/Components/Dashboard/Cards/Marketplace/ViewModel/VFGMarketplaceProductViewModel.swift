//
//  VFGMarketplaceProductViewModel.swift
//  VFGMVA10Framework
//
//  Created by Giovanni Romaniello on 20/10/22.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import Foundation


/// whishlist listener protocol to observe wishlist actions
public protocol VFGWishlistListenerProtocol: AnyObject {
    /// callback for product add
    /// - Parameter product: marketplace product
    func onProductAdded(product: VFGMarketplaceProductModel)
    /// callback for product remove
    /// - Parameter product: marketplace product
    func onProductRemoved(product: VFGMarketplaceProductModel)
}

/// marketplace wishlist protocol
public protocol VFGMarketplaceWishlistProtocol: AnyObject {
    /// checks if the user wishlist contains the marketplace product
    /// - Parameter product: a product model
    /// - Returns: true if the product is present in the wishlist
    @discardableResult
    func wishlistContainsProduct(product: VFGMarketplaceProductModel) -> Bool

    /// adds a marketplace product to the user wishlist
    /// - Parameter product: a product model
    /// - Returns: true if the product is added succesfully
    @discardableResult
    func addProductToWishlist(product: VFGMarketplaceProductModel) -> Bool

    /// remove a marketplace product from the user wishlist
    /// - Parameter product: a product model
    /// - Returns: true if is added succesfully
    @discardableResult
    func removeProductFromWishList(product: VFGMarketplaceProductModel) -> Bool
}


/// marketplace product view model
public protocol VFGMarketplaceProductViewModelProtocol {
    /// wishlist reference
    var wishlist: VFGMarketplaceWishlistProtocol? { get set }
    /// cell reference
    var cellInterface: VFGMarketplaceProductCellInterface? { get set }
    /// shows/hides wish button
    var showWishButton: Bool { get }
    /// shows/hides current price
    var showCurrentPrice: Bool { get }
    /// shows/hides former price
    var showFormerPrice: Bool { get }
    /// shows/hides happy points
    var showHappyPoints: Bool { get }
    /// current price formatted
    var currentPrice: String? { get }
    /// current price formatted
    var formerPrice: NSAttributedString? { get }
    /// happy points value formatted
    var happyPoints: String? { get }
    /// product image url
    var imageUrl: String { get }
    /// product name
    var productName: String { get }
    /// product is present in wishlist
    var isWish: Bool { get }
    /// add/remove product from wishlist
    func toggleWishlist()
}


/// VFGMarketplaceProductViewModel implementation
public class VFGMarketplaceProductViewModel: VFGMarketplaceProductViewModelProtocol {
    private let numberFormatter: NumberFormatter
    /// the product model
    let product: VFGMarketplaceProductModel
    /// wishlist reference
    weak public var wishlist: VFGMarketplaceWishlistProtocol?
    /// cell reference
    weak public var cellInterface: VFGMarketplaceProductCellInterface?
    /// wishlist listener
    weak public var wishlistListener: VFGWishlistListenerProtocol?

    /// VFGMarketplaceProductViewModel constructor
    /// - Parameters:
    ///   - product: product model
    ///   - wishlist: wishlist
    init(product: VFGMarketplaceProductModel, wishlist: VFGMarketplaceWishlistProtocol?) {
        self.product = product
        self.wishlist = wishlist
        numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.generatesDecimalNumbers = false
        numberFormatter.alwaysShowsDecimalSeparator = false
        numberFormatter.currencySymbol = product.currency
        numberFormatter.positiveFormat = "#,##0¤"
        numberFormatter.negativeFormat = "-#,##0¤"
    }

    /// shows wish button according to the model
    public var showWishButton: Bool {
        product.showWish == true
    }

    /// shows current price label according to the model
    public var showCurrentPrice: Bool {
        currentPrice != nil
    }

    /// shows former price according to the model
    public var showFormerPrice: Bool {
        formerPrice != nil
    }

    /// shows happy points according to the model
    public var showHappyPoints: Bool {
        happyPoints != nil
    }

    /// returns the currentPrice formatted string with currency
    public var currentPrice: String? {
        guard let currentPrice = product.currentPrice else {
            return nil
        }
        return numberFormatter.string(from: currentPrice as NSNumber)
    }

    /// returns the formerPrice formatted attributed string with strikethrough effect and currency
    public var formerPrice: NSAttributedString? {
        guard let formerPrice = product.formerPrice,
    let text = numberFormatter.string(from: formerPrice as NSNumber) else {
    return nil
    }
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(
            NSAttributedString.Key.strikethroughStyle,
            value: 1,
            range: NSRange(location: 0, length: text.count))
        return attributedString
    }

    /// returns the happyPoints value as string
    public var happyPoints: String? {
        guard let points = product.happyPoints else {
            return nil
        }
        return String(points)
    }

    /// product image url
    public var imageUrl: String {
        product.productImageUrl
    }

    /// product name
    public var productName: String {
        product.productName
    }

    /// returns true if the product is in wishlist
    public var isWish: Bool {
        wishlist?.wishlistContainsProduct(product: product) == true
    }

    /// adds or remove the product from the wishlist, then tells the interface to update itself
    public func toggleWishlist() {
        if isWish {
            wishlist?.removeProductFromWishList(product: product)
            wishlistListener?.onProductRemoved(product: product)
        } else {
            wishlist?.addProductToWishlist(product: product)
            wishlistListener?.onProductAdded(product: product)
        }
        cellInterface?.refresh()
    }
}
