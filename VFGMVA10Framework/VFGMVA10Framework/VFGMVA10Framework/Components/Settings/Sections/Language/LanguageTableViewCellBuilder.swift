//
//  LanguageTableViewCellBuilder.swift
//  VFGMVA10Framework
//
//  Created by Yahya Saddiq on 31/08/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import VFGMVA10Foundation
/// Delegation for language settings actions
public protocol LanguageSettingsProtocol: AnyObject {
    /// Action triggered when user select another language
    /// - Parameters:
    ///    - language: New language user selected
    func languageDidChange(language: LanguageModel)
}
/// Construct language settings section
public class LanguageTableViewCellBuilder: TableViewCellBuilderProtocol {
    private weak var delegate: LanguageSettingsProtocol?
    private var language: LanguageModel
    private let height: CGFloat
    /// *LanguageTableViewCellBuilder* initializer
    /// - Parameters:
    ///    - language: Langauge data model
    ///    - height: Language settings cell height
    ///    - delegate: Delegation for language settings actions
    public init(
        language: LanguageModel,
        height: CGFloat = 70,
        delegate: LanguageSettingsProtocol?
    ) {
        self.language = language
        self.height = height
        self.delegate = delegate
    }

    public func registerCell(in tableView: UITableView) {
        tableView.register(
            UINib(
                nibName: String(describing: VFGRadioCell.self),
                bundle: .foundation),
            forCellReuseIdentifier: String(describing: VFGRadioCell.self)
        )
    }

    public func cellHeight() -> CGFloat {
        height
    }

    public func cellAt(indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        guard let radioCell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: VFGRadioCell.self),
                for: indexPath) as? VFGRadioCell else {
            return UITableViewCell()
        }

        radioCell.configure(
            title: language.name,
            imageName: language.imageName,
            isFirstCell: indexPath.row == 0,
            isLastCell: (indexPath.row + 1) == tableView.numberOfRows(inSection: indexPath.section)
        )
        radioCell.enableButtonInteraction = false
        radioCell.selectionStyle = .none
        radioCell.onRadioButtonPress = { [weak self] in
            self?.radioButtonDidPress(at: indexPath, tableView: tableView)
        }

        return radioCell
    }

    public func didDeselectRowAt(indexPath: IndexPath, tableView: UITableView) {
        language.isCurrentLanguage?.toggle()
    }

    public func didSelectRowAt(indexPath: IndexPath, tableView: UITableView) {
        language.isCurrentLanguage?.toggle()
        delegate?.languageDidChange(language: language)
    }

    public func willDisplay(cell: UITableViewCell, indexPath: IndexPath, tableView: UITableView) {
        if let cell = cell as? VFGRadioCell {
            cell.setShadow()
        }

        if language.isCurrentLanguage == true {
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
    }
}

// MARK: - Private Methods
extension LanguageTableViewCellBuilder {
    private func radioButtonDidPress(at indexPath: IndexPath, tableView: UITableView) {
        tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        delegate?.languageDidChange(language: language)
    }
}
