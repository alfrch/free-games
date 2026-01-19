//
//  ContentView.swift
//  FreeGames
//
//  Created by Alif Rachmawan on 16/01/26.
//

import SwiftUI

struct ContentView: View {
  var body: some View {
    TabView {
      NavigationStack {
        HomeView()
      }
      .tabItem {
        Label("Home", systemImage: "house.fill")
      }
      
      NavigationStack {
        FavoriteView()
      }
      .tabItem {
        Label("Favorite", systemImage: "heart.fill")
      }
      
      NavigationStack {
        AboutView()
      }
      .tabItem {
        Label("About", systemImage: "person.fill")
      }
    }
  }
}

#Preview {
  ContentView()
}
