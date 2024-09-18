//
//  StoryGridLayoutView.swift
//  StoryGridLayout
//
//  Created by Ahmed AbdElnabi on 18/07/2022.
//

import UIKit
import VFGMVA10Foundation

class StoryGridLayoutView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var gridStackView: UIStackView!

    var dataSource: StoryGridLayoutDataSource? {
        didSet {
            reloadData()
        }
    }
    var delegate: StoryGridLayoutDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
        uiSetup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        xibSetup()
        uiSetup()
    }

    func reloadData() {
        uiSetup()
    }

    private func xibSetup() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "StoryGridLayoutView", bundle: bundle)
        nib.instantiate(withOwner: self, options: nil)
        addSubview(contentView ?? UIView())
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }

    private func uiSetup() {
        gridStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        if let firstRow = dataSource?.gridLayoutData()?.firstRow {
            setupRow(with: firstRow)
        }
        if let secondRow = dataSource?.gridLayoutData()?.secondRow {
            setupRow(with: secondRow)
        }
    }

    private func setupRow(with row: GridRowData) {
        guard let gridRowView = StoryGridRowView.loadXib(
            bundle: .mva10Framework,
            nibName: String(describing: StoryGridRowView.self)
        ) as? StoryGridRowView else {
            return
        }
        gridRowView.configure(with: row)
        gridRowView.gridLayoutDelegate = delegate
        gridStackView.addArrangedSubview(gridRowView)
    }
}
