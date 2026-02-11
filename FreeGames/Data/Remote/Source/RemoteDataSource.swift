//
//  RemoteDataSource.swift
//  FreeGames
//
//  Created by Alif Rachmawan on 17/01/26.
//

import Foundation
import Alamofire
import Combine

protocol RemoteDataSourceProtocol: AnyObject {
  func getGames() -> AnyPublisher<[GameResponse], Error>
}

final class RemoteDataSource: RemoteDataSourceProtocol {
  
  static let shared = RemoteDataSource()
  
  private init() {}
  
  func getGames() -> AnyPublisher<[GameResponse], Error> {
    return Future<[GameResponse], Error> { completion in
      guard let url = URL(string: Endpoints.Gets.giveaways.url) else {
        completion(.failure(NetworkError.invalidURL))
        return
      }
      
      AF.request(url)
        .validate()
        .responseDecodable(of: [GameResponse].self) { response in
          switch response.result {
          case .success(let games):
            completion(.success(games))
          case .failure(let error):
            if let afError = error.asAFError {
              if afError.isResponseSerializationError {
                completion(.failure(NetworkError.parsingError))
                return
              }
            }
            completion(.failure(NetworkError.invalidResponse))
          }
        }
    }
    .eraseToAnyPublisher()
  }
}
