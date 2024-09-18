//
//  VFGNetworkClient+Upload.swift
//  VFGMVA10Foundation
//
//  Created by Yahya Saddiq on 3/23/21.
//  Copyright © 2021 Vodafone. All rights reserved.
//

/// `VFGNetworkClient` class extension.
extension VFGNetworkClient {
    /// A method which gives you the ability to upload tasks.
    /// You can upload an object of type encodable by just passing the file model to upload method through `VFGNetworkClient`.
    /// - Parameters:
    ///   - request: An object of type *VFGRequestProtocol* which represents the network request.
    ///   - responseModel: A generic type which conforms to `Codable` and used to handle uploading response.
    ///   - uploadModel: An object of a generic type which conforms to `Encodable` and represents the uploaded data.
    ///   - completion: A completion handler which gets invoked once the upload completed.
    func internalUpload<T: Codable, U: Encodable>(
        request: VFGRequestProtocol,
        responseModel: T.Type,
        uploadModel: U,
        completion: @escaping VFGNetworkCompletionDelegate<T>
    ) {
        let fullRequestHeaders = buildHeaders(request: request, completion: completion)
        do {
            let urlRequest = try buildRequest(from: request, with: fullRequestHeaders, to: URL(string: baseUrl))
            VFGNetworkLogger.log(request: urlRequest)
            let uploadModeldata = try JSONEncoder().encode(uploadModel)
            let currentTask = session.uploadTask(
                with: urlRequest,
                from: uploadModeldata) { [weak self] data, response, error in
                let resType: ResponseArg = (data, response, error)
                guard let self = self else {
                    return
                }
                self.mapResponse(
                    responseArg: resType,
                    model: responseModel,
                    completion: completion)
            }
            currentTask.resume()
        } catch {
            DispatchQueue.main.async {
                completion(.failure(VFGNetworkError.unknown))
            }
        }
    }
}
