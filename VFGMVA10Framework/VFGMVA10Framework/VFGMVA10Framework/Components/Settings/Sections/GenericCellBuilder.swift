//
//  GenericCellBuilder.swift
//  VFGMVA10Framework
//
//  Created by Amr Koritem on 08/05/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

/// Used to construct any table cell view
/// Example:
/// BaseSection(cellBuilders: [
///     GenericCellBuilder<NonNibCell>(),
///     GenericCellBuilder<NibCell>(nibName: "NibCell", bundle: .nibBundle)
/// ])
public class GenericCellBuilder<T: UITableViewCell>: TableViewCellBuilderProtocol {
    private let nibName: String?
    private let identifier: String
    private let height: CGFloat
    private let bundle: Bundle
    private let configure: ((T) -> Void)?
    /// *DisplayOptionsTableViewCellBuilder* initializer
    /// - Parameters:
    ///    - nibName: Nib name of the cell view. If the cell doesn't have a xib file, then pass nil.
    ///    - identifier: Cell identifier.
    ///    - height: Cell expected height.
    ///    - bundle: Bundle which the cell belongs to.
    ///    - configure: Configure method to be called on the cell when it is being dequeued.
    public init(
        nibName: String? = nil,
        identifier: String? = nil,
        height: CGFloat = UITableView.automaticDimension,
        bundle: Bundle = .mva10Framework,
        configure: ((UITableViewCell) -> Void)? = nil
    ) {
        self.nibName = nibName
        self.identifier = identifier ?? String(describing: T.self)
        self.height = height
        self.bundle = bundle
        self.configure = configure
    }

    public func registerCell(in tableView: UITableView) {
        guard let nibName = nibName else {
            tableView.register(T.self, forCellReuseIdentifier: identifier)
            return
        }
        tableView.register(
            UINib(
                nibName: nibName,
                bundle: bundle),
            forCellReuseIdentifier: identifier
        )
    }

    public func cellHeight() -> CGFloat {
        height
    }

    public func cellAt(indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: identifier,
            for: indexPath) as? T else {
            return UITableViewCell()
        }
        configure?(cell)
        return cell
    }
}
