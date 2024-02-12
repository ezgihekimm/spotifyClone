//
//  GenresViewModel.swift
//  Deneme
//
//  Created by Ezgi Hekim on 7.02.2024.
//

import Foundation
import RxSwift
import RxCocoa

class GenresViewModel : ObservableObject {
    

    public let genre : PublishSubject<[Genres]> = PublishSubject()
    public let error : PublishSubject <String> = PublishSubject()
    
    public func requestData(){
        
        Webservice().downloadData(url: URL(string: "https://api.spotify.com/v1/recommendations/available-genre-seeds")! ){ genreResult in
            
            switch genreResult {
            case .success(let genres):
                print(genres)
                self.genre.onNext([genres])
            case .failure(let failure):
                switch failure {
                case .parsingError:
                    self.error.onNext("Cannot parse your data")
                case .serverError:
                    self.error.onNext("Cannot get your data at all")
                case .tokenError:
                    self.error.onNext("Cannot get token")
                }
            }
        }
    }
}
