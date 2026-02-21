//
//  DatabaseError.swift
//  FreeGames
//
//  Created by Alif Rachmawan on 21/02/26.
//

import Foundation

enum DatabaseError: LocalizedError {
  
  case invalidInstance
  case requestFailed
  
  var errorDescription: String? {
    switch self {
    case .invalidInstance: return "Database can't instance."
    case .requestFailed: return "Your request failed."
    }
  }
  
}
