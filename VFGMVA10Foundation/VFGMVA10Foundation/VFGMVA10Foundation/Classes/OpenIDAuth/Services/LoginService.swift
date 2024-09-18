//
//  LoginService.swift
//  VFGMVA10Foundation
//
//  Created by Hussein Gamal on 03/06/2019.
//

import Foundation

typealias LoginServiceClosure = (Response) -> Void

enum Response {
    case result(Any)
    case error(VFGLoginError)
}

class LoginService {
    let networkService = NetworkService()

    func initOpenIdConfiguration(with url: String, closure: @escaping LoginServiceClosure) {
        guard let url = URL(string: url) else {
            return
        }
        let configurationParser = OpenIdConfigurationParser()
        let configurationRequest = URLRequest(url: url)

        networkService.networkRequest(
            request: configurationRequest,
            parser: configurationParser) { data, error in
            guard let configuration = data  as? OpenIDConfiguration, error == nil else {
                closure(Response.error(VFGLoginError.defaultError))
                return
            }
            closure(Response.result(configuration))
        }
    }

    func login(
        tokenEndpoint: String,
        credential: LoginCredential,
        configuration: VFGTokenRequestConfiguration,
        closure: @escaping LoginServiceClosure
    ) {
        var request = NSMutableURLRequest()
        request.url = URL(string: tokenEndpoint)

        UrlParameterEncoder().getRequest(request: &request, credential: credential, configuration: configuration)

        let tokensRequest = request as URLRequest
        let tokenReponseParser = TokenResponseParser()

        networkService.networkRequest(
            request: tokensRequest,
            parser: tokenReponseParser) { data, error in
            if let errorResponse = error {
                closure(Response.error(errorResponse))
                return
            }
            guard let tokens = data as? TokenResponse else {
                closure(Response.error(VFGLoginError.defaultError))
                return
            }
            closure(Response.result(tokens))
        }
    }
}
