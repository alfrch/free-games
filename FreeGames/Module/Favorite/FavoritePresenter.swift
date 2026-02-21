//
//  FavoritePresenter.swift
//  FreeGames
//
//  Created by Alif Rachmawan on 18/01/26.
//

import SwiftUI
import Combine

@MainActor
final class FavoritePresenter: ObservableObject {
  
  @Published var games: [GameModel] = []
  @Published var errorMessage: String?
  @Published var isLoading = false
  
  private let router = HomeRouter()
  private let useCase: FavoriteUseCase
  
  private var cancellables = Set<AnyCancellable>()
  
  init(useCase: FavoriteUseCase) {
    self.useCase = useCase
  }
  
  func getGames() {
    isLoading = true
    defer { isLoading = false }
    
    useCase.getFavoriteGames()
      .receive(on: RunLoop.main)
      .sink { [weak self] completion in
        guard let self else { return }
        switch completion {
        case .finished: break
        case .failure(let error):
          self.errorMessage = error.localizedDescription
        }
      } receiveValue: { [weak self] result in
        guard let self else { return }
        self.games = result
      }
      .store(in: &cancellables)
  }
  
  func linkBuilder<Content: View>(
    for game: GameModel,
    @ViewBuilder content: () -> Content
  ) -> some View {
    NavigationLink(
      destination: router.makeDetailView(for: game)) {
        content()
      }
  }
}
