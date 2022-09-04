//
//  NetworkService.swift
//  forWhite&Fluffy
//
//  Created by Egor SAUSHKIN on 03.09.2022.
//

import UIKit
import Alamofire

class NetworkService {
    
    let token = "xOZhFXxLD9YKp4qiq7SaLlJzLLs8nHrTCdUtOOQlmAc"
    let url = "https://api.unsplash.com/photos/?client_id=xOZhFXxLD9YKp4qiq7SaLlJzLLs8nHrTCdUtOOQlmAc"
    
    func urlRequest(completion: @escaping ([UIImage], [String?], [String?], [String?]) -> Void) {
        AF.request(url).responseDecodable(of: [Pictures].self) { response in
            guard let value = response.value else { return }
            var imagesArray = [UIImage]()
            var authors = [String?]()
            var locations = [String?]()
            var dates = [String?]()
            for each in value {
                //String data
                let author = each.user.name
                let creation_date = each.created_at
                let location = each.user.location
                authors.append(author)
                dates.append(creation_date)
                locations.append(location)
                
                //Pictures data
                guard let pictureName = each.urls.small else { return }
                guard let url = URL(string: pictureName)
                else {
                    print("Unable to create URL")
                    return
                }
                do {
                    let data = try Data(contentsOf: url, options: [])
                    guard let image = UIImage(data: data) else { return }
                    imagesArray.append(image)
                }
                catch {
                    print(error.localizedDescription)
                }
            }
            completion(imagesArray, authors, locations, dates)
        }
    }
    
    func searchRequest(withText text: String, completion: @escaping ([UIImage], [String?], [String?], [String?]) -> Void){
        guard let url = URL(string: "https://api.unsplash.com/search/photos?query=\(text)") else { return }
        var request = URLRequest(url: url)
        request.setValue("Client-ID \(token)", forHTTPHeaderField: "Authorization")
        AF.request(request).responseDecodable(of: Results.self) { response in
            guard let value = response.value else { return }
            var imagesArray = [UIImage]()
            var authors = [String?]()
            var locations = [String?]()
            var dates = [String?]()
            for each in value.results {
                //String data
                let author = each.user.name
                let creation_date = each.created_at
                let location = each.user.location
                authors.append(author)
                dates.append(creation_date)
                locations.append(location)
                
                //Pictures data
                guard let pictureName = each.urls.small else { return }
                guard let url = URL(string: pictureName)
                else {
                    print("Unable to create URL")
                    return
                }
                do {
                    let data = try Data(contentsOf: url, options: [])
                    guard let image = UIImage(data: data) else { return }
                    imagesArray.append(image)
                }
                catch {
                    print(error.localizedDescription)
                }
            }
            completion(imagesArray, authors, locations, dates)
        }
    }
    
}
