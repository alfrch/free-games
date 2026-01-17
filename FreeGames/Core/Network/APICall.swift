//
//  Untitled.swift
//  FreeGames
//
//  Created by Alif Rachmawan on 17/01/26.
//

import Foundation

struct API {
  static let baseUrl = "https://gamerpower.com/api"
}

protocol Endpoint {
  var url: String { get }
}

enum Endpoints {
  
  enum Gets: Endpoint {
    case giveaways
    
    public var url: String {
      switch self {
      case .giveaways:
        return "\(API.baseUrl)/giveaways"
      }
    }
  }
}
