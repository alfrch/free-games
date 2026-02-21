//
//  GameModel.swift
//  FreeGames
//
//  Created by Alif Rachmawan on 16/01/26.
//

import Foundation

struct GameModel: Identifiable, Equatable {
  let id: Int
  let title: String
  let price: String
  let thumbnail: String
  let description: String
  let type: String
  let platforms: [String]
  let url: String
  var favorite: Bool = false
}
