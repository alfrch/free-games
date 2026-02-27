//
//  GameMapper.swift
//  FreeGames
//
//  Created by Alif Rachmawan on 17/01/26.
//

import Foundation
import RealmSwift
import Game

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
  
  static func mapGameResponsesToEntities(input responses: [GameResponse]) -> [GameEntity] {
    return responses.map { result in
      let gameEntity = GameEntity()
      gameEntity.id = "\(result.id ?? 0)"
      gameEntity.title = result.title ?? "Unknown Title"
      gameEntity.price = result.worth ?? "N/A"
      gameEntity.thumbnail = result.thumbnail ?? ""
      gameEntity.desc = result.description ?? "No description available"
      gameEntity.type = result.type ?? "Unknown"
      
      let platformArray = result.platforms?.components(separatedBy: ", ") ?? []
      gameEntity.platforms.removeAll()
      gameEntity.platforms.append(objectsIn: platformArray)
      return gameEntity
    }
  }
  
  static func mapGameEntitiesToDomains(input entities: [GameEntity]) -> [GameModel] {
    return entities.map { result in
      return GameModel(
        id: Int(result.id) ?? 0,
        title: result.title,
        price: result.price,
        thumbnail: result.thumbnail,
        description: result.desc,
        type: result.type,
        platforms: Array(result.platforms),
        url: result.url,
        favorite: result.favorite
      )
    }
  }
  
  static func mapGameEntityToDomain(input entity: GameEntity) -> GameModel {
    return GameModel(
      id: Int(entity.id) ?? 0,
      title: entity.title,
      price: entity.price,
      thumbnail: entity.thumbnail,
      description: entity.desc,
      type: entity.type,
      platforms: Array(entity.platforms),
      url: entity.url,
      favorite: entity.favorite
    )
  }
}
