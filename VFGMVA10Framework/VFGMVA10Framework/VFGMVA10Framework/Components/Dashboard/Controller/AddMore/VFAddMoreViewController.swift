//
//  VFAddMoreViewController.swift
//  mva10
//
//  Created by Mahmoud Amer on 12/26/18.
//  Copyright © 2018 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation
/// View controller allow to add more images
class VFAddMoreViewController: UIViewController {
    @IBOutlet weak var plusImageView: VFGImageView!
    /// *VFAddMoreViewController* initializer
    /// - Parameters:
    ///    - config: Data to view
    ///    - error: Data request error
    public required init(config: [String: Any]?, error: [String: Any]?) {
        super.init(nibName: nil, bundle: Bundle(for: type(of: self)))
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        plusImageView.image = VFGFrameworkAsset.Image.plus
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.addDashedBorder(color: .black, lineWidth: 3, lineDashPattern: [8, 4], cornerRadius: 6)
    }
}

extension VFAddMoreViewController: VFGComponentEntry {
    var cardView: UIView? {
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .VFGWhiteBackground
        return view
    }

    var cardEntryViewController: UIViewController? {
        return UIViewController()
    }
    /// Return *VFAddMoreViewController*
    public static func viewController() -> VFAddMoreViewController {
        let viewController = VFAddMoreViewController.instantiate(fromAppStoryboard: .addMore)
        return viewController
    }
}
