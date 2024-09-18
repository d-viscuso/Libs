//
//  VFGAppointmentStoreViewController+MapDelegate.swift
//  VFGMVA10Framework
//
//  Created by Moustafa Hegazy on 09/02/2021.
//

import MapKit

// MARK: CLLocationManagerDelegate
extension VFGLocationPicker: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.first else {
            return
        }
        currentCoordination = currentLocation.coordinate
    }

    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if CLLocationManager.authorizationStatus()
            == .authorizedAlways ||
            CLLocationManager.authorizationStatus()
            == .authorizedWhenInUse {
            startUpdating()
        }
    }

    func startUpdating() {
        mapView?.showsUserLocation = true
        mapView?.mapType = .standard
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }

    func zoomToLocation(with coordinates: CLLocationCoordinate2D) {
        let zoomRange = MKCoordinateRegion.init(
            center: coordinates,
            latitudinalMeters: 1000,
            longitudinalMeters: 1000)
        mapView?.setRegion(zoomRange, animated: true)
    }
}

extension VFGLocationPicker: MKMapViewDelegate {
    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !annotation.isKind(of: MKUserLocation.self) else {
            return nil
        }

        if let annotation = annotation as? VFGLocationAnnotation {
            let identifier = annotation.identifier
            let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            appearance?.applyDefaultAnnotationStyle(self, for: annotationView)
            return annotationView
        }

        return MKAnnotationView()
    }

    // MARK: Annotation selection
    public func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let viewAnnotation = view.annotation,
            !(viewAnnotation.isKind(of: MKUserLocation.self)),
            let dataSource = dataSource
        else { return }

        let storeIndex = (0..<dataSource.numberOfLocations(self)).first { index in
            dataSource.locationPicker(self, locationAnnotationAt: index).identifier == view.reuseIdentifier
        }

        guard let storeIndexRow = storeIndex else {
            return
        }

        zoomToLocation(with: viewAnnotation.coordinate)

        locationsCollectionView?.scrollToItem(
            at: IndexPath(row: storeIndexRow, section: 0),
            at: .centeredHorizontally,
            animated: true
        )

        appearance?.applySelectedAnnotationStyle(self, for: view)

        delegate?.locationPicker(
            self,
            locationAnnotationDidSelect: dataSource.locationPicker(self, locationAnnotationAt: storeIndexRow),
            at: storeIndexRow
        )
    }

    // MARK: annotation deselection
    public func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        appearance?.applyDefaultAnnotationStyle(self, for: view)
    }
}
