//
//  HomeView.swift
//  FreeGames
//
//  Created by Alif Rachmawan on 16/01/26.
//

import SwiftUI

struct HomeView: View {
  @EnvironmentObject var presenter: HomePresenter
  
  var body: some View {
    ScrollView {
      VStack(alignment: .center, spacing: 16) {
        // Header
        VStack(alignment: .leading, spacing: 4) {
          Text("Free Games")
            .font(.largeTitle)
            .fontWeight(.bold)
          
          Text("Discover amazing free games to play")
            .font(.subheadline)
            .foregroundStyle(.secondary)
        }
        .padding(.horizontal)
        .padding(.top, 8)
      }
    }
  }
}

#Preview {
  HomeView()
}
