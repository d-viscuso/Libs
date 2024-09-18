//
//  VFGLocationPickerDataSource.swift
//  VFGMVA10Foundation
//
//  Created by Ahmed AbdElnabi on 31/10/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

/// A data source protocol that manages the data in your location picker
/// It represents your data model and vends information to the location picker as needed
/// It also creates and configures the location and annotation views that the picker view uses to display your data
public protocol VFGLocationPickerDataSource: AnyObject {
    /// Number of locations viewed in location picker.
    /// - Parameter view: Current location picker view associated with the data source.
    func numberOfLocations(_ view: VFGLocationPicker) -> Int
    /// Default selected location index.
    /// - Parameter view: Current location picker view associated with the data source.
    func selectedLocationIndex(_ view: VFGLocationPicker) -> Int
    /// Access specific location at given index.
    /// - Parameters:
    ///   - view: Current location picker view associated with the data source.
    ///   - index: Index used to specify location.
    func locationPicker(_ view: VFGLocationPicker, locationAt index: Int) -> VFGLocation
    /// Access specific location annotation at specific index.
    /// - Parameters:
    ///   - view: Current location picker view associated with the data source.
    ///   - index: Index used to specify location annotation.
    func locationPicker(_ view: VFGLocationPicker, locationAnnotationAt index: Int) -> VFGLocationAnnotation
}
