//
//  TableViewCellBuilderProtocol.swift
//  VFGMVA10Framework
//
//  Created by Yahya Saddiq on 06/08/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

/// Settings table view cells configuration Protocol
public protocol TableViewCellBuilderProtocol {
    /// Cell registeration in settings table view
    /// - Parameters:
    ///    - tableView: Settings table view
    func registerCell(in tableView: UITableView)
    /// Cell height in settings table view
    func cellHeight() -> CGFloat
    /// Return settings table view cell
    /// - Parameters:
    ///    - indexPath: Cell index in settings table view
    ///    - tableView: Settings table view
    func cellAt(indexPath: IndexPath, tableView: UITableView) -> UITableViewCell
    /// Selected cell in settings table view
    /// - Parameters:
    ///    - indexPath: Cell index in settings table view
    ///    - tableView: Settings table view
    func didSelectRowAt(indexPath: IndexPath, tableView: UITableView)
    /// Deselected cell in settings table view
    /// - Parameters:
    ///    - indexPath: Cell index in settings table view
    ///    - tableView: Settings table view
    func didDeselectRowAt(indexPath: IndexPath, tableView: UITableView)
    /// Handle actions before cell display in settings table view
    /// - Parameters:
    ///    - cell: Cell that will be displayed in settings table view
    ///    - indexPath: Cell index in settings table view
    ///    - tableView: Settings table view
    func willDisplay(cell: UITableViewCell, indexPath: IndexPath, tableView: UITableView)
}

extension TableViewCellBuilderProtocol {
    public func didSelectRowAt(indexPath: IndexPath, tableView: UITableView) {}
    public func didDeselectRowAt(indexPath: IndexPath, tableView: UITableView) {}
    public func willDisplay(cell: UITableViewCell, indexPath: IndexPath, tableView: UITableView) {}
}
