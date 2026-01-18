//
//  AboutPresenter.swift
//  FreeGames
//
//  Created by Alif Rachmawan on 18/01/26.
//

import SwiftUI
import Combine

@MainActor
final class AboutPresenter: ObservableObject {
  let name = "Alif Rachmawan"
  let occupation = "iOS Developer"
  let features: [FeatureModel]
  
  init() {
    self.features = [
      FeatureModel(
        id: UUID().uuidString,
        icon: "house.fill",
        color: .blue,
        title: "Game Discovery",
        description: "Browse through curated list of free games"
      ),
      FeatureModel(
        id: UUID().uuidString,
        icon: "heart.fill",
        color: .red,
        title: "Favorites",
        description: "Save your favorite games for quick access"
      ),
      FeatureModel(
        id: UUID().uuidString,
        icon: "info.circle.fill",
        color: .purple,
        title: "Detailed Info",
        description: "Get complete information about each game"
      )
    ]
  }
}
