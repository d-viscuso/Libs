//
//  ProductSwitcherCardViewModel.swift
//  VFGMVA10Framework
//
//  Created by Tuncel, Pelin, Vodafone on 8/15/22.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import Foundation
import VFGMVA10Foundation

/// ProductSwitcherCardViewModelProtocol
public protocol ProductSwitcherCardViewModelProtocol {
    var numberOfCards: Int { get }
    var allCategoryText: String { get }
    var isAddressFilterEnabled: Bool { get }
    var isSearchEnabled: Bool { get }
    var isCategoryFilterEnabled: Bool { get }
    var isEditNameEnabled: Bool { get }
    var isStarredEnabled: Bool { get }
    var state: VFGContentState { get set }
    var updateStatus: (() -> Void)? { get set }
    var errorModel: VFGErrorModel? { get set }
    var tryAgainClosure: (() -> Void)? { get set }
    func getCardItem(for indexPath: IndexPath) -> Any?
    func getAddressFilters() -> [String]
    func getCategoryFilters() -> [String]
    func filterFor(address: String)
    func filterFor(query: String) -> Int
    func filterFor(categories: [String])
    func getSuggestedQuery(for query: String) -> String
    func updateAllCategoryText()
}

/// ProductSwitcherCardViewModel
public class ProductSwitcherCardViewModel {
    private var productSwitcherCard: ProductSwitcherCardModel {
        didSet {
            state = .populated
        }
    }
    /// Current cards that are being handled. Updated with address filter selection
    private var currentCards: [ProductSwitcherCardItemModel] = []
    /// Filtered current cards based on search queries and filter selection
    private var filteredCards: [ProductSwitcherCardItemModel] = []
    public var updateStatus: (() -> Void)?
    public var errorModel: VFGErrorModel?
    public var tryAgainClosure: (() -> Void)?
    public var allCategoryText: String = ""
    public var state: VFGContentState = .loading {
        didSet {
            updateStatus?()
        }
    }

    public init(with model: ProductSwitcherCardModel) {
        self.productSwitcherCard = model
        if let cards = productSwitcherCard.cards {
            currentCards = cards
            filteredCards = cards
            updateAllCategoryText()
        }
    }
}

extension ProductSwitcherCardViewModel: ProductSwitcherCardViewModelProtocol {
    public var numberOfCards: Int {
        if isSearchEnabled, filteredCards.isEmpty {
            return 1 // Display no result cell
        }
        return filteredCards.count
    }
    public func updateAllCategoryText() {
        allCategoryText = ProductSwitcherLocalize.all.localizedString + " (\(filteredCards.count))"
    }
    public var isAddressFilterEnabled: Bool {
        return productSwitcherCard.isAddressFilterEnabled
    }
    public var isSearchEnabled: Bool {
        return productSwitcherCard.isSearchEnabled
    }
    public var isCategoryFilterEnabled: Bool {
        return productSwitcherCard.isCategoryFilterEnabled
    }
    public var isEditNameEnabled: Bool {
        return productSwitcherCard.isEditNameEnabled
    }
    public var isStarredEnabled: Bool {
        return productSwitcherCard.isStarredEnabled
    }

    public func getCardItem(for indexPath: IndexPath) -> Any? {
        if isSearchEnabled, filteredCards.isEmpty {
            return ProductSwitcherNoResultCell.reuseIdentifier
        }

        guard filteredCards.count > indexPath.row
        else { return nil }
        return filteredCards[indexPath.row]
    }

    public func getAddressFilters() -> [String] {
        guard let cards = productSwitcherCard.cards,
            cards.count > 1
        else { return [] }
        var addressFilters: [String] = []
        for card in cards {
            guard let address = card.contentModel.address,
                addressFilters.contains(address) == false
            else { continue }
            addressFilters.append(address)
        }
        return addressFilters
    }

    public func getCategoryFilters() -> [String] {
        return getCategoryFilters(for: filteredCards)
    }

    public func filterFor(address: String) {
        guard let cards = productSwitcherCard.cards,
            cards.count > 1
        else { return }
        currentCards = cards.filter { $0.contentModel.address == address }
        filteredCards = currentCards
        if isCategoryFilterEnabled {
            filterFor(categories: [allCategoryText])
        }
    }

    public func filterFor(query: String) -> Int {
        guard let cards = productSwitcherCard.cards else { return 0 }
        if !isAddressFilterEnabled {
            currentCards = cards
        }
        if query.isEmpty {
            filteredCards = currentCards
        } else {
            filteredCards = currentCards.filter {
                // Lowercase and remove punctuation from query, title and name
                let updatedQuery = self.setupTextForSearch(query)
                let contentTitle = self.setupTextForSearch($0.contentModel.title)
                let contentName = self.setupTextForSearch($0.contentModel.name)
                // Check if query exists in either title or the name
                return contentTitle.contains(updatedQuery) || contentName.contains(updatedQuery)
            }
        }
        return filteredCards.count
    }

    public func filterFor(categories: [String]) {
        guard currentCards.count > 1 else { return }
        if categories.contains(allCategoryText) {
            filteredCards = currentCards
            return
        }
        filteredCards = currentCards.filter { card in
            let categoryTitle = self.getCategoryFilter(for: card.contentModel.category ?? "")
            return categories.contains(categoryTitle)
        }
    }

    /// - returns: A suggested query word from the given query if there are any matches
    public func getSuggestedQuery(for query: String) -> String {
        // Get all the words in the query to a words array
        let queryWords = query.components(separatedBy: " ")
        for queryWord in queryWords {
            let filteredCards = currentCards.filter {
                // Lowercase and remove punctuation from query, title and name
                let updatedQuery = self.setupTextForSearch(queryWord)
                let contentTitle = self.setupTextForSearch($0.contentModel.title)
                let contentName = self.setupTextForSearch($0.contentModel.name)
                // Check if query exists in either title or the name
                return contentTitle.contains(updatedQuery) || contentName.contains(updatedQuery)
            }
            if !filteredCards.isEmpty {
                return queryWord
            }
        }
        return ""
    }

    // MARK: Helper Methods

    private func getCategoryFilter(for category: String) -> String {
        let filters = getCategoryFilters(for: currentCards)
        guard let filter = filters.first(where: { $0.contains(category) })
        else { return category }
        return filter
    }

    private func getCategoryFilters(for cards: [ProductSwitcherCardItemModel]) -> [String] {
        var filterItemCounts: [String: Int] = [:]
        for card in cards {
            if let category = card.contentModel.category {
                filterItemCounts[category] = (filterItemCounts[category] ?? 0) + 1
            }
        }
        var filters: [String] = [allCategoryText]
        for (filterItem, filterCount) in filterItemCounts {
            filters.append("\(filterItem) (\(filterCount))")
        }
        return filters
    }

    /// - returns: A lowercased and punctuation free string for given string
    private func setupTextForSearch(_ text: String?) -> String {
        var updatedText = text?.lowercased()
        updatedText = updatedText?.components(separatedBy: CharacterSet.punctuationCharacters).joined(separator: "")
        return updatedText ?? ""
    }
}
