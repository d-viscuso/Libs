//
//  StoryGridRowView.swift
//  StoryGridLayout
//
//  Created by Ahmed AbdElnabi on 18/07/2022.
//

import UIKit

class StoryGridRowView: UIView {
    @IBOutlet weak var gridHorizotalStackView: UIStackView!

    var gridLayoutDelegate: StoryGridLayoutDelegate?

    func configure(with row: GridRowData) {
        gridHorizotalStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        setupItem(with: row.firstItem)
        setupItem(with: row.secondItem)
    }

    private func setupItem(with item: GridItemData) {
        guard let gridItemView = StoryGridItemView.loadXib(
            bundle: .mva10Framework,
            nibName: String(describing: StoryGridItemView.self)
        ) as? StoryGridItemView else {
            return
        }
        gridItemView.configure(with: item)
        gridItemView.onGridItemDidPress = { [weak self] item in
            guard let self = self else { return }

            self.gridLayoutDelegate?.gridLayout(itemDidPress: item)
        }
        gridHorizotalStackView.addArrangedSubview(gridItemView)
    }
}
