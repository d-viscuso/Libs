//
//  BaseSection.swift
//  VFGMVA10Framework
//
//  Created by Yahya Saddiq on 06/08/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//
/// App settings and permissions base section
public class BaseSection: TableViewSectionProtocol {
    public var cellBuilders: [TableViewCellBuilderProtocol]
    /// Base section title
    var title: String?
    /// Base section subtitle
    var subtitle: String?
    /// Base section custom header height
    var customHeaderHeight: CGFloat?
    /// Base section type
    public var type: VFGTableViewSectionType = .plainText
    /// *BaseSection* initializer
    /// - Parameters:
    ///    - cellBuilders: Array list of base section items
    ///    - title: Base section title
    ///    - subtitle: Base section subtitle
    ///    - customHeaderHeight: Base section custom header height
    ///    - headerType: Base section type
    public init(
        cellBuilders: [TableViewCellBuilderProtocol],
        title: String? = nil,
        subtitle: String? = nil,
        customHeaderHeight: CGFloat? = nil,
        headerType: VFGTableViewSectionType = .plainText
    ) {
        self.cellBuilders = cellBuilders
        self.title = title
        self.subtitle = subtitle
        self.customHeaderHeight = customHeaderHeight
        self.type = headerType
    }

    public func registerCells(in tableView: UITableView) {
        for cellBuilder in cellBuilders {
            cellBuilder.registerCell(in: tableView)
        }
    }

    public func numberOfRows() -> Int {
        cellBuilders.count
    }

    public func heightForHeader() -> CGFloat {
        customHeaderHeight ?? 0
    }

    public func headerView(for tableView: UITableView) -> UIView? {
        nil
    }

    public func cellHeightFor(indexPath: IndexPath) -> CGFloat {
        cellBuilders[indexPath.row].cellHeight()
    }

    public func cellAt(indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        cellBuilders[indexPath.row].cellAt(indexPath: indexPath, tableView: tableView)
    }

    public func didSelectRowAt(indexPath: IndexPath, tableView: UITableView) {
        cellBuilders[indexPath.row].didSelectRowAt(indexPath: indexPath, tableView: tableView)
    }

    public func didDeselectRowAt(indexPath: IndexPath, tableView: UITableView) {
        cellBuilders[indexPath.row].didDeselectRowAt(indexPath: indexPath, tableView: tableView)
    }

    public func willDisplay(cell: UITableViewCell, indexPath: IndexPath, tableView: UITableView) {
        cellBuilders[indexPath.row].willDisplay(cell: cell, indexPath: indexPath, tableView: tableView)
    }
}
