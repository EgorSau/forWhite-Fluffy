//
//  Model.swift
//  forWhite&Fluffy
//
//  Created by Egor SAUSHKIN on 03.09.2022.
//

import UIKit

// MARK: Randome
struct Pictures: Decodable {
    let created_at: String?
    let urls: Urls
    let user: Users
    let id: String
}

// MARK: Search
struct Results: Decodable {
    let results: [Result]
}

struct Result: Decodable {
    let id: String
    let created_at: String
    let description: String?
    let urls: Urls
    let user: Users
}

// MARK: Common
struct Urls: Decodable {
    let small: String?
}

struct Users: Decodable {
    let name: String?
    let location: String?
}

struct ViewModel: ViewModelProtocol {
    let author: String
    let creationDate: String
    let location: String
}
