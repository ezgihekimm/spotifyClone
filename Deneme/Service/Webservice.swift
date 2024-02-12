//
//  Webservice.swift
//  Deneme
//
//  Created by Ezgi Hekim on 7.02.2024.
//

import Foundation

public enum GenresError : Error {
    case serverError
    case parsingError
    case tokenError
}

class Webservice {
    
    func downloadData (url: URL, completion: @escaping (Result<Genres,GenresError>) -> ()){
        
        let clientID = "21a8693272424359b0e37dd473614acc"
        let clientSecret = "074fa3675c1f441584f2ffe975b21876"
        
        let tokenURL = URL(string: "https://accounts.spotify.com/api/token")!
        let tokenParams = [
            "grant_type": "client_credentials",
            "client_id": clientID,
            "client_secret": clientSecret
        ]
        
        var tokenRequest = URLRequest(url: tokenURL)
        tokenRequest.httpMethod = "POST"
        tokenRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let bodyParams = "grant_type=client_credentials&client_id=\(clientID)&client_secret=\(clientSecret)"
              tokenRequest.httpBody = bodyParams.data(using: .utf8)
        
        URLSession.shared.dataTask(with: tokenRequest) { tokenData, tokenResponse, tokenError in
            guard let tokenData = tokenData
                    , tokenError == nil
            else {
                completion(.failure(.tokenError))
                print("token error")
                return
            }
            print("token", tokenData)
            
            guard let tokenResponse = try? JSONDecoder().decode(TokenResponse.self, from: tokenData) else {
                completion(.failure(.parsingError))
                print("parsing error")
                return
            }
            
            var dataRequest = URLRequest(url: url)
            dataRequest.setValue("Bearer \(tokenResponse.accessToken)", forHTTPHeaderField: "Authorization")
            
            
            URLSession.shared.dataTask(with: dataRequest) { data, response, error in
                if let error = error {
                    completion(.failure(.serverError))
                    print(error)
                } else if let data = data {
                    
                    let genresList = try? JSONDecoder().decode(Genres.self, from: data)
                    
                    if let genresList = genresList {
                        completion(.success(genresList))
                        print(genresList)
                    } else {
                        completion(.failure(.parsingError))
                        print("errorss")
                    }
                }
            }.resume()
            
        }.resume()
    }
}
