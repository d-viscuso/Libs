//
//  BalanceHistoryViewController+UITableView.swift
//  VFGMVA10Framework
//
//  Created by Ayman Ata on 14/09/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//


extension BalanceHistoryViewController: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        historyViewModel?.contentState == .loading ? 1 : historyViewModel?.filteredBalanceSections.count ?? 0
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        historyViewModel?.contentState == .loading ? 3 :
            historyViewModel?.numberOfBalanceSectionItems(at: section) ?? 0
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let shimmerCell = balanceHistoryTableView.dequeueReusableCell(
            withIdentifier: balanceHistoryItemCellShimmer,
            for: indexPath) as? BalanceHistoryItemCellShimmer
        if historyViewModel?.contentState == .loading {
            shimmerCell?.startShimmer()
            return shimmerCell ?? BalanceHistoryItemCellShimmer()
        } else {
            shimmerCell?.stopShimmer()
            return balanceHistoryCell(for: indexPath)
        }
    }
}

extension BalanceHistoryViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        historyViewModel?.contentState == .loading ?
        sectionHeaderShimmered(for: section) :
        sectionHeader(for: section)
    }

    func sectionHeader(for section: Int) -> UIView? {
        var header = UIView()
        if let sectionHeader = balanceHistoryTableView
            .dequeueReusableHeaderFooterView(withIdentifier: balanceHistorySectionHeader)
            as? BalanceHistorySectionHeader {
            sectionHeader.dateLabel.accessibilityIdentifier = "BHdataLabel\(section)"
            sectionHeader.date = historyViewModel?.filteredBalanceSections[section].title
            header = sectionHeader
        }
        header.layoutIfNeeded()
        return header
    }

    func sectionHeaderShimmered(for section: Int) -> UIView? {
        let header = UIView.loadXib(
            bundle: Bundle.mva10Framework,
            nibName: "BalanceHistorySectionHeaderShimmer") as? BalanceHistorySectionHeaderShimmer
        return header
    }
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sectionHeight
    }
}
