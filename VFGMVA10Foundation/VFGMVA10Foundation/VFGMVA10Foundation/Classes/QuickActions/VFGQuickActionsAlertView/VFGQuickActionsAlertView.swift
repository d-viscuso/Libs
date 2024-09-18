//
//  VFGQuickActionsAlertView.swift
//  VFGMVA10Foundation
//
//  Created by Abdullah Soylemez on 4.06.2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation

// MARK: - VFGQuickActionsAlertView
public class VFGQuickActionsAlertView: VFQuickActionsModel {
    // MARK: - Public variables
    public var quickActionsTitle: String
    public var quickActionsContentView: UIView {
        guard let twoActionsView: VFGTwoActionsView = UIView.loadXib(bundle: .foundation) else {
            return UIView()
        }
        twoActionsView.delegate = twoActionsViewDelegate ?? self
        twoActionsView.configure(
            viewStyle: .white,
            titlesModel: titlesModel
        )
        return twoActionsView
    }
    public var quickActionsStyle: VFQuickActionsStyle = .white
    public var isCloseButtonHidden: Bool {
        !showCloseButton
    }

    // MARK: - Private variables
    private weak var delegate: VFQuickActionsProtocol?
    private let titlesModel: VFGTitlesModel
    private var showCloseButton = true
    private let primaryButtonCompletion: (() -> Void)?
    private let secondaryButtonCompletion: (() -> Void)?
    private let closeButtonCompletion: (() -> Void)?
    private weak var twoActionsViewDelegate: VFGTwoActionsViewProtocol?

    // MARK: - Init
    public init(
        quickActionsTitle: String = "",
        detailsText: String? = nil,
        primaryButtonTitle: String,
        secondaryButtonTitle: String? = nil,
        showCloseButton: Bool = true,
        primaryButtonCompletion: (() -> Void)? = nil,
        secondaryButtonCompletion: (() -> Void)? = nil,
        closeButtonCompletion: (() -> Void)? = nil,
        twoActionsViewDelegate: VFGTwoActionsViewProtocol? = nil
    ) {
        self.quickActionsTitle = quickActionsTitle
        self.showCloseButton = showCloseButton
        self.primaryButtonCompletion = primaryButtonCompletion
        self.secondaryButtonCompletion = secondaryButtonCompletion
        self.closeButtonCompletion = closeButtonCompletion
        self.twoActionsViewDelegate = twoActionsViewDelegate
        titlesModel = VFGTitlesModel(
            moreDetails: detailsText,
            primaryButtonTitle: primaryButtonTitle,
            secondaryButtonTitle: secondaryButtonTitle
        )
    }

    // MARK: - Public functions
    public func quickActionsProtocol(delegate: VFQuickActionsProtocol) {
        self.delegate = delegate
    }

    public func closeQuickAction() {
        delegate?.closeQuickAction(completion: closeButtonCompletion)
    }

    public func present() {
        VFQuickActionsViewController.presentQuickActionsViewController(with: self)
    }
}

// MARK: - VFGTwoActionsViewProtocol
extension VFGQuickActionsAlertView: VFGTwoActionsViewProtocol {
    public func primaryButtonAction() {
        delegate?.closeQuickAction(completion: primaryButtonCompletion)
    }

    public func secondaryButtonAction() {
        delegate?.closeQuickAction(completion: secondaryButtonCompletion)
    }
}
