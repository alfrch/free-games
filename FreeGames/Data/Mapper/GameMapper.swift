//
//  GameMapper.swift
//  FreeGames
//
//  Created by Alif Rachmawan on 17/01/26.
//

import Foundation

final class GameMapper {
  static func mapGameResponsesToDomains(input responses: [GameResponse]) -> [GameModel] {
    return responses.map { result in
      return GameModel(
        id: result.id ?? 0,
        title: result.title ?? "Unknown Title",
        price: result.worth ?? "N/A",
        thumbnail: result.thumbnail ?? "",
        description: result.description ?? "No description available",
        type: result.type ?? "Unknown",
        platforms: result.platforms?.components(separatedBy: ", ") ?? [],
        url: result.url ?? ""
      )
    }
  }
}
