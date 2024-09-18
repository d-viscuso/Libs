//
//  VFGLocationPickerDelegate.swift
//  VFGMVA10Foundation
//
//  Created by Ahmed AbdElnabi on 31/10/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

/// A delegate protocol that manages user interactions with the location picker's contents,
/// including location cell and location annotation selection, location CTA Press
public protocol VFGLocationPickerDelegate: AnyObject {
    /// Notify the delegate once the location cell is clicked.
    /// - Parameters:
    ///   - view: Current location picker view associated with the delegate.
    ///   - location: Current selected location object.
    ///   - index: Current selected location cell index.
    func locationPicker(_ view: VFGLocationPicker, locationCellDidSelect location: VFGLocation, at index: Int)
    /// Notify the delegate once the location annotation is selected.
    /// - Parameters:
    ///   - view: Current location picker view associated with the delegate.
    ///   - annotation: Current selected location picker object.
    ///   - index: Current selected location annotation index.
    func locationPicker(_ view: VFGLocationPicker, locationAnnotationDidSelect annotation: VFGLocationAnnotation, at index: Int)
    /// Notify the delegate once the location CTA is selected.
    /// - Parameters:
    ///   - view: Current location picker view associated with the delegate.
    ///   - location: Current selected location object.
    ///   - index: Current selected location cell index.
    func locationPicker(_ view: VFGLocationPicker, locationCTADidPress location: VFGLocation, at index: Int)
}

public extension VFGLocationPickerDelegate {
    func locationPicker(_ view: VFGLocationPicker, locationCellDidSelect location: VFGLocation, at index: Int) {}
    func locationPicker(_ view: VFGLocationPicker, locationAnnotationDidSelect annotation: VFGLocationAnnotation, at index: Int) {}
    func locationPicker(_ view: VFGLocationPicker, locationCTADidPress location: VFGLocation, at index: Int) {}
}
