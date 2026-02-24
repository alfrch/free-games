//
//  DetailPresenter.swift
//  FreeGames
//
//  Created by Alif Rachmawan on 18/01/26.
//

import SwiftUI
import Combine

@MainActor
final class DetailPresenter: ObservableObject {
  
  @Published var game: GameModel?
  @Published var isFavorite = false
  @Published var isLoading = false
  @Published var errorMessage: String?
  
  private let getDetailUseCase: GetGameDetailUsecase
  private let updateFavoriteUseCase: UpdateFavoriteGameUseCase
  private var cancellables = Set<AnyCancellable>()
  
  init(getDetailUseCase: GetGameDetailUsecase, updateFavoriteUseCase: UpdateFavoriteGameUseCase) {
    self.getDetailUseCase = getDetailUseCase
    self.updateFavoriteUseCase = updateFavoriteUseCase
  }
  
  func getGameDetail() {
    isLoading = true
    defer { isLoading = false }
    getDetailUseCase.execute()
      .receive(on: RunLoop.main)
      .sink(receiveCompletion: { [weak self] completion in
        guard let self else { return }
        switch completion {
        case .finished: break
        case .failure(let error):
          self.errorMessage = error.localizedDescription
        }
      }, receiveValue: { [weak self] game in
        guard let self else { return }
        self.game = game
      })
      .store(in: &cancellables)
  }
  
  func updateFavoriteGame() {
    isLoading = true
    updateFavoriteUseCase.execute()
      .receive(on: RunLoop.main)
      .sink(receiveCompletion: { [weak self] completion in
        guard let self else { return }
        switch completion {
        case .finished:
          self.isLoading = false
        case .failure(let error):
          self.errorMessage = error.localizedDescription
        }
      }, receiveValue: { [weak self] game in
        guard let self else { return }
        self.game = game
      })
      .store(in: &cancellables)
  }
}
