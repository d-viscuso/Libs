//
//  VFGLocationPicker.swift
//  VFGMVA10Framework
//
//  Created by Yahya Saddiq on 2/8/21.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import MapKit
/// A controller that allows a user to choose a location either by a tap on a location annotation on the map
/// or from the horizontally scrollable location cards.
public class VFGLocationPicker: UIView {
    // MARK: IBOutlets
    @IBOutlet var contentView: UIView?
    @IBOutlet weak var mapView: MKMapView?
    @IBOutlet weak var locationsCollectionView: UICollectionView?
    @IBOutlet weak var currentLocationButton: VFGButton?

    // MARK: Non-public Properties
    var isUserScrolling = false
    let locationManager = CLLocationManager()
    var currentCoordination: CLLocationCoordinate2D?
    var annotations: [VFGLocationAnnotation] = []

    // MARK: - Public properties
    public weak var delegate: VFGLocationPickerDelegate?
    public weak var dataSource: VFGLocationPickerDataSource?
    public weak var appearance: VFGLocationPickerAppearance? {
        didSet {
            if let currentLocationButton = currentLocationButton {
                appearance?.applyCurrentLocationButtonStyle(self, for: currentLocationButton)
            }
        }
    }
    public var contentState: ContentState = .empty {
        didSet {
            reloadData()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
        uiSetup()
        addAccessibilityForVoiceOver()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
        uiSetup()
        addAccessibilityForVoiceOver()
    }

    private func xibSetup() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "VFGLocationPicker", bundle: bundle)
        nib.instantiate(withOwner: self, options: nil)
        addSubview(contentView ?? UIView())
        contentView?.frame = bounds
        contentView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }

    private func uiSetup() {
        appearance = appearance == nil ? self : appearance
        locationsCollectionView?.delegate = self
        locationsCollectionView?.dataSource = self
        locationsCollectionView?.backgroundColor = .clear
        let locationNib = UINib(
            nibName: String(describing: VFGLocationCell.self),
            bundle: .foundation
        )
        let shimmerNib = UINib(
            nibName: String(describing: VFGLocationShimmerCell.self),
            bundle: .foundation
        )
        locationsCollectionView?.register(
            locationNib,
            forCellWithReuseIdentifier: String(describing: VFGLocationCell.self))
        locationsCollectionView?.register(
            shimmerNib,
            forCellWithReuseIdentifier: String(describing: VFGLocationShimmerCell.self))
        configureLocation()
    }

    public func reloadData() {
        switch contentState {
        case .loading:
            self.hideMap()
            self.locationsCollectionView?.reloadData()
            self.locationsCollectionView?.isScrollEnabled = false
        case .populated:
            self.configureLocation()
            self.showMap()
            self.addAnnotations()
            self.locationsCollectionView?.reloadData()
            self.locationsCollectionView?.isScrollEnabled = true
        case .empty:
            VFGDebugLog("empty")
        case .error:
            VFGDebugLog("error")
        }
    }

    func hideMap() {
        mapView?.isHidden = true
        currentLocationButton?.isHidden = true
    }

    func showMap() {
        mapView?.tintColor = UIColor.VFGTurquoiseTint
        mapView?.isHidden = false
        currentLocationButton?.isHidden = false
    }

    func configureLocation() {
        locationManager.delegate = self
        mapView?.delegate = self

        if CLLocationManager.authorizationStatus()
            == CLAuthorizationStatus.notDetermined {
            locationManager.requestWhenInUseAuthorization()
        } else if  CLLocationManager.authorizationStatus() != CLAuthorizationStatus.denied {
            startUpdating()
        }
    }

    func addAnnotations() {
        guard let dataSource = dataSource else { return }

        (0..<dataSource.numberOfLocations(self)).forEach { index in
            let annotation = dataSource.locationPicker(self, locationAnnotationAt: index)
            annotations.append(annotation)
            mapView?.addAnnotation(annotations[index])
        }

        selectAnnotation(at: dataSource.selectedLocationIndex(self))
    }

    func selectAnnotation(at index: Int) {
        if index < annotations.count {
            mapView?.selectAnnotation(annotations[index], animated: true)
            zoomToLocation(with: annotations[index].coordinate)
        }
    }

    @IBAction func currentLocationDidPress(_ sender: VFGButton) {
        currentLocationAction()
    }

    @objc func currentLocationAction() {
        guard let currentCoordinate = mapView?.userLocation.coordinate else {
            return
        }

        zoomToLocation(with: currentCoordinate)
    }
}
public extension VFGLocationPicker {
    func addAccessibilityForVoiceOver() {
        currentLocationButton?.accessibilityLabel = "Locate me"
        accessibilityCustomActions = [locateMeVoiceOverAction()]
    }
    /// action for book appointment voice over
    /// - Returns: action for book appointment  button in voice over
    func locateMeVoiceOverAction() -> UIAccessibilityCustomAction {
        let actionName = "Locate me"
        return UIAccessibilityCustomAction(name: actionName, target: self, selector: #selector(currentLocationAction))
    }
}
