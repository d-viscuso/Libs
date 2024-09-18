//
//  EditDashboardTilesTableViewCellBuilder.swift
//  VFGMVA10Framework
//
//  Created by Ashraf Dewan on 15/08/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import VFGMVA10Foundation
/// Construct edit dashboard tiles cell
public class EditDashboardTilesTableViewCellBuilder: TableViewCellBuilderProtocol {
    private let height: CGFloat
    private let usageCardsConfiguration: [CustomizationCardConfigurationModel]?
    private let tertiaryTilesDataProvider: TertiaryTileCustomizationDataProviderProtocol?
    private weak var delegate: SettingsViewControllerDelegate?
    private var model: VFGDashboardSettingModel
    /// *EditDashboardTilesTableViewCellBuilder* initializer
    /// - Parameters:
    ///    - usageCardsConfiguration: List of usage cards data model
    ///    - tertiaryTilesDataProvider: Delegation for dashboard tiles data provider
    ///    - height: Edit dashboard tiles cell height
    ///    - delegate: Delegation for *SettingsViewController* actions
    ///    - model: Dashboard settings model
    public init(
        usageCardsConfiguration: [CustomizationCardConfigurationModel]? = nil,
        tertiaryTilesDataProvider: TertiaryTileCustomizationDataProviderProtocol? = nil,
        height: CGFloat,
        delegate: SettingsViewControllerDelegate?,
        model: VFGDashboardSettingModel
    ) {
        self.usageCardsConfiguration = usageCardsConfiguration
        self.tertiaryTilesDataProvider = tertiaryTilesDataProvider
        self.height = height
        self.delegate = delegate
        self.model = model
    }

    public func registerCell(in tableView: UITableView) {
        tableView.register(
            UINib(
                nibName: String(describing: VFGChevronCell.self),
                bundle: .mva10Framework),
            forCellReuseIdentifier: String(describing: VFGChevronCell.self)
        )
    }

    public func cellHeight() -> CGFloat {
        height
    }

    public func cellAt(indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        guard let editDashboardTilesCell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: VFGChevronCell.self),
                for: indexPath) as? VFGChevronCell else {
            return UITableViewCell()
        }
        editDashboardTilesCell.configure(
            title: model.title,
            titleFont: model.titleFont,
            iconImageName: model.icon,
            type: model.type
        )
        editDashboardTilesCell.selectionStyle = .none
        return editDashboardTilesCell
    }

    public func didSelectRowAt(indexPath: IndexPath, tableView: UITableView) {
        if let usageCardsConfiguration = usageCardsConfiguration {
            let mainTileCustomizationViewController = MainTileCustomizationViewController.instance()
                as MainTileCustomizationViewController
            mainTileCustomizationViewController.usageCardsConfiguration = usageCardsConfiguration

            delegate?.push(viewController: mainTileCustomizationViewController, animated: true)
        } else if let tertiaryTilesDataProvider = tertiaryTilesDataProvider {
            let tertiaryTileCustomizationViewController = TertiaryTileCustomizationViewController.instance()
                as TertiaryTileCustomizationViewController
            tertiaryTileCustomizationViewController.viewModel =
                TertiaryTileCustomizationViewModel(dataProvider: tertiaryTilesDataProvider)
            delegate?.push(viewController: tertiaryTileCustomizationViewController, animated: true)
        }
    }
}
