//
//  VFGAppointmentStoreViewController+VFGLocationPicker.swift
//  VFGMVA10Framework
//
//  Created by Ahmed AbdElnabi on 02/11/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import MapKit
import VFGMVA10Foundation

extension VFGAppointmentStoreViewController: VFGLocationPickerDataSource {
    func numberOfLocations(_ view: VFGLocationPicker) -> Int {
        viewModel.numberOfStores()
    }

    func selectedLocationIndex(_ view: VFGLocationPicker) -> Int {
        0
    }

    func locationPicker(_ view: VFGLocationPicker, locationAt index: Int) -> VFGLocation {
        VFGLocation(
            name: viewModel.store(at: index)?.name ?? "",
            address: viewModel.store(at: index)?.address ?? "",
            details: viewModel.store(at: index)?.details ?? "",
            openingTime: viewModel.store(at: index)?.openingTime ?? "",
            status: "book_appointment_store_open_time_title".localized(bundle: .mva10Framework),
            ctaTitle: "book_appointment_store_cta_button_title".localized(bundle: .mva10Framework),
            coordinate: Coordinate(
                latitude: viewModel.store(at: index)?.coordinate.latitude ?? 0,
                longitude: viewModel.store(at: index)?.coordinate.longitude ?? 0
            )
        )
    }

    func locationPicker(_ view: VFGLocationPicker, locationAnnotationAt index: Int) -> VFGLocationAnnotation {
        VFGLocationAnnotation(
            id: "\(index)",
            title: viewModel.store(at: index)?.name ?? "",
            address: viewModel.store(at: index)?.address ?? "",
            info: viewModel.store(at: index)?.details ?? "",
            coordinate: CLLocationCoordinate2D(
                latitude: viewModel.store(at: index)?.coordinate.latitude ?? 0,
                longitude: viewModel.store(at: index)?.coordinate.longitude ?? 0
            )
        )
    }
}

extension VFGAppointmentStoreViewController: VFGLocationPickerDelegate {
    func locationPicker(_ view: VFGLocationPicker, locationCTADidPress location: VFGLocation, at index: Int) {
        if let store = viewModel.store(at: index) {
            onStepComplete?(store)
        }
    }
}

extension VFGAppointmentStoreViewController: VFGLocationPickerAppearance {
    func applyDefaultAnnotationStyle(_ view: VFGLocationPicker, for annotationView: MKAnnotationView) {
        annotationView.image = dotImage
    }

    func applySelectedAnnotationStyle(_ view: VFGLocationPicker, for annotationView: MKAnnotationView) {
        annotationView.image = pinImage
    }
}
