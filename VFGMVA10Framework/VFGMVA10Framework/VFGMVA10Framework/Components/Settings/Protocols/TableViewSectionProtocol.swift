//
//  TableViewSectionProtocol.swift
//  VFGMVA10Framework
//
//  Created by Yahya Saddiq on 06/08/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

/// Settings table view section configuration Protocol
public protocol TableViewSectionProtocol {
    /// Array list of settings table view cells constructors
    var cellBuilders: [TableViewCellBuilderProtocol] { get set }
    /// Number of rows in settings table view section
    func numberOfRows() -> Int
    /// Settings table view section header height
    func heightForHeader() -> CGFloat
    /// Settings table view section header view
    /// - Parameters:
    ///    - tableView: Settings table view
    func headerView(for tableView: UITableView) -> UIView?
    /// Settings table view section height
    /// - Parameters:
    ///    - indexPath: Section index in settings table view
    func cellHeightFor(indexPath: IndexPath) -> CGFloat
    /// Settings table view section cell
    /// - Parameters:
    ///    - indexPath: Section index in settings table view
    ///    - tableView: Settings table view
    func cellAt(indexPath: IndexPath, tableView: UITableView) -> UITableViewCell
    /// Selected section cell in settings table view
    /// - Parameters:
    ///    - indexPath: Section cell index in settings table view
    ///    - tableView: Settings table view
    func didSelectRowAt(indexPath: IndexPath, tableView: UITableView)
    /// Deselected section cell in settings table view
    /// - Parameters:
    ///    - indexPath: Section cell index in settings table view
    ///    - tableView: Settings table view
    func didDeselectRowAt(indexPath: IndexPath, tableView: UITableView)
    /// Handle actions before section cell display in settings table view
    /// - Parameters:
    ///    - cell: Section cell that will be displayed in settings table view
    ///    - indexPath: Section cell index in settings table view
    ///    - tableView: Settings table view
    func willDisplay(cell: UITableViewCell, indexPath: IndexPath, tableView: UITableView)
    /// Section cell registeration in settings table view
    /// - Parameters:
    ///    - tableView: Settings table view
    func registerCells(in tableView: UITableView)
}
