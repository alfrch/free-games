//
//  GameResponse.swift
//  FreeGames
//
//  Created by Alif Rachmawan on 16/01/26.
//

import Foundation

struct GameResponse: nonisolated Decodable {
  let id: Int?
  let title: String?
  let worth: String?
  let thumbnail: String?
  let description: String?
  let type: String?
  let platforms: String?
  let url: String?
  
  enum CodingKeys: String, CodingKey {
    case id,
         title,
         worth,
         thumbnail,
         description,
         type,
         platforms
    case url = "gamerpower_url"
  }
}
