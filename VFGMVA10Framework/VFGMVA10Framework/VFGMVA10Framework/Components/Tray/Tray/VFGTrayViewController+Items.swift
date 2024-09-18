//
//  VFGTrayViewController+Items.swift
//  VFGMVA10Framework
//
//  Created by Mohamed Abd ElNasser on 5/9/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

extension VFGTrayViewController {
    func items(leftSide: Bool) -> [VFGTrayItemProtocol]? {
        guard let items = trayModel?.trayItems, !items.isEmpty else {
            VFGErrorLog("no items in trayModel")
            return nil
        }
        let slice: ArraySlice<VFGTrayItemProtocol>
        if leftSide {
            slice = items[0 ..< items.count / 2]
        } else {
            slice = items[items.count / 2 ..< items.count]
        }
        return Array(slice)
    }

    func drawLeftTrays() {
        let leftSection = items(leftSide: true) ?? []
        self.leftItemsStackView.removeSubviews()
        for count in 0 ..< leftSection.count {
            let tray = TrayItemView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
            setAccessibilityIdentifier(trayItem: tray, identifier: "\(count + 1)")
            tray.subTrayItemScale = subTrayItemScale
            tray.trayItem = leftSection[count].itemModel
            self.leftItemsStackView.addArrangedSubview(tray)
            setupTrayConstraints(tray, stackView: leftItemsStackView)
            tray.itemClick = { [weak self] item in
                self?.trayItemPressed(trayItem: item)
            }
            trayItemsView.append(tray)
            if leftSection.count > 1 {
                setLabelNumOfLines(label: tray.itemTitleLabel, numberOfLines: 1)
            }
        }
        leftItemsStackView.accessibilityIdentifier = "trayProducts"
    }

    func drawRightTrays() {
        let rightSection = items(leftSide: false) ?? []
        self.rightItemsStackView.removeSubviews()
        for count in 0 ..< rightSection.count {
            let tray = TrayItemView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
            let trayModel = rightSection[count].itemModel
            setAccessibilityIdentifier(trayItem: tray, identifier: "\(3 + (2 - rightSection.count) + count)")
            tray.subTrayItemScale = subTrayItemScale
            tray.trayItem = trayModel
            rightItemsStackView.addArrangedSubview(tray)
            setupTrayConstraints(tray, stackView: rightItemsStackView)
            tray.itemClick = {[weak self] item in
                self?.trayItemPressed(trayItem: item)
            }
            trayItemsView.append(tray)
            if rightSection.count > 1 {
                setLabelNumOfLines(label: tray.itemTitleLabel, numberOfLines: 1)
            }
        }
        rightItemsStackView.accessibilityIdentifier = "trayAccount"
    }

    private func setupTrayConstraints(_ tray: TrayItemView, stackView: UIStackView) {
        tray.heightAnchor.constraint(equalTo: stackView.heightAnchor, constant: 0).isActive = true
        tray.bottomAnchor.constraint(equalTo: stackView.bottomAnchor).isActive = true
    }
}
