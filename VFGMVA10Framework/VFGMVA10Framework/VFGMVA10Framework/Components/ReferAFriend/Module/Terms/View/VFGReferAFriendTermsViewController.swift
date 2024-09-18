//
//  VFGReferAFriendTermsViewController.swift
//  VFGReferAFriend
//
//  Created by Mustafa Güneş on 27.01.2021.
//

import UIKit
import VFGMVA10Foundation

/// Refer a friend terms view controller.
public class VFGReferAFriendTermsViewController: UIViewController {
    // MARK: - DI
    @LazyInjected public var viewModel: VFGReferAFriendTermsViewModelProtocol?

    // MARK: - Outlets
    @IBOutlet weak var termsLabel: VFGLabel!
    @IBOutlet weak var closeButton: VFGButton!

    public init() {
        super.init(nibName: VFGReferAFriendConstants.NibName.referAFriendTerms, bundle: .mva10Framework)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override open func viewDidLoad() {
        super.viewDidLoad()
        setConfigurations()
        VFGReferAFriendTermsViewModel.trackView(pageName: VFGReferAFriendTermsViewModel.journeyType)
    }

    public func setConfigurations() {
        let text = viewModel?.termsText
        setTermsText(with: text)

        let closeImage = VFGFrameworkAsset.Image.icClose?.withRenderingMode(.alwaysTemplate)
        closeButton.setImage(closeImage, for: .normal)
        closeButton.tintColor = .VFGGreyTint
    }

    public func setTermsText(with text: String?) {
        guard let text = text else { return }
        termsLabel.text = text
    }
}

extension VFGReferAFriendTermsViewController {
    @IBAction public func closeButtonPressed(_ sender: VFGButton) {
        if isModal {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
}
