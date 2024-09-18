//
//  VFGMoreViewModel.swift
//  VFGMVA10Framework
//
//  Created by Adel Aref on 21/11/2022.
//

import Foundation

/// init VFGMoreViewModel

public class VFGMoreViewModel {
    let model: VFGMoreModel

    /// init HighlightsCardsViewModel
    public init(with model: VFGMoreModel) {
        self.model = model
    }
    let lineSpacing = CGFloat(8)
    let margin = CGFloat(16)
    let insetForSection = CGFloat(28)
    let titleHeaderHeight = CGFloat(40)
    let heightToWidthRatio = CGFloat(1.1)
    let visibleCellsCount = CGFloat(2)
    let listCellHeight = CGFloat(48)
    let hoirzontalCardsCellHeight = CGFloat(190)
    let horizontalCardsViewHeight = CGFloat(300)
    let listSectionsCount = 1
    var verticalCardCellWidth: CGFloat {
        let totalMargin = 2 * margin
        let totalSpacing = totalMargin + lineSpacing
        return (UIScreen.main.bounds.width - totalSpacing) / visibleCellsCount
    }

    var verticalCardCellHeight: CGFloat {
        return verticalCardCellWidth * heightToWidthRatio
    }

    var horizontalCardsCellWidth: CGFloat {
        return (UIScreen.main.bounds.width)
    }

    var listCellWidth: CGFloat {
        let totalSpacing = margin * 2
        return (UIScreen.main.bounds.width - totalSpacing)
    }

    public var overlayHeight: CGFloat {
        let bottomSpace = CGFloat(50)
        let sectionHeaderHeight = CGFloat(40)
        if isVerticalCards {
            let section = 0
            let numOfRows = (CGFloat(getNumberOfItemsInSection(for: section)) / 2.0).rounded()
            let rowsHeight = numOfRows * verticalCardCellHeight
            let totalSpace = margin * (numOfRows)
            let totalHeight = rowsHeight + totalSpace + bottomSpace + sectionHeaderHeight
            return CGFloat(totalHeight)
        } else if isHorizontalCards {
            return horizontalCardsViewHeight + bottomSpace + sectionHeaderHeight
        } else if isListOnly {
            return calculateListHeight(for: 0) + bottomSpace + sectionHeaderHeight
        } else if isListAndCards {
            let sections = model.sections ?? []
            for (index, section) in sections.enumerated() where section.sectionType == .list {
                let listHeight = calculateListHeight(for: index)
                let totalHeight = listHeight + horizontalCardsViewHeight + bottomSpace + sectionHeaderHeight
                return totalHeight
            }
            return horizontalCardsViewHeight + bottomSpace + sectionHeaderHeight
        } else {
            return 0.0
        }
    }

    func calculateListHeight(for index: Int) -> CGFloat {
        let listItemsCount = Float(getNumberOfItemsInSection(for: index))
        let totalSpace = CGFloat(listItemsCount) * lineSpacing
        let listHeight = listCellHeight * CGFloat(listItemsCount)
        let totalHeight = CGFloat(listHeight) + totalSpace
        return totalHeight
    }

    /// numOfSections always is equal to
    var numOfSections: Int {
        return model.sections?.count ?? 0
    }

    var isVerticalCards: Bool {
        if let count = model.sections?.count, count == 1,
        model.sections?.first?.sectionType == .cards,
        model.sections?.first?.directionType == .vertical {
            return true
        }
        return false
    }

    var isListOnly: Bool {
        if numOfSections == listSectionsCount,
        getSectionType(for: 0) == .list {
            return true
        }
        return false
    }

    var isListAndCards: Bool {
        if let sections = model.sections, sections.count == 2 {
            return true
        }
        return false
    }

    var isHorizontalCards: Bool {
        if let count = model.sections?.count, count == 1,
        model.sections?.first?.sectionType == .cards,
        model.sections?.first?.directionType == .horizontal {
            return true
        }
        return false
    }

    var isSearchBarIsEnabled: Bool {
        return model.isSearchBarIsEnabled ?? false
    }

    func getNumberOfItemsInSection(for section: Int) -> Int {
        let type = getSectionType(for: section)
        switch type {
        case .cards:
            return isVerticalCards ? (model.sections?[section].items?.count ?? 0) : 1
        case .list:
            return model.sections?[section].items?.count ?? 0
        default:
            return 0
        }
    }

    func getSectionType(for section: Int) -> SectionType? {
        guard section < model.sections?.count ?? 0 else {
            return nil
        }
        return model.sections?[section].sectionType
    }

    func getSection(for section: Int) -> VFGMoreSectionModel? {
        guard section < model.sections?.count ?? 0 else {
            return nil
        }
        return model.sections?[section]
    }
}
