//
//  ProductSwitcherEditViewController.swift
//  VFGMVA10Framework
//
//  Created by Loodos on 11/16/22.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

public class ProductSwitcherEditViewController: UIViewController {
    @IBOutlet private weak var backgroundView: UIView!
    // Edit actions view
    @IBOutlet private weak var editActionsHolderView: UIView!
    @IBOutlet weak var titleLabel: VFGLabel!
    @IBOutlet weak var subtitleLabel: VFGLabel!
    @IBOutlet weak var inputField: UITextField!
    @IBOutlet weak var confirmButton: VFGButton!
    @IBOutlet weak var cancelButton: VFGButton!
    @IBOutlet weak var editActionsHolderViewBottomConstraint: NSLayoutConstraint!
    // Loading view
    @IBOutlet weak var loadingLogoHolderView: UIView!
    // Result view
    @IBOutlet private weak var resultHolderView: UIView!
    @IBOutlet weak var resultImageView: VFGImageView!
    @IBOutlet weak var resultTitleLabel: VFGLabel!
    @IBOutlet weak var resultSubtitleLabel: VFGLabel!
    @IBOutlet weak var resultConfirmButton: VFGButton!

    var actionModel: ProductSwitcherEditActionModel?

    private lazy var tapBackgroundGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(backgroundViewClicked(_:)))
        return gesture
    }()
    private var loadingLogoView: VFGLoadingLogoView?

    public convenience init(actionModel: ProductSwitcherEditActionModel) {
        self.init(nibName: "ProductSwitcherEditViewController", bundle: .mva10Framework)
        self.actionModel = actionModel
        modalPresentationStyle = .overCurrentContext
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        observeKeyboardNotifications()
        setupBackgroundView()
        setupEditActionsView()
        setupLoadingView()
        setupResultView()
        updateViewState(.initial)
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupViewTexts()
    }

    public func showResult(isSuccess: Bool) {
        if isSuccess {
            setupResultViewForSuccess()
            updateViewState(.success)
        } else {
            setupResultViewForError()
            updateViewState(.error)
        }
    }

    private func setupBackgroundView() {
        backgroundView.addGestureRecognizer(tapBackgroundGesture)
        backgroundView.alpha = 0.9
    }

    private func setupEditActionsView() {
        editActionsHolderView.roundUpperCorners(cornerRadius: 6)
        inputField.delegate = self
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 44))
        inputField.leftView = paddingView
        inputField.leftViewMode = .always
        updateInputField(isSelected: false)

        confirmButton.buttonStyle = VFGButton.ButtonStyle.primary.rawValue
        cancelButton.buttonStyle = VFGButton.ButtonStyle.alt1.rawValue
    }

    private func setupLoadingView() {
        loadingLogoHolderView.roundUpperCorners(cornerRadius: 6)
        loadingLogoView = VFGLoadingLogoView.loadXib(bundle: .foundation)
        loadingLogoView?.configure(
            style: .red,
            view: loadingLogoHolderView,
            backgroundColor: UIColor.clear,
            title: actionModel?.loadingTitle,
            titleFont: UIFont.vodafoneLite(20),
            titleTextColor: UIColor.VFGPrimaryDarkText
        )
    }

    private func setupResultView() {
        resultHolderView.roundUpperCorners(cornerRadius: 6)
        resultConfirmButton.buttonStyle = VFGButton.ButtonStyle.primary.rawValue
    }

    private func updateInputField(isSelected: Bool) {
        if isSelected {
            inputField.layer.borderWidth = 2
            inputField.layer.borderColor = UIColor.VFGTextViewBorderActiveColorTwo.cgColor
        } else {
            inputField.layer.borderWidth = 1
            inputField.layer.borderColor = UIColor.darkGrayBackground?.cgColor
        }
    }

    private func updateViewState(_ viewState: ProductSwitcherEditViewState) {
        editActionsHolderView.isHidden = !(viewState == .initial)
        loadingLogoHolderView.isHidden = !(viewState == .loading)
        resultHolderView.isHidden = !(viewState == .success || viewState == .error)

        if viewState == .loading {
            loadingLogoView?.startLoading()
        } else {
            loadingLogoView?.endLoading()
        }
    }

    private func setupViewTexts() {
        // Edit view setup
        titleLabel.text = actionModel?.title
        subtitleLabel.text = actionModel?.subtitle
        inputField.text = actionModel?.productName
        confirmButton.setTitle(actionModel?.confirmButtonText, for: .normal)
        cancelButton.setTitle(actionModel?.cancelButtonText, for: .normal)

        // Result view setup
        setupResultViewForSuccess()
    }

    private func setupResultViewForSuccess() {
        resultImageView.image = VFGFrameworkAsset.Image.icProductSwitcherTick
        resultTitleLabel.text = actionModel?.resultTitle
        resultConfirmButton.setTitle(actionModel?.resultConfirmButtonText, for: .normal)

        guard let resultSubtitle = actionModel?.resultSubtitle else { return }
        if let newName = inputField.text {
            resultSubtitleLabel.text = String(format: resultSubtitle, newName)
        }
    }

    private func setupResultViewForError() {
        resultImageView.image = VFGFrameworkAsset.Image.icProductSwitcherError
        resultTitleLabel.text = actionModel?.errorTitle
        resultSubtitleLabel.text = actionModel?.errorSubtitle
        resultConfirmButton.setTitle(actionModel?.errorConfirmButtonText, for: .normal)
    }

    // MARK: User Actions

    @IBAction func confirmButtonClicked(_ sender: Any) {
        inputField.resignFirstResponder()
        updateViewState(.loading)
        actionModel?.confirmButtonAction(inputField.text)
    }

    @IBAction func cancelButtonClicked(_ sender: Any) {
        actionModel?.closeAction()
    }

    @IBAction func resultConfirmButtonClicked(_ sender: Any) {
        actionModel?.closeAction()
    }

    @objc func backgroundViewClicked(_ sender: UITapGestureRecognizer) {
        actionModel?.closeAction()
    }
}

// MARK: - UITextFieldDelegate
extension ProductSwitcherEditViewController: UITextFieldDelegate {
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        updateInputField(isSelected: true)
        confirmButton.isEnabled = false
        textField.text = ""
        return true
    }

    public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        updateInputField(isSelected: false)
        return true
    }
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    public func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let isEmpty = textField.text?.isEmpty, isEmpty else {
            confirmButton.isEnabled = true
            return
        }
        confirmButton.isEnabled = false
    }
}

// MARK: - Keyboard Notification
extension ProductSwitcherEditViewController {
    private func observeKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillAppear),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillDisappear),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    @objc func keyboardWillAppear(notification: NSNotification) {
        guard let keyboardInfo = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
            editActionsHolderViewBottomConstraint.constant == 0
        else { return }
        editActionsHolderViewBottomConstraint.constant = keyboardInfo.cgRectValue.height
        view.layoutIfNeeded()
    }

    @objc func keyboardWillDisappear(notification: NSNotification) {
        guard editActionsHolderViewBottomConstraint.constant != 0 else { return }
        editActionsHolderViewBottomConstraint.constant = 0
        view.layoutIfNeeded()
    }
}
