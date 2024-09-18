//
//  DashboardUsageCard.swift
//  VFGMVA10Group
//
//  Created by Mahmoud Amer on 7/23/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

/// Dashboard usage card. The view that holds the usage cards like data usage, bundle usage, local call usage, etc...
/// Also holds page control indicator and edit tiles card.
public class DashboardUsageCard: UIView {
    @IBOutlet weak var pageControl: VFGPageControl!
    @IBOutlet weak var collectionView: UICollectionView!
    /// Dashboard error card in case of data request failed
    public var errorCard: ErrorCard?
    /// Boolean that detrmine if the edit tiles card would be shown or not, default is false. Edit tile will always be the last card.
    public var isEditable = false

    private let mainCardId = "MainCardCell"
    private let nibName = "VFGBalanceCardCell"
    private let editTilesNibName = "EditTilesCardCell"
    private let subTrayActionKey = "sub_tray_product_action"

    private var usageCardsConfiguration: [CustomizationCardConfigurationModel] = []
    private var visibleUsageCardsConfiguration: [CustomizationCardConfigurationModel] = []
    private var usageCards: [BalanceAndProductsModel.Bucket] = []
    private var lastItemIndex: Int { (numberOfItems - 1) }
    private var numberOfItems: Int {
        visibleUsageCardsConfiguration.count + (isEditable ? 1 : 0)
    }

    public override func awakeFromNib() {
        super.awakeFromNib()

        setupCollectionView()
    }
    /// Add cards to dashboard usage card
    /// - Parameters:
    ///    - usageCards: Cards to be added to dashboard usage card
    ///    - usageCardsConfiguration: Configuration of cards inside dashboard usage card
    public func set(usageCards: [BalanceAndProductsModel.Bucket]?, usageCardsConfiguration: [CustomizationCardConfigurationModel] = []) {
        guard let usageCards = usageCards, !usageCards.isEmpty else {
            showErrorMessage(errorMessage: "No usage cards")
            return
        }

        self.usageCards = usageCards
        self.usageCardsConfiguration = usageCardsConfiguration

        removeConfigurationsOfDeletedUsageCards()
        addNewUsageCardsConfiguration()
        notifyConfigurationChangesIfRequired(usageCardsConfiguration)
    }

    private func addNewUsageCardsConfiguration() {
        visibleUsageCardsConfiguration = usageCardsConfiguration.filter {
            $0.isHidden == false
        }

        usageCards.forEach { usageCard in
            guard
                let usageType = usageCard.usageType,
                usageCardsConfiguration.first(where: { $0.usageType == usageType }) == nil else {
                return
            }

            let usageCardConfiguration = CustomizationCardConfigurationModel(
                usageType: usageType,
                index: visibleUsageCardsConfiguration.count,
                isHidden: false,
                isDefault: usageCard.isDefault ?? false
            )

            usageCardsConfiguration.append(usageCardConfiguration)
            visibleUsageCardsConfiguration.append(usageCardConfiguration)
        }
    }

    // Remove configuration of deleted usage Cards
    private func removeConfigurationsOfDeletedUsageCards() {
        let uniqueUsageCardTypes = usageCards.map { $0.usageType ?? "" }

        usageCardsConfiguration = usageCardsConfiguration.filter {
            uniqueUsageCardTypes.contains($0.usageType)
        }

        // reset indices
        var sorted = usageCardsConfiguration.sorted { $0.index < $1.index }
        for index in sorted.indices {
            sorted[index].index = index
        }

        usageCardsConfiguration = sorted
    }

    private func notifyConfigurationChangesIfRequired(
        _ usageCardsConfiguration: [CustomizationCardConfigurationModel]
    ) {
        if self.usageCardsConfiguration.count != usageCardsConfiguration.count {
            NotificationCenter.default.post(
                name: .UsageCardsDidChange,
                object: self.usageCardsConfiguration
            )
        }
    }
    /// Reload cards inside dashboard usage cards
    /// - Parameters:
    ///    - usageCardsConfiguration: New cards configuration
    public func reloadUsageCards(with usageCardsConfiguration: [CustomizationCardConfigurationModel] = []) {
        if !usageCardsConfiguration.isEmpty {
            self.usageCardsConfiguration = usageCardsConfiguration
            visibleUsageCardsConfiguration = usageCardsConfiguration.filter {
                $0.isHidden == false
            }
        }
        collectionView.reloadData()
    }
    /// Handle showing error card
    /// - Parameters:
    ///    - errorMessage: Message to display error
    public func showErrorMessage(errorMessage: String?) {
        errorCard = ErrorCard.loadXib(bundle: Bundle.foundation)
        errorCard?.configure(
            errorMessage: errorMessage?.localized(),
            tryAgainMessage: "dashboard_item_error_normal_try_again_button".localized(bundle: Bundle.mva10Framework),
            accessibilityIdInitial: accessibilityIdentifier)

        errorCard?.frame = self.bounds
        pageControl.isHidden = true
        self.addSubview(errorCard ?? UIView())
    }
    /// Dashboard usage card collection view configuration
    func setupCollectionView() {
        pageControl.isHidden = false
        pageControl.isSymmetricStyle = true
        if UIApplication.isRightToLeft {
            pageControl.semanticContentAttribute = .forceRightToLeft
        } else {
            pageControl.semanticContentAttribute = .forceLeftToRight
        }
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        collectionView.setCollectionViewLayout(flowLayout, animated: false)
        collectionView.register(
            UINib(
                nibName: nibName,
                bundle: Bundle.mva10Framework),
            forCellWithReuseIdentifier: mainCardId)
        collectionView.register(
            UINib(
                nibName: editTilesNibName,
                bundle: Bundle.mva10Framework),
            forCellWithReuseIdentifier: editTilesNibName)
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        collectionView.accessibilityIdentifier = "DBusageCards"
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

extension DashboardUsageCard: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectCardAtIndex(indexPath: indexPath)
    }
    /// Dashboard usage card collection view cell press action
    /// - Parameters:
    ///    - indexPath: Pressed cell index
    public func didSelectCardAtIndex(indexPath: IndexPath) {
        if isEditable && indexPath.row == lastItemIndex {
            MainTileCustomizationViewController.present(with: usageCardsConfiguration)
        } else {
            VFGManagerFramework.trayDelegate?.trayActions()[subTrayActionKey]?()
        }
    }
}

extension DashboardUsageCard: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        pageControl.numberOfPages = numberOfItems
        pageControl.centerDots = numberOfItems
        return numberOfItems
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)
    -> UICollectionViewCell {
        if isEditable && indexPath.row == lastItemIndex {
            guard let editTileCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: editTilesNibName,
                for: indexPath) as? EditTilesCardCell else {
                return UICollectionViewCell()
            }
            editTileCell.configure()
            return editTileCell
        } else if let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: mainCardId,
            for: indexPath) as? VFGBalanceCardCell,
            let configuration = visibleUsageCardsConfiguration.first(
            where: { $0.index == indexPath.row }),
            let usageCard = usageCards.first(
            where: { $0.usageType == configuration.usageType }) {
            let viewModel = BalanceViewModel(usageCard)
            cell.configure(with: viewModel)
            return cell
        }

        return UICollectionViewCell()
    }
    /// Handle dashboard usage card collection view scrolling
    /// - Parameters:
    ///    - scrollView: Dashboard usage card scroll view
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.x / scrollView.frame.size.width
        let pageNumber = round(currentOffset)
        pageControl.currentPage = Int(pageNumber)

        let rightCellIndex = Int(ceil(currentOffset))
        let rightCell = collectionView
            .cellForItem(at: IndexPath(row: rightCellIndex, section: 0)) as? VFGBalanceCardCell
        adjustCellHeaderAlpha(balanceCardCell: rightCell)

        let leftCellIndex = Int(floor(currentOffset))
        let leftCell = collectionView
            .cellForItem(at: IndexPath(row: leftCellIndex, section: 0)) as? VFGBalanceCardCell
        leftCell?.titleLabel.alpha = 1
        leftCell?.iconImageView.alpha = 1
    }
    /// Adjust dashboard usage card content header alpha value
    /// - Parameters:
    ///    - balanceCardCell: Balance cell inside dashboard usage card
    func adjustCellHeaderAlpha(balanceCardCell: VFGBalanceCardCell?) {
        guard let cell = balanceCardCell,
            let currentXPosition = cell.superview?.convert(cell.frame.origin, to: nil).x else { return }
        let cellWidth = cell.frame.size.width
        let pageControlWidth = pageControl.frame.size.width
        let titleWidth = cell.titleLabel.frame.size.width
        let iconWidth = cell.iconImageView.frame.size.width
        let currentOffset = cellWidth - currentXPosition - pageControlWidth - titleWidth - iconWidth
        let alphaAcceleration: CGFloat = 3
        let newAlpha = (currentOffset * alphaAcceleration) / cellWidth
        cell.titleLabel.alpha = newAlpha
        cell.iconImageView.alpha = newAlpha

        if VFGUser.shared.type == .payM {
            guard let title = cell.titleLabel.text else { return }
            track(with: title)
        }
    }
    /// Track dashboard usage card actions
    /// - Parameters:
    ///    - title: Dashboard usage card current cell title
    func track(with title: String) {
        var eventLabel = ""
        if title.contains("phone") || title.contains("Data") {
            eventLabel = "analytics_framework_event_label_giga".localized(bundle: .mva10Framework)
        } else {
            eventLabel = title
        }
        VFGDashboardManager.trackAction(
            event: "analytics_framework_event_title_ui_interaction".localized(bundle: .mva10Framework),
            eventLabel: eventLabel)
    }
}

extension DashboardUsageCard: UICollectionViewDelegateFlowLayout {
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: bounds.width, height: bounds.height)
    }
}
