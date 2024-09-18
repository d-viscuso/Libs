//
//  VFGDashboardDataProvider.swift
//  VFGMVA10
//
//  Created by Tomasz Czyżak on 11/07/2019.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import Foundation
import VFGMVA10Foundation

/// Dashboard data provider protocol.
public protocol VFGDashboardDataProviderProtocol {
    /// Method responsible for fetching dashboard sections data.
    /// - Parameters:
    ///     - url: The url that should be fetched to get dashboard sections data.
    ///     - completion: Completion of type *([BaseSectionViewModel]?, Error?) -> Void)* that contains *Error* in case of failure & array of *BaseSectionViewModel* in case of success in fetching, each element of the array represent a section in the dashoard.
    func requestData(with url: String, completion: @escaping ([BaseSectionViewModel]?, Error?) -> Void)
}
/// Dashboard data provider
public class VFGDashboardDataProvider: VFGDashboardDataProviderProtocol {
    /// Array list of dashboard sections
    public var dashboardSections: [VFGDashboardSection] = []
    private var networkDashboardSections: VFGNetworkClient?

    public init() {}

    public func requestData(with url: String, completion: @escaping ([BaseSectionViewModel]?, Error?) -> Void) {
        networkDashboardSections = VFGNetworkClient(baseURL: url)
        networkDashboardSections?.executeData(
            request: VFGRequest(),
            model: VFGDashboardSections.self,
            progressClosure: nil) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let model):
                guard let sections = model.sections, !(sections.isEmpty) else {
                    VFGErrorLog("no sections received")
                    completion(nil, MVAError.empty)
                    return
                }
                self.dashboardSections = sections
                if url.contains("shimmer") {
                    completion(VFGDashboardDataProvider.prepareViewModel(sections), nil)
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        completion(VFGDashboardDataProvider.prepareViewModel(sections), nil)
                    }
                }
            case .failure(let error):
                VFGErrorLog("Failed to load \(url) error:\(error.localizedDescription)")
                completion(nil, error)
            }
        }
    }
}
