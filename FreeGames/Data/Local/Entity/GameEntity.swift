//
//  GameEntity.swift
//  FreeGames
//
//  Created by Alif Rachmawan on 21/02/26.
//

import Foundation
import RealmSwift

class GameEntity: Object {
  @objc dynamic var id = ""
  @objc dynamic var title = ""
  @objc dynamic var price = ""
  @objc dynamic var thumbnail = ""
  @objc dynamic var desc = ""
  @objc dynamic var type = ""
  @objc dynamic var url = ""
  @objc dynamic var favorite: Bool = false
  
  var platforms = [String]()
  
  override nonisolated static func primaryKey() -> String? {
    return "id"
  }
}
