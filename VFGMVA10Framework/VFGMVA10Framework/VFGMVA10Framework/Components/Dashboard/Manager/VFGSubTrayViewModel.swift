//
//  VFGSubTrayViewModel.swift
//  VFGMVA10Framework
//
//  Created by Ahmed Sultan on 2/17/20.
//

import VFGMVA10Foundation

/// Dashboard sub tray view model
open class VFGSubTrayViewModel: VFGSubTrayViewModelProtocol {
    public var dataProvider: VFGSubTrayDataProviderProtocol?
    /// A data array for dashboard sub trays
    public var subTrayContainer: [String: VFGSubTrayModel] = [:]

    private var networkClient: VFGNetworkClient?
    private var subtrayId = ""
    private var subtrayTitle = ""
    private var isExpandedTrayEnabled: Bool?
    private var trayConfigurations: [String: Any]?
    private var filePath = ""

    static var bundle = Bundle.main
    /// *VFGSubTrayViewModel* initializer
    /// - Parameters:
    ///    - dataProvider: Dashboard sub tray data provider
    public init(dataProvider: VFGSubTrayDataProviderProtocol? = nil) {
        self.dataProvider = dataProvider ?? self
    }

    @discardableResult
    public func setup(
        key subtrayId: String,
        subtrayTitle: String,
        trayConfigurations: [String: Any]?,
        completion: SubTrayCompletion? = nil
    ) -> VFGSubTrayModel? {
        self.subtrayId = subtrayId
        self.subtrayTitle = subtrayTitle
        self.trayConfigurations = trayConfigurations

        guard let path = VFGSubTrayViewModel.getPath(subtrayId: subtrayId) else {
            let error = URLError(.fileDoesNotExist)
            DispatchQueue.main.async {
                completion?(nil, error)
            }
            return subTrayContainer[subtrayId]
        }

        filePath = path
        loadSubTrayWith(subTrayId: subtrayId, completion: completion)
        // synch return to refresh data with last shown if exist else will be empty
        return subTrayContainer[subtrayId]
    }

    private func loadSubTrayWith(
        subTrayId: String,
        completion: SubTrayCompletion? = nil
    ) {
        dataProvider?.requestData(with: subTrayId) { [weak self] result in
            switch result {
            case .success(let subTrayModel):
                self?.appendSubTrayModel(subTray: subTrayModel)
                self?.fetchSubtrayData(completion: completion)
            case .failure:
                if let self = self {
                    completion?(nil, VFGSubTrayErrorResponse.network(self.subtrayTitle))
                }
            }
        }
    }

    private func appendSubTrayModel(subTray: VFGSubTrayModel) {
        var updatedSubTray = subTray

        updatedSubTray.metaData = trayConfigurations
        updatedSubTray.title = subtrayTitle
        subTrayContainer[subtrayId] = updatedSubTray
    }

    private func fetchSubtrayData(completion: SubTrayCompletion? = nil) {
        guard let subTrayItems = subTrayContainer[subtrayId]?.items else {
            completion?(nil, VFGSubTrayErrorResponse.network(subtrayTitle))
            return
        }
        if subTrayItems.isEmpty {
            completion?(nil, nil)
            return
        }

        let dispatchGroup = DispatchGroup()

        subTrayItems.forEach { subTrayItem in
            switch subTrayItem.badge {
            case SubTrayBadge.paymentMethods.rawValue:
                dispatchGroup.enter()
                VFGPaymentManager.fetchPaymentCards { _, _ in
                    dispatchGroup.leave()
                }
            default:
                break
            }
        }

        dispatchGroup.notify(queue: DispatchQueue.main) { [weak self] in
            guard let self = self else {
                return
            }

            completion?(self.subTrayContainer[self.subtrayId], nil)
        }
    }

    private static func getPath(subtrayId: String) -> String? {
        if URL(string: subtrayId)?.isFileURL ?? false {
            return subtrayId
        } else {
            return bundle.url(forResource: subtrayId, withExtension: "json")?.absoluteString
        }
    }
}

extension VFGSubTrayViewModel: VFGSubTrayDataProviderProtocol {
    public func requestData(
        with subTrayID: String,
        completion: @escaping (Result<VFGSubTrayModel, Error>) -> Void
    ) {
        let request = VFGRequest()
        networkClient = VFGNetworkClient(baseURL: filePath)
        networkClient?.executeData(request: request, model: VFGSubTrayModel.self, completion: completion)
    }
}
