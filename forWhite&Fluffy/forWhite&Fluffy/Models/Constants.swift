//
//  Constants.swift
//  forWhite&Fluffy
//
//  Created by Egor SAUSHKIN on 04.09.2022.
//

import UIKit

struct BasicSpacing {
    static let positive: CGFloat = 8
    static let negative: CGFloat = -8
}

struct UrlConstants {
    static let token = "xOZhFXxLD9YKp4qiq7SaLlJzLLs8nHrTCdUtOOQlmAc"
    static let mainUrl = "https://api.unsplash.com/photos/?client_id=xOZhFXxLD9YKp4qiq7SaLlJzLLs8nHrTCdUtOOQlmAc"
    static let searchUrl = "https://api.unsplash.com/search/photos?query="
    static let clientID = "Client-ID "
    static let authorization = "Authorization"
}

struct Alert {
    static let warningTitle = "Warning!"
    static let warningMessage = "This picture was deleted from favorites"
    static let greatTitle = "Great!"
    static let greatMessage = "This picture was added to favorites"
    static let actionTitle = "OK"
    static let notFoundTitle = "Please change keyword"
}
