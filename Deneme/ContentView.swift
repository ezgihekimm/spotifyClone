//
//  ContentView.swift
//  Deneme
//
//  Created by Ezgi Hekim on 5.02.2024.
//

import SwiftUI
import RxSwift
import RxCocoa

struct ContentView: View {
    
    let genreVM = GenresViewModel()
    let disposeBag = DisposeBag()

    @State private var genreList = [Genres]()
  
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .onAppear{
            setupBindings()
            genreVM.requestData()
        }
    }
    
    private func setupBindings(){
        genreVM
            .error
            .observe(on: MainScheduler.asyncInstance)
            .subscribe {errorString in
                print(errorString)
            }
            .disposed(by: disposeBag)
        
        genreVM
            .genre
            .observe(on: MainScheduler.asyncInstance)
            .subscribe { genres in
                self.genreList = genres
                print(genres)
            }
            .disposed(by: disposeBag)
            
    }
}

#Preview {
    ContentView()
}
