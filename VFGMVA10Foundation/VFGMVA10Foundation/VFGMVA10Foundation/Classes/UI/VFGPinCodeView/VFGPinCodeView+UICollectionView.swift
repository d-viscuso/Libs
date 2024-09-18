//
//  VFGPinCodeView+UICollectionView.swift
//  VFGMVA10Foundation
//
//  Created by Hussein Kishk on 11/8/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation

// MARK: - CollectionView methods -
extension VFGPinCodeView: UICollectionViewDataSource, UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pinLength
    }

    func settingUpTextField(_ textField: VFGPinCodeField, _ indexPath: IndexPath, _ placeholderLabel: UILabel) {
        // Setting up textField
        textField.tag = 101 + indexPath.row
        textField.isSecureTextEntry = false
        textField.textColor = self.textColor
        textField.tintColor = .VFGInputFieldCursor
        textField.font = self.font
        textField.deleteButtonAction = self.deleteButtonAction
        if #available(iOS 12.0, *), indexPath.row == 0, isContentTypeOneTimeCode {
            textField.textContentType = .oneTimeCode
        }
        textField.keyboardType = self.keyboardType
        textField.keyboardAppearance = self.keyboardAppearance
        if hasKeyboardDismissDoneButton {
            textField.dismissKeyboardButton(title: "done".localized())
        }

        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)

        placeholderLabel.text = ""
        placeholderLabel.textColor = self.textColor.withAlphaComponent(0.5)
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)

        guard let textField = cell.viewWithTag(100) as? VFGPinCodeField,
            let containerView = cell.viewWithTag(51),
            let placeholderLabel = cell.viewWithTag(400) as? UILabel
        else {
            showPinError(error: "ERR-104: Tag Mismatch")
            return UICollectionViewCell()
        }

        textField.accessibilityIdentifier = "PCtextField\(indexPath.row)"
        textField.accessibilityLabel = "Pin Code number \(indexPath.row + 1)"
        textField.accessibilityValue = ""
        settingUpTextField(textField, indexPath, placeholderLabel)
        textFields[indexPath.row] = textField
        stylePinField(containerView: containerView, isActive: false)

        // Make the Pin field the first responder
        if let firstResponderIndex = becomeFirstResponderAtIndex, firstResponderIndex == indexPath.item {
            textField.becomeFirstResponder()
            selectedTextField = textField
        }

        // Finished loading pinView
        if indexPath.row == pinLength - 1 && isLoading {
            isLoading = false
            DispatchQueue.main.async {
                if !self.placeholder.isEmpty { self.setPlaceholder() }
            }
        }

        textField.isEnabled = shouldEnableFields
        return cell
    }
}

extension VFGPinCodeView: UICollectionViewDelegateFlowLayout {
    func pinTextFieldSize(_ collectionView: UICollectionView, deviceOrientation: UIDeviceOrientation) -> CGSize {
        let width = (collectionView.bounds.width - (interSpace * CGFloat(max(pinLength, 1) - 1))) / CGFloat(pinLength)
        let height = collectionView.frame.height
        if [.landscapeLeft, .landscapeRight].contains(deviceOrientation) {
            return CGSize(width: width, height: height)
        }
        return CGSize(width: min(width, height), height: min(width, height))
    }

    func pinTextFieldInsetForSection(
        with collectionViewWidth: CGFloat,
        collectionViewHeight: CGFloat
    )
    -> UIEdgeInsets {
        let width = (collectionViewWidth -
            (interSpace * CGFloat(max(pinLength, 1) - 1))) / CGFloat(pinLength)
        let height = collectionViewHeight
        let top = (collectionViewHeight - min(width, height)) / 2
        guard height < width else {
            return UIEdgeInsets(top: top, left: 0, bottom: 0, right: 0)
        }
        // If width of field > height, size the fields to the pinView height and center them.
        let totalCellWidth = height * CGFloat(pinLength)
        let totalSpacingWidth = interSpace * CGFloat(max(pinLength, 1) - 1)
        let inset = (collectionViewWidth - CGFloat(totalCellWidth + CGFloat(totalSpacingWidth))) / 2
        return UIEdgeInsets(top: top, left: inset, bottom: 0, right: inset)
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return pinTextFieldSize(
            collectionView,
            deviceOrientation:
            UIDevice.current.orientation)
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return interSpace
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        if UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        let collectionViewWidth = collectionView.bounds.width
        let collectionViewHeight = collectionView.bounds.height
        return pinTextFieldInsetForSection(
            with: collectionViewWidth,
            collectionViewHeight: collectionViewHeight)
    }

    public override func layoutSubviews() {
        flowLayout.invalidateLayout()
    }
}
