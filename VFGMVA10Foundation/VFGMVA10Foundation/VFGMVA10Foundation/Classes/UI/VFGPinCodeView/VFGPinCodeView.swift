//
//  VFGPinCodeView.swift
//  VFGMVA10Foundation
//
//  Created by Hussein Kishk on 11/3/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import UIKit
/// Determine deletion conditions and cursor position in text field
@objc public enum VFGPinCodeViewDeleteButtonAction: Int {
    /// Deletes the contents of the current field and moves the cursor to the previous field.
    case deleteCurrentAndMoveToPrevious = 0

    /// Simply deletes the content of the current field without moving the cursor.
    /// If there is no value in the field, the cursor moves to the previous field.
    case deleteCurrent

    /// Moves the cursor to the previous field and deletes the contents.
    /// When any field is focused, its contents are deleted.
    case moveToPreviousAndDelete
}

private class VFGPinCodeViewFlowLayout: UICollectionViewFlowLayout {
    override var developmentLayoutDirection: UIUserInterfaceLayoutDirection { return .leftToRight }
    override var flipsHorizontallyInOppositeLayoutDirection: Bool { return true }
}
/// Grouped text fields to enter pin code
@objcMembers
public class VFGPinCodeView: UIView {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var errorView: UIView!
    // MARK: - Private Properties -

    var flowLayout: UICollectionViewFlowLayout {
        self.collectionView.collectionViewLayout = VFGPinCodeViewFlowLayout()
        return self.collectionView?.collectionViewLayout as? UICollectionViewFlowLayout ?? UICollectionViewFlowLayout()
    }

    var view: UIView?
    var reuseIdentifier = "VFGPinCodeCell"
    var isLoading = true
    var password: [String] = []
    var shouldEnableFields = true
    var textFields: [Int: UITextField] = [:]
    var selectedTextField: UITextField?

    // MARK: - Public Properties -
    /// Inspectable value for maximum number of digits for pin code
    @IBInspectable public var pinLength: Int = 4
    /// Inspectable value for unicode character to be in text field's text declaring that user typed secured digit in this text field
    @IBInspectable public var secureCharacter: String = "\u{25CF}"
    /// Inspectable value for space between text fields
    @IBInspectable public var interSpace: CGFloat = 8
    /// Inspectable value for text field and its place holder text color
    @IBInspectable public var textColor: UIColor = .VFGDefaultInputText
    /// Inspectable value to determine if typed digits in text fields should be replaced with *secureCharacter* for security or not
    @IBInspectable public var shouldSecureText: Bool = true
    /// Inspectable value for time delay between user typing digit and replacing it with *secureCharacter*
    @IBInspectable public var secureTextDelay: Int = 0
    /// Inspectable value to determine if deleted digit will be replaced with white space or not
    @IBInspectable public var allowsWhitespaces: Bool = false
    /// Inspectable value for text field place holder text
    @IBInspectable public var placeholder: String = ""
    /// Inspectable value for unselected text field border color
    @IBInspectable public var borderLineColor: UIColor = .VFGDefaultInputOutline
    /// Inspectable value for selected text field border color
    @IBInspectable public var activeBorderLineColor: UIColor = .VFGSelectedInputOutline
    /// Inspectable value for unselected text field border width
    @IBInspectable public var borderLineThickness: CGFloat = 1
    /// Inspectable value for selected text field border width
    @IBInspectable public var activeBorderLineThickness: CGFloat = 2
    /// Inspectable value for unselected text field background color
    @IBInspectable public var fieldBackgroundColor: UIColor = UIColor.clear
    /// Inspectable value for selected text field background color
    @IBInspectable public var activeFieldBackgroundColor: UIColor = UIColor.clear
    /// Inspectable value for unselected text field corner radius
    @IBInspectable public var fieldCornerRadius: CGFloat = 6
    /// Inspectable value for selected text field corner radius
    @IBInspectable public var activeFieldCornerRadius: CGFloat = 6
    /// Current deletion condition and cursor position for text fields
    public var deleteButtonAction: VFGPinCodeViewDeleteButtonAction = .moveToPreviousAndDelete
    /// Text field text font
    public var font = UIFont.vodafoneLite(22)
    /// Text field keyboard type for typed text
    public var keyboardType = UIKeyboardType.phonePad
    /// Current appearance of the keyboard for text field
    public var keyboardAppearance: UIKeyboardAppearance = .default
    /// Current text field's index in *collectionView* where curser is
    public var becomeFirstResponderAtIndex: Int?
    /// Determine if the content in a text field is a one-time code or not
    public var isContentTypeOneTimeCode = true
    /// Determine if keyboard should be dismissed for empty text field or not
    public var shouldDismissKeyboardOnEmptyFirstField = false
    /// Determine if typed digits match credentials or not
    public var hasError = false {
        didSet {
            updateBorders()
        }
    }
    public var hasKeyboardDismissDoneButton = true
    /// Call back action after entire pin code is entered
    public var didFinishCallback: ((String) -> Void)?
    /// Call back action after every typing, deletion or edition in any of the pin code digits
    public var didChangeCallback: ((String) -> Void)?

    // MARK: - Init methods -
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadView()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        loadView()
    }

    func loadView(completionHandler: (() -> Void)? = nil) {
        let nib = UINib(nibName: "VFGPinCodeView", bundle: Bundle.foundation)
        view = nib.instantiate(withOwner: self, options: nil)[0] as? UIView
        guard let view = view else { return }
        // for CollectionView
        let collectionViewNib = UINib(nibName: "VFGPinCodeCell", bundle: Bundle.foundation)
        collectionView.register(collectionViewNib, forCellWithReuseIdentifier: reuseIdentifier)
        flowLayout.scrollDirection = .vertical
        collectionView.isScrollEnabled = false

        self.addSubview(view)
        view.frame = bounds
        view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            completionHandler?()
        }
    }

    // MARK: - Private methods -
    func handleErrorState() {
        if hasError {
            hasError = false
            for index in 1...pinLength - 1 {
                if let cell = collectionView.cellForItem(at: IndexPath(item: index, section: 0)),
                    let containerView = cell.viewWithTag(51) {
                    containerView.layer.borderWidth = borderLineThickness
                    containerView.layer.borderColor = borderLineColor.cgColor
                }
            }
        }
    }

    func validateAndSendCallback() {
        didChangeCallback?(password.joined())

        let pin = getPin()
        guard !pin.isEmpty else { return }
        didFinishCallback?(pin)
    }

    func setPlaceholder() {
        for (index, char) in placeholder.enumerated() {
            guard index < pinLength else { return }

            if let placeholderLabel = collectionView.cellForItem(
                at: IndexPath(
                    item: index,
                    section: 0))?
                .viewWithTag(400) as? UILabel {
                placeholderLabel.text = String(char)
            } else { showPinError(error: "ERR-102: Type Mismatch") }
        }
    }

    func stylePinField(containerView: UIView, isActive: Bool) {
        containerView.backgroundColor = isActive ? activeFieldBackgroundColor : fieldBackgroundColor
        containerView.layer.cornerRadius = isActive ? activeFieldCornerRadius : fieldCornerRadius
        containerView.layer.borderWidth = isActive ? activeBorderLineThickness : borderLineThickness
        containerView.layer.borderColor = isActive ? activeBorderLineColor.cgColor : borderLineColor.cgColor
    }

    @IBAction func refreshPinView(completionHandler: (() -> Void)? = nil) {
        view?.removeFromSuperview()
        view = nil
        isLoading = true
        errorView.isHidden = true
        loadView(completionHandler: completionHandler)
    }

    func showPinError(error: String) {
        errorView.isHidden = false
        print("\n----------VFGPinCodeField Error----------")
        print(error)
        print("-----------------------------------")
    }
    /// Determine if typed digits match credentials or not
    /// - Parameters:
    ///    - hasError: Determine if there an error or not
    public func setErrorState(hasError: Bool) {
        self.hasError = hasError
    }
    /// Allow typing in text fields and modify their UI configurations
    public func enableFields() {
        shouldEnableFields = true
        textFields.forEach {
            $0.value.isEnabled = true
            stylePinField(containerView: $0.value.superview ?? UIView(), isActive: false)
        }
        selectedTextField?.becomeFirstResponder()
        stylePinField(containerView: selectedTextField?.superview ?? UIView(), isActive: true)
    }
    /// Deny typing in text fields and modify their UI configurations
    public func disableFields() {
        shouldEnableFields = false
        textFields.forEach {
            $0.value.isEnabled = false
            stylePinField(containerView: $0.value.superview ?? UIView(), isActive: false)
        }
    }

    func updateBorders() {
        if hasError {
            borderLineColor = .VFGErrorInputOutline
            activeBorderLineColor = .VFGErrorInputOutline
            activeBorderLineThickness = 1
        } else {
            borderLineColor = .VFGDefaultInputOutline
            activeBorderLineColor = .VFGSelectedInputOutline
            activeBorderLineThickness = 2
        }
    }
}
