//
//  HomePresenter.swift
//  FreeGames
//
//  Created by Alif Rachmawan on 17/01/26.
//

import SwiftUI
import Combine
import Game

@MainActor
class HomePresenter: ObservableObject {
  
  @Published var games: [GameModel] = []
  @Published var favoriteIds: Set<Int> = []
  @Published var errorMessage: String?
  @Published var isLoading = false
  @Published var searchText = ""
  
  private let router = HomeRouter()
  private let getGamesUseCase: GetGamesUseCase
  private let searchUseCase: SearchGamesUseCase
  
  private var allGames: [GameModel] = []
  private var cancellables = Set<AnyCancellable>()
  
  init(getGamesUseCase: GetGamesUseCase, searchUseCase: SearchGamesUseCase) {
    self.getGamesUseCase = getGamesUseCase
    self.searchUseCase = searchUseCase
    setupSearchBinding()
  }
  
  private func setupSearchBinding() {
    $searchText
      .debounce(for: .milliseconds(350), scheduler: RunLoop.main)
      .removeDuplicates()
      .map { [weak self] keyword -> AnyPublisher<[GameModel], Never> in
        guard let self = self else {
          return Just([])
            .eraseToAnyPublisher()
        }
        
        if keyword.isEmpty {
          return Just(self.allGames)
            .eraseToAnyPublisher()
        }
        
        return self.searchUseCase.execute(query: keyword)
          .replaceError(with: [])
          .eraseToAnyPublisher()
      }
      .switchToLatest()
      .receive(on: RunLoop.main)
      .assign(to: &$games)
  }
  
  private func getGames() {
    isLoading = true
    defer { isLoading = false }
    
    getGamesUseCase.execute()
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
        self.allGames = result
        self.games = result
      }
      .store(in: &cancellables)
  }
  
  func loadIfNeeded() {
    guard allGames.isEmpty else { return }
    getGames()
  }
  
  func linkBuilder<Content: View>(
    for game: GameModel,
    @ViewBuilder content: () -> Content
  ) -> some View {
    NavigationLink(
      destination: router.makeDetailView(for: game)) { content() }
  }
}
