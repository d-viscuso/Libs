//
//  VFGDeviceViewModel.swift
//  VFGMVA10Framework
//
//  Created by SAMEH on 18/05/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

class VFGDeviceViewModel: VFGDeviceViewModelDeviceDataSource {
    private var dataProvider: VFGDeviceDataProviderProtocol
    private var devices: [ChooseDeviceModel.Device] = []
    private(set) var collectionAndDelivery: [VFGDeviceModel.CollectionAndDelivery] = []
    var contentState: VFGContentState = .empty {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    var stepStatus: VFGStepStatus?
    var updateLoadingStatus: (() -> Void)?
    var updateDeviceCapacities: (() -> Void)?
    var updateDeviceColors: (() -> Void)?
    var updateDeviceSpecifications: (() -> Void)?
    var didUpdateDevice: (() -> Void)?
    var onStepStatusChange: ((VFGStepStatus) -> Void)?
    var previousSelectedDevice: ChooseDeviceModel.Device?
    var previousSelectedColor: ChooseDeviceModel.Device.Color?
    var previousSelectedCapacity: ChooseDeviceModel.Device.Capacity?
    var selectedDeviceFileName: String?
    var selectedDevice: ChooseDeviceModel.Device? {
        didSet {
            updateDeviceSpecifications?()
        }
    }
    var selectedColor: ChooseDeviceModel.Device.Color? {
        didSet {
            updateSelectedDevice()
            updateSelectedCapacity()
            updateDeviceCapacities?()
            guard let previousSelectedColor = previousSelectedColor else { return }
            let isSameDevice = selectedDevice == previousSelectedDevice
            let isSameColor = selectedColor == previousSelectedColor
            let isPassedMode = isSameColor && isSameDevice
            onStepStatusChange?(isPassedMode ? .passed : .pending)
        }
    }
    var selectedCapacity: ChooseDeviceModel.Device.Capacity? {
        didSet {
            updateSelectedDevice()
            guard let previousSelectedCapacity = previousSelectedCapacity else { return }
            let isSameDevice = selectedDevice == previousSelectedDevice
            let isSameCapacity = selectedCapacity == previousSelectedCapacity
            let isPassedMode = isSameCapacity && isSameDevice
            onStepStatusChange?(isPassedMode ? .passed : .pending)
        }
    }
    var selectedCollectionAndDelivery: VFGDeviceModel.CollectionAndDelivery?

    var sectionsDatasource: [VFGDeviceSectionUIModel] = []

    init(dataProvider: VFGDeviceDataProviderProtocol = VFGDeviceDataProvider()) {
        self.dataProvider = dataProvider
    }

    func fetchDevices() {
        guard let fileName = selectedDevice?.id
            else { return }
        selectedDeviceFileName = fileName
        sectionsDatasource = []
        contentState = .loading
        dataProvider.fetchDevice(fileName: fileName) { [weak self] devices, collectionAndDelivery, _ in
            guard
                let devices = devices,
                let collectionAndDelivery = collectionAndDelivery else {
                self?.contentState = .error
                return
            }

            if devices.isEmpty {
                self?.contentState = .empty
                return
            }
            self?.devices = devices
            self?.collectionAndDelivery = collectionAndDelivery
            self?.prepareSelectedColorAndCapacity()
            self?.prepareSectionsDatasource()
            self?.contentState = .populated
        }
    }

    func prepareSelectedColorAndCapacity() {
        switch stepStatus {
        case .pending:
            prepareDefaultSelectedColorAndCapacity()
        case .passed:
            updateSelectedDevice()
        default:
            prepareDefaultSelectedColorAndCapacity()
        }
    }

    func prepareDefaultSelectedColorAndCapacity() {
        selectedDevice = devices.first
        selectedColor = devices.first?.color
        selectedCapacity = devices.first?.capacity
    }

    func prepareSectionsDatasource() {
        sectionsDatasource = []
        sectionsDatasource.append(
            .init(items: .deviceImage, .colorSelection, .capcitySelection, .deviceOverview, .moreInformation)
        )

        addSpecificationsSection()
        addCollectionAndDeliverySection()
        sectionsDatasource.append(.init(items: .continueToNextStep))
    }

    func addSelectedValuesToPreviousState() {
        previousSelectedDevice = selectedDevice
        previousSelectedColor = selectedColor
        previousSelectedCapacity = selectedCapacity
    }

    private func addSpecificationsSection() {
        let title = "device_upgrade_device_step_specifications".localized(bundle: .mva10Framework)
        let isCellsCollapsed = true
        let specificationsLogo = "deviceSpecification"

        let specificationsHeader = VFGDeviceSectionHeaderUIModel(
            title: title,
            logo: specificationsLogo,
            isCellsCollapsed: isCellsCollapsed)
        sectionsDatasource.append(
            VFGDeviceSectionUIModel(header: specificationsHeader, items: [VFGDeviceUIModel.specifications])
        )
    }

    private func addCollectionAndDeliverySection() {
        if !collectionAndDelivery.isEmpty {
            let title = "device_upgrade_device_step_collection_and_delivery".localized(bundle: .mva10Framework)
            let isCellsCollapsed = true
            let collectionAndDeliveryLogo = "collectionAndDelivery"

            let collectionAndDelivery = VFGDeviceSectionUIModel(
                header: VFGDeviceSectionHeaderUIModel(
                    title: title,
                    logo: collectionAndDeliveryLogo,
                    isCellsCollapsed: isCellsCollapsed),
                items: .collectionAndDelivery)
            sectionsDatasource.append(collectionAndDelivery)
        }
    }
}

extension VFGDeviceViewModel: VFGDeviceViewModelColorsDataSource {
    var colorsFiltration: [ChooseDeviceModel.Device.Color] {
        return devices
            .compactMap { $0.color }
            .uniqued()
    }

    func numberOfColors() -> Int {
        return colorsFiltration.count
    }

    func color(at index: Int) -> ChooseDeviceModel.Device.Color {
        return colorsFiltration[index]
    }
}

extension VFGDeviceViewModel: VFGSelectionViewDataSource {
    var selectedIndex: Int {
        get {
            return capacitiesFiltration.firstIndex { [weak self] capacity -> Bool in
                guard let self = self else { return false }
                return capacity == self.selectedCapacity
            } ?? 0
        }
        set {
            if newValue < capacitiesFiltration.count {
                selectedCapacity = capacitiesFiltration[newValue]
            }
        }
    }

    func headerTitle() -> String {
        "device_upgrade_device_step_select_capacity".localized(bundle: .mva10Framework)
    }

    func numberOfSelections() -> Int {
        capacitiesFiltration.count
    }

    func titleForSelection(at index: Int) -> String {
        "\(capacitiesFiltration[index].size ?? 0)\(capacitiesFiltration[index].sizeUnit ?? "")"
    }

    func subtitleForSelection(at index: Int) -> String {
        selectedDevice?.price?.formatedUpfrontPrice ?? ""
    }

    func selectedItemSubtitleText() -> String? {
        "device_upgrade_device_step_selected".localized(bundle: .mva10Framework)
    }

    func capacity(at index: Int) -> ChooseDeviceModel.Device.Capacity? {
        if index < capacitiesFiltration.count {
            return capacitiesFiltration[index]
        }
        return nil
    }

    var capacitiesFiltration: [ChooseDeviceModel.Device.Capacity] {
        return devices
            .filter { [weak self] device -> Bool in
                guard let self = self else { return false }
                return device.color == self.selectedColor
            }
            .compactMap { $0.capacity }
            .uniqued()
            .sorted()
    }
}

extension VFGDeviceViewModel: VFGViewModelCollectionAndDeliveryDataSource {
    func numberOfCollectionAndDelivery() -> Int {
        return collectionAndDelivery.count
    }

    func collectionAndDelivery(at index: Int) -> VFGDeviceModel.CollectionAndDelivery {
        return collectionAndDelivery[index]
    }
}

extension VFGDeviceViewModel: VFGDeviceViewModelSpecificationsDataSource {
    var boxDetails: [String]? {
        return selectedDevice?.specifications?.boxDetails
    }

    func numberOfSpecifications() -> Int {
        return selectedDevice?.specifications?.quickSpecs?.count ?? 0
    }

    func specification(at index: Int) -> ChooseDeviceModel.Device.Specifications.QuickSpec? {
        return selectedDevice?.specifications?.quickSpecs?[index]
    }
}

extension VFGDeviceViewModel {
    func updateSelectedDevice() {
        guard let selectedColor = selectedColor,
            let selectedCapacity = selectedCapacity
        else { return }
        let device = devices.first {
            $0.color == selectedColor && $0.capacity == selectedCapacity
        }
        selectedDevice = device
        didUpdateDevice?()
    }

    func updateSelectedCapacity() {
        selectedCapacity = capacity(at: stepStatus == nil || stepStatus == .pending ? 0 : selectedIndex)
    }
}

extension Sequence where Element: Hashable {
    func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}
