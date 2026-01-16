//
//  ContentView.swift
//  FreeGames
//
//  Created by Alif Rachmawan on 16/01/26.
//

import SwiftUI

struct ContentView: View {
  var body: some View {
    NavigationStack {
      TabView {
        HomeView()
          .tabItem {
            Label("Home", systemImage: "house.fill")
          }
      }
    }
  }
}

#Preview {
  ContentView()
}
