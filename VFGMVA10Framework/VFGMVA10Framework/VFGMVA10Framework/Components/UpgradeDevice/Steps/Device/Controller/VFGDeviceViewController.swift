//
//  VFGChooseDeviceSpecificationViewController.swift
//  VFGMVA10Framework
//
//  Created by SAMEH on 18/05/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

class VFGDeviceViewController: UIViewController, VFGBaseUpgradeStepsViewControllerProtocol {
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    // MARK: - Attributes
    var onStepComplete: ((Any) -> Void)?
    var onContentHeightChange: ((CGFloat) -> Void)?
    var onPriceChange: ((Any) -> Void)?
    var onStepStatusChange: ((VFGStepStatus) -> Void)?
    var status: VFGStepStatus = .pending {
        didSet {
            viewModel.stepStatus = status
        }
    }

    static var instance: VFGBaseUpgradeStepsViewControllerProtocol {
        return VFGDeviceViewController()
    }

    var stepTitle: String = "device_upgrade_device_step_title".localized(bundle: .mva10Framework)

    lazy var viewModel: VFGDeviceViewModel = {
        VFGDeviceViewModel(dataProvider: VFGDeviceDataProvider())
    }()

    let deviceImageCellId = "VFGDeviceImageCell"
    let collectionAndDeliverySelectionCellId = "VFGDeviceCollectionAndDeliveryCell"
    let capacitySelectionCellId = "VFGDeviceCapacitySelectionCell"
    let colorSelectionCellId = "VFGDeviceColorSelectionCell"
    let deviceOverviewCellId = "VFGDeviceOverviewCell"
    let moreInfoCellId = "VFGDeviceMoreInfoCell"
    let continueCellId = "VFGDeviceContinueCell"
    let specificationCellId = "VFGDeviceSpecificationCell"
    let collectionAndDeliveryHeight: CGFloat = 190
    let headerViewHeight: CGFloat = 70
    let footerViewHeight: CGFloat = 130

    init() {
        super.init(nibName: "\(VFGDeviceViewController.self)", bundle: .mva10Framework)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        initViewModel()
        initUpdateDeviceColors()
        initUpdateDeviceCapacities()
        initUpdateDeviceSpecifications()
        initDidUpdateDevice()
        initStepStatus()
    }
}

extension VFGDeviceViewController {
    func initViewModel() {
        viewModel.updateLoadingStatus = { [weak self] in
            guard let self = self else {
                return
            }

            switch self.viewModel.contentState {
            case .loading:
                self.tableView.reloadData()
            case .populated:
                VFGDebugLog("populated")
                self.tableView.reloadData()
            case .empty:
                VFGDebugLog("empty")
            case .error:
                VFGDebugLog("error")
            case .filtered:
                VFGDebugLog("filter")
            }
        }
    }

    func initUpdateDeviceColors() {
        viewModel.updateDeviceColors = { [weak self] in
            guard
                let self = self,
                let section = self.viewModel.sectionsDatasource
                    .firstIndex(where: { $0.items.contains(.colorSelection) }),
                let row = self.viewModel.sectionsDatasource[section].items.firstIndex(where: { $0 == .colorSelection }),
                let cell = self.tableView.cellForRow(
                    at: IndexPath(row: row, section: section))
                    as? VFGDeviceColorSelectionCell
            else { return }

            cell.colorSelectionView.collectionView.reloadData()
        }
    }

    func initUpdateDeviceCapacities() {
        viewModel.updateDeviceCapacities = { [weak self] in
            guard
                let self = self,
                let section = self.viewModel.sectionsDatasource
                    .firstIndex(where: { $0.items.contains(.capcitySelection) }),
                let row = self.viewModel.sectionsDatasource[section].items
                    .firstIndex(where: { $0 == .capcitySelection }),
                let cell = self.tableView.cellForRow(
                    at: IndexPath(row: row, section: section))
                    as? VFGDeviceCapacitySelectionCell
            else { return }

            cell.capacitySelectionView.collectionView.reloadData()
        }
    }

    func initUpdateDeviceSpecifications() {
        viewModel.updateDeviceSpecifications = { [weak self] in
            guard
                let self = self,
                let section = self.viewModel.sectionsDatasource
                    .firstIndex(where: { $0.items.contains(.specifications) }),
                let row = self.viewModel.sectionsDatasource[section].items.firstIndex(where: { $0 == .specifications }),
                let cell = self.tableView.cellForRow(at: IndexPath(row: row, section: section))
                    as? VFGDeviceSpecificationCell
            else { return }

            cell.dataSource = self.viewModel
        }
    }

    func initDidUpdateDevice() {
        viewModel.didUpdateDevice = { [weak self] in
            defer {
                if let self = self, let selectedDevice = self.viewModel.selectedDevice {
                    self.onPriceChange?(selectedDevice)
                }
            }
            guard
                let self = self,
                let selectedDevice = self.viewModel.selectedDevice,
                let section = self.viewModel.sectionsDatasource
                .firstIndex(where: { $0.items.contains(.deviceImage) }),
                let row = self.viewModel.sectionsDatasource[section].items.firstIndex(where: { $0 == .deviceImage }),
                let cell = self.tableView.cellForRow(at: IndexPath(row: row, section: section)) as? VFGDeviceImageCell
            else { return }
            // Update device image
            cell.updateImage(image: selectedDevice.imageUrl ?? "")
        }
    }

    func initStepStatus() {
        viewModel.onStepStatusChange = onStepStatusChange
    }
}

// MARK: - Expand
extension VFGDeviceViewController {
    func expandableSectionHeaderDidPress(sectionIndex: Int) {
        var section = viewModel.sectionsDatasource[sectionIndex]
        section.header?.isCellsCollapsed.toggle()
        viewModel.sectionsDatasource[sectionIndex] = section
        tableView.beginUpdates()
        // row is zero as all the expandable sections has only one row
        tableView.reloadRows(at: [IndexPath(row: 0, section: sectionIndex)], with: .automatic)
        tableView.endUpdates()
    }
}

extension VFGDeviceViewController: VFGDeviceContinueCellDelegate {
    func continueButtonDidPress() {
        guard let selectedDevice = viewModel.selectedDevice
            else { return }
        viewModel.addSelectedValuesToPreviousState()
        status = .passed
        onStepComplete?((device: selectedDevice, collectionAndDelivery: viewModel.collectionAndDelivery))
    }
}

extension VFGDeviceViewController {
    func fetchData() {
        viewModel.fetchDevices()
    }
}
