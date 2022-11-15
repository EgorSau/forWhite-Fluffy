//
//  NetworkService.swift
//  forWhite&Fluffy
//
//  Created by Egor SAUSHKIN on 03.09.2022.
//

import UIKit
import Alamofire

class NetworkService {
    func urlRequest(completion: @escaping (AFResult<[Pictures]>) throws -> Void) {
        AF.request(UrlConstants.mainUrl).responseDecodable(of: [Pictures].self) { response in
            do {
                try completion(response.result)
            } catch {
                print(response.error as Any)
            }
        }
    }
    func searchRequest(withText text: String, completion: @escaping (AFResult<Results>) throws -> Void) {
        guard let url = URL(string: UrlConstants.searchUrl + text) else { return }
        var request = URLRequest(url: url)
        request.setValue(UrlConstants.clientID + UrlConstants.token, forHTTPHeaderField: UrlConstants.authorization)
        AF.request(request).responseDecodable(of: Results.self) { response in
            do {
                try completion(response.result)
            } catch {
                print(response.error as Any)
            }
        }
    }
}
