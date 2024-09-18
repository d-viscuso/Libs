//
//  VFGMVA10Tutorial.swift
//  VFGMVA10Framework
//
//  Created by Hussien Gamal Mohammed on 4/14/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation
import VFGMVA10Foundation
/// Responsible for showing tutorial screen
public class VFGMVA10Tutorial {
    /// An instance of *VFGTutorialManagerProtocol*
    internal weak var delegate: VFGTutorialManagerProtocol?
    /// *VFGMVA10Tutorial* initializer
    /// - Parameters:
    ///    - delegate: An instance of *VFGTutorialManagerProtocol*
    public init(delegate: VFGTutorialManagerProtocol?) {
        self.delegate = delegate
    }
    /// Return *VFGMVA10Tutorial* navigavtion controller
    public func viewController() -> UINavigationController {
        let dataSource = loadData()
        let tutorialVC = VFGTutorialViewController.viewController(with: dataSource)
        let tutorialNavigationController = UINavigationController(rootViewController: tutorialVC)
        tutorialVC.delegate = delegate
        tutorialVC.dataSource = dataSource
        tutorialNavigationController.setNavigationBarHidden(true, animated: false)
        tutorialNavigationController.modalTransitionStyle = .crossDissolve
        tutorialNavigationController.modalPresentationStyle = .fullScreen
        return tutorialNavigationController
    }
}

extension VFGMVA10Tutorial {
    /// Return tutorial model with its congifuration
    func loadData() -> VFGTutorialModel? {
        let tutorialOne = VFGTutorialItem(
            title: "tutorial_step1_title".localized(bundle: Bundle.mva10Framework),
            description: "tutorial_step1_description"
                .localized(bundle: Bundle.mva10Framework),
            fileName: "Tutorial_features",
            startingFrame: 0,
            endingFrame: 450)
        let tutorialTwo = VFGTutorialItem(
            title: "tutorial_step2_title".localized(bundle: Bundle.mva10Framework),
            description: "tutorial_step2_description"
                .localized(bundle: Bundle.mva10Framework),
            fileName: "Tutorial_features",
            startingFrame: 451,
            endingFrame: 870)
        let tutorialThree = VFGTutorialItem(
            title: "tutorial_step3_title".localized(bundle: Bundle.mva10Framework),
            description: "tutorial_step3_description"
                .localized(bundle: Bundle.mva10Framework),
            fileName: "Tutorial_features",
            startingFrame: 871,
            endingFrame: 1021)
        let items = [tutorialOne, tutorialTwo, tutorialThree]
        return VFGTutorialModel(
            item: items,
            firstButtonTitle: "tutorial_primary_button_text"
                .localized(bundle: Bundle.mva10Framework),
            secondButtonTitle: "tutorial_secondary_button_text"
                .localized(bundle: Bundle.mva10Framework),
            animationFileBundle: Bundle.mva10Framework)
    }
}
