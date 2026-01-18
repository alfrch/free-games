//
//  FreeGamesApp.swift
//  FreeGames
//
//  Created by Alif Rachmawan on 16/01/26.
//

import SwiftUI

@main
struct FreeGamesApp: App {
  @StateObject var homePresenter = HomePresenter(useCase: Injection().provideHome())
  @StateObject var favoritePresenter = FavoritePresenter(useCase: Injection().provideHome())
  @StateObject var aboutPresenter = AboutPresenter()
  
  var body: some Scene {
    WindowGroup {
      ContentView()
        .environmentObject(homePresenter)
        .environmentObject(favoritePresenter)
        .environmentObject(aboutPresenter)
    }
  }
}
