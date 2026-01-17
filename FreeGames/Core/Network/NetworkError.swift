//
//  NetworkError.swift
//  FreeGames
//
//  Created by Alif Rachmawan on 16/01/26.
//

import Foundation

enum NetworkError: LocalizedError {
  case invalidResponse
  case addressUnreachable(URL)
  case invalidURL
  case parsingError
  case unknown(Error)
  
  var errorDescription: String? {
    switch self {
    case .invalidResponse: return "The server responded with garbage."
    case .addressUnreachable(let url): return "\(url.absoluteString) is unreachable."
    case .invalidURL: return "The provided URL is not in a valid format."
    case .parsingError: return "The data could not be parsed due to an invalid format."
    case .unknown(let error): return error.localizedDescription
    }
  }
}
