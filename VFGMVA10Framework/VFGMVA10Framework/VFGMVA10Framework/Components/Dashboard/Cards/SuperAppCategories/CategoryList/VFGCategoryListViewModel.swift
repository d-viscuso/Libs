//
//  VFGCategoryListViewModel.swift
//  VFGMVA10Framework
//
//  Created by Adel Aref on 26/10/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import Foundation

public class VFGCategoryListViewModel: VFGCategoryListViewModelProtocol {
    var model: VFGCategoriesModel?
    var sections: [VFGCategoriesSectionModel]?
    var sectionHeight: CGFloat? {
        return sections?.count == 1 ? 0 : 60
    }
    /// Creates a new instance of **VFGCategoryListViewModel** that holds logic for VFGCategoryListViewController.
    /// - Parameter model: A *VFGCategoriesModel* model of VFGCategoryListViewController.
    public required init(_ model: VFGCategoriesModel) {
        self.model = model
        self.sections = self.prepareSections(with: self.model?.categories ?? [])
    }

    /// get section title for category list for given index.
    /// - Parameter index: row of the current collection view cell.
    /// - Returns: A *String* value that indicates section title  of category list collectionView
    func getSectionTitleForIndexPath(at section: Int) -> String? {
        sections?[section].title
    }

    /// get number of items in sections for cateogry list collectionView .
    /// - Parameter index: Indexpath of the current collection view cell.
    /// - Returns: A *Int* value that indicates number of items in section of category list collectionView
    func getNumberOfItemsInSection(at section: Int) -> Int? {
        sections?[section].items?.count
    }

    /// get category title  in items for cateogry list collectionView .
    /// - Parameter index: Indexpath of the current collection view cell.
    /// - Returns: A *VFGCategoryModel* value that indicates category model of items in section of category list collectionView
    func getCategoryForItemInSection(at indexPath: IndexPath) -> VFGCategoryModel? {
        guard let sections = sections else {
            return nil
        }
        guard indexPath.section < sections.count, indexPath.item < sections[indexPath.section].items?.count ?? 0 else {
            return nil
        }
        return sections[indexPath.section].items?[indexPath.item]
    }

    private func prepareSections(with categories: [VFGCategoryModel]) -> [VFGCategoriesSectionModel] {
        var sections: [VFGCategoriesSectionModel] = []
        guard self.model?.isGroupingShowMoreCategoriesEnabled ?? false else {
            sections.append(VFGCategoriesSectionModel(title: nil, items: categories))
            return sections
        }
        var uniqueSectionTitles: [String] = []
        categories.forEach { category in
            if let title = category.categoryTypeName, !uniqueSectionTitles.contains(title) {
                uniqueSectionTitles.append(title)
            }
        }
        for title in uniqueSectionTitles {
            let sectionItems = categories.filter { $0.categoryTypeName == title }
            let section = VFGCategoriesSectionModel(title: title, items: sectionItems)
            sections.append(section)
        }
        return sections
    }
}
/// **VFGCategoryListViewModelProtocol** protocol is the viewModel of VFGCategoryListViewController.
/// This protocol is mandatory to make VFGCategoryListViewController works well.
protocol VFGCategoryListViewModelProtocol {
    var model: VFGCategoriesModel? { get }
    var sections: [VFGCategoriesSectionModel]? { get }
    /// sectionHeight hold 60 px in case of grouped categories and no need to hold value in case of no grouped categories.
    var sectionHeight: CGFloat? { get }
    /// get section title for category list for given index.
    /// - Parameter index: row of the current collection view cell.
    /// - Returns: A *String* value that indicates section title  of category list collectionView
    func getSectionTitleForIndexPath(at section: Int) -> String?
    /// get number of items in sections for cateogry list collectionView .
    /// - Parameter index: Indexpath of the current collection view cell.
    /// - Returns: A *Int* value that indicates number of items in section of category list collectionView
    func getNumberOfItemsInSection(at section: Int) -> Int?
    /// get category title  in items for cateogry list collectionView .
    /// - Parameter index: Indexpath of the current collection view cell.
    /// - Returns: A *VFGCategoryModel* value that indicates category model of items in section of category list collectionView
    func getCategoryForItemInSection(at indexPath: IndexPath) -> VFGCategoryModel?
}
