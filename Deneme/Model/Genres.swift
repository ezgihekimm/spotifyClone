//
//  Genres.swift
//  Deneme
//
//  Created by Ezgi Hekim on 7.02.2024.
//

import Foundation

struct Genres: Decodable {
    let genres: [String]
}

struct TokenResponse: Codable {
    let accessToken: String
}


