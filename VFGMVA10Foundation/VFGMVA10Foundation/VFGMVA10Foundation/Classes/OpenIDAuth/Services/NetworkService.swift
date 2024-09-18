//
//  NetworkService.swift
//  VFGMVA10Foundation
//
//  Created by Hussein Gamal on 06/06/2019.
//

import Foundation
class NetworkService: NSObject {
    typealias CompleteClosure = (_ parsedModel: Any?, _ error: VFGLoginError?) -> Void
    var session: URLSessionProtocol?
    func networkRequest(
        request: URLRequest,
        parser: ParserProtocol,
        withCompletion completion: @escaping CompleteClosure
    ) {
        let session = self.session ?? URLSession(configuration: .default, delegate: self, delegateQueue: .main)
        let task = session.dataTask(with: request) { data, response, _ in
            do {
                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(nil, VFGLoginError.defaultError)
                    return
                }
                let readingOption = JSONSerialization.ReadingOptions.mutableContainers
                guard let responseData = data,
                    let responseDictionary = try JSONSerialization.jsonObject(
                        with: responseData,
                        options: readingOption)
                    as? NSDictionary else {
                        return
                }
                switch httpResponse.statusCode {
                case 200:
                    let parsedModel = parser.parse(rawData: responseDictionary)
                    completion(parsedModel, nil)
                case 400, 401:
                    let parsedError = ErrorParser().parse(rawData: responseDictionary) as? VFGLoginError
                    completion(nil, parsedError)
                default:
                    completion(nil, VFGLoginError.defaultError)
                }
            } catch {
                completion(nil, VFGLoginError.defaultError)
            }
        }
        task.resume()
        (session as? URLSession)?.finishTasksAndInvalidate()
    }
}

#if DEBUG
let hostURL = "oauth2portaldev.mtx.vodafonemalta.com"
#else
let hostURL = ""
#endif
extension NetworkService: URLSessionDelegate {
    func urlSession(
        _ session: URLSession,
        didReceive challenge: URLAuthenticationChallenge,
        completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void
    ) {
        if challenge.protectionSpace.host == hostURL {
            guard let serverTrust = challenge.protectionSpace.serverTrust else {
                completionHandler(.useCredential, nil)
                return
            }
            completionHandler(.useCredential, URLCredential(trust: serverTrust))
        } else {
            completionHandler(.performDefaultHandling, nil)
        }
    }
}
