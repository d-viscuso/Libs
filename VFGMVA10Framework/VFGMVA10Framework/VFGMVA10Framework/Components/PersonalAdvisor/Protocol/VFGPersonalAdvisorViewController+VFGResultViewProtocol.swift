//
//  VFGPersonalAdvisorViewController+VFGResultViewProtocol.swift
//  VFGMVA10PersonalAdvisor
//
//  Created by Vasiliki Trachani, Vodafone on 12/08/2022.
//

import VFGMVA10Foundation

// MARK: - VFGResultViewProtocol
extension VFGPersonalAdvisorViewController: VFGResultViewProtocol {
    public func resultViewPrimaryButtonAction() {
        quickActionsResultView?.closeQuickAction()
        switch status {
        case .sendRequest(type: let sendRequestStatus):
            if sendRequestStatus {
                delegate?.didFinish(isDismissed: false)
                self.dismiss(animated: true) {
                    self.delegate?.didFinish(isDismissed: true)
                }
            } else {
                /// try again to send request
                sendRequestAction()
            }
        case .previousStatus(type: let previousRequestStatus):
            if previousRequestStatus == .failed {
                checkPreviousRequestStatus()
            } else {
                /// try again to see previous request status
                delegate?.didFinishAfterPreviousStatusRequest(isDismissed: false)
                self.dismiss(animated: true) {
                    self.delegate?.didFinishAfterPreviousStatusRequest(isDismissed: true)
                }
            }
        case .none:
            break
        }
    }
    public func resultViewSecondaryButtonAction() {
        quickActionsResultView?.closeQuickAction()
    }
}
