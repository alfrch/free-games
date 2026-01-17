//
//  RemoteDataSource.swift
//  FreeGames
//
//  Created by Alif Rachmawan on 17/01/26.
//

import Foundation
import Alamofire

protocol RemoteDataSourceProtocol: AnyObject {
  func getGames() async throws -> [GameResponse]
}

final class RemoteDataSource: RemoteDataSourceProtocol {
  
  static let shared = RemoteDataSource()
  
  private init() {}
  
  func getGames() async throws -> [GameResponse] {
    guard let url = URL(string: Endpoints.Gets.giveaways.url) else {
      throw NetworkError.invalidURL
    }
    
    do {
      return try await AF.request(url)
        .validate()
        .serializingDecodable([GameResponse].self)
        .value
    } catch {
      if let afError = error.asAFError {
        if afError.isResponseSerializationError {
          throw NetworkError.parsingError
        }
      }
      throw NetworkError.invalidResponse
    }
  }
}
