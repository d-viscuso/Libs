//
//  VFGNetworkClient+Response.swift
//  VFGMVA10Foundation
//
//  Created by Yahya Saddiq on 3/23/21.
//  Copyright © 2021 Vodafone. All rights reserved.
//

// MARK: - Response mapper
/// `VFGNetworkClient` class extension.
extension VFGNetworkClient {
    /// A method which is used to decode Json data
    /// - Parameters:
    ///   - responseData: An object of type *Data* which represents the response data which will be decoded.
    ///   - model: A generic type which represents the model that corresponds to the response data.
    ///   - completion: A completion handler that gets invoked once the data decoding is done.
    func internalDecodeJsonData<T: Codable>(
        _ responseData: Data,
        _ model: T.Type,
        _ completion: @escaping VFGNetworkCompletionDelegate<T>
    ) {
        do {
            let responseDataWithDecodedDates = decodeDate(responseData) ?? responseData
            let apiResponse = try JSONDecoder().decode(model, from: responseDataWithDecodedDates)

            DispatchQueue.main.async {
                completion(.success(apiResponse))
            }
        } catch {
            DispatchQueue.main.async {
                completion(.failure(VFGNetworkError.serverUnableToDecode))
            }
        }
    }

    private func decodeDate(_ responseData: Data) -> Data? {
        let replacingDate = Date()
        var reponseDataWithDecodedDates = String(decoding: responseData, as: UTF8.self)

        let dateComponentsRegex: [DateComponentRegex] = [.day(), .month(), .interval()]

        dateComponentsRegex.forEach { component in
            if let rawDates = reponseDataWithDecodedDates.matches(with: component.searchingRegex) {
                let computedDates = rawDates
                    .map { rawDate in
                        rawDate.replacingOccurrences(
                            of: component.replacingRegex, with: "", options: .regularExpression
                        )
                    }
                    .compactMap { intervalString in
                        Int(intervalString)
                    }
                    .compactMap { interval in
                        VFGDateHelper.addDateComponent(to: replacingDate, with: interval, component: component)
                    }
                    .map { date in
                        VFGDateHelper.getStringFromDate(date: date)
                    }

                for (rawDate, computedDate) in zip(rawDates, computedDates) {
                    reponseDataWithDecodedDates = reponseDataWithDecodedDates
                        .replacingOccurrences(of: rawDate, with: computedDate)
                }
            }
        }
        return reponseDataWithDecodedDates.data(using: .utf8)
    }

    private func log<T: Codable>(_ result: T) {
        // remove place holder before logging to avoid crash
        let stringPlaceholderPattern = "\\%(?:\\d+\\$s)"
        let loggedResponse = result.toString()?.replacingOccurrences(
            of: stringPlaceholderPattern,
            with: " ",
            options: .regularExpression) ?? ""

        VFGNetworkLogger.log(jsonResponse: loggedResponse)
    }

    /// A method which is used to map a given reponse arguments.
    /// - Parameters:
    ///   - responseArg: A tuple of type *ResponseArg* which holds a group of objects including data, url response and error.
    ///   - model: A generic type which represents the model that corresponds to the response data.
    ///   - completion: A completion handler that gets invoked once the response maping is done.
    func internalMapResponse<T: Codable>(
        responseArg: ResponseArg,
        model: T.Type,
        completion: @escaping VFGNetworkCompletionDelegate<T>
    ) {
        guard responseArg.error == nil else {
            DispatchQueue.main.async {
                if let error = responseArg.error {
                    self.headerFields = (responseArg.urlResponse as? HTTPURLResponse)?.allHeaderFields
                    completion(.failure(error))
                }
            }
            return
        }
        guard let httpResponse = responseArg.urlResponse as? HTTPURLResponse else {
            // check if response for local file
            headerFields = nil
            if responseArg.urlResponse?.url?.isFileURL ?? false, let responseData = responseArg.data {
                decodeJsonData(responseData, model, completion)
            } else {
                DispatchQueue.main.async {
                    completion(.failure(VFGNetworkError.empty))
                }
            }
            return
        }

        headerFields = httpResponse.allHeaderFields
        guard let result = httpResponse.handleNetworkResponse() else {
            guard let responseData = responseArg.data else {
                DispatchQueue.main.async {
                    completion(.failure(VFGNetworkError.serverNoData))
                }
                return
            }
            VFGNetworkLogger.log(response: httpResponse)
            decodeJsonData(responseData, model, completion)
            return
        }
        DispatchQueue.main.async {
            completion(.failure(result))
        }
    }
}
