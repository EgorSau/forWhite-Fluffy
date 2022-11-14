//
//  NetworkService.swift
//  forWhite&Fluffy
//
//  Created by Egor SAUSHKIN on 03.09.2022.
//

import UIKit
import Alamofire

class NetworkService {
    private let token = "xOZhFXxLD9YKp4qiq7SaLlJzLLs8nHrTCdUtOOQlmAc"
    private let url = "https://api.unsplash.com/photos/?client_id=xOZhFXxLD9YKp4qiq7SaLlJzLLs8nHrTCdUtOOQlmAc"
    func urlRequest(completion: @escaping (AFResult<[Pictures]>) throws -> Void) {
        AF.request(url).responseDecodable(of: [Pictures].self) { response in
            do {
                try completion(response.result)
            } catch {
                print("ОШИБКА!!!")
                print(response.error as Any)
            }
        }
    }
    func searchRequest(withText text: String, completion: @escaping (AFResult<Results>) throws -> Void) {
        guard let url = URL(string: "https://api.unsplash.com/search/photos?query=\(text)") else { return }
        var request = URLRequest(url: url)
        request.setValue("Client-ID \(token)", forHTTPHeaderField: "Authorization")
        AF.request(request).responseDecodable(of: Results.self) { response in
            do {
                try completion(response.result)
            } catch {
                print("ОШИБКА!!!")
                print(response.error as Any)
            }
        }
    }
}
