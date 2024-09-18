//
//  DisplayOptionsTableViewCellBuilder.swift
//  VFGMVA10Framework
//
//  Created by Yahya Saddiq on 06/08/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

/// Construct display options cell
public class DisplayOptionsTableViewCellBuilder: TableViewCellBuilderProtocol {
    private let userDefaultOverrideStyleKey = "overrideUserInterfaceStyle"
    private var userDefaults = UserDefaults.standard
    private let height: CGFloat
    /// *DisplayOptionsTableViewCellBuilder* initializer
    /// - Parameters:
    ///    - height: Display options cell height
    public init(height: CGFloat) {
        self.height = height
    }

    public func registerCell(in tableView: UITableView) {
        tableView.register(
            UINib(
                nibName: String(describing: VFGDisplayOptionsCell.self),
                bundle: .mva10Framework),
            forCellReuseIdentifier: String(describing: VFGDisplayOptionsCell.self)
        )
    }

    public func cellHeight() -> CGFloat {
        height
    }

    public func cellAt(indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        guard let displayOptionsCell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: VFGDisplayOptionsCell.self),
                for: indexPath) as? VFGDisplayOptionsCell else {
            return UITableViewCell()
        }
        displayOptionsCell.delegate = self
        displayOptionsCell.selectionStyle = .none
        return displayOptionsCell
    }
}

extension DisplayOptionsTableViewCellBuilder: VFGDisplayOptionsDelegate {
    public func styleDidChange(to value: VFGDisplayOptions) {
        userDefaults.setValue(
            value.rawValue,
            forKey: userDefaultOverrideStyleKey)

        let userInfo: [String: Int] = [userDefaultOverrideStyleKey: value.rawValue]
        NotificationCenter.default.post(
            name: Notification.Name(userDefaultOverrideStyleKey),
            object: nil,
            userInfo: userInfo)
    }

    public func currentStyle() -> VFGDisplayOptions {
        let cachedStyleValue = userDefaults.integer(forKey: userDefaultOverrideStyleKey)
        return VFGDisplayOptions(rawValue: cachedStyleValue) ?? .auto
    }
}
/// List of display styles
public enum VFGDisplayOptions: Int {
    case light = 1
    case dark = 2
    case auto = 0
}
