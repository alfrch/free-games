//
//  DetailView.swift
//  FreeGames
//
//  Created by Alif Rachmawan on 18/01/26.
//

import SwiftUI
import CachedAsyncImage
import Game
import Core

struct DetailView: View {
  @StateObject var presenter: GamePresenter<
    Interactor<
      String,
      GameModel,
      GetGameRepository<GetGamesLocalDataSource, GameTransformer>
    >,
    Interactor<
      String,
      GameModel,
      UpdateFavoriteGameRepository<GetFavoriteGamesLocalDataSource, GameTransformer>
    >
  >
      
  @State private var showSafari = false
  
  var game: GameModel
  
  var body: some View {
    ScrollView(.vertical) {
      VStack(alignment: .leading, spacing: 20) {
        thumbnailImage
        contentView
      }
    }
    .onAppear {
      self.presenter.getGame(request: "\(game.id)")
    }
    .navigationTitle("Detail")
    .navigationBarTitleDisplayMode(.inline)
    .toolbar {
      Button {
        presenter.updateFavoriteGame(request: "\(game.id)")
      } label: {
        Image(systemName: presenter.item?.favorite ?? false ? "heart.fill" : "heart")
          .foregroundStyle(.red)
      }
    }
    .sheet(isPresented: $showSafari) {
      if let url = URL(string: presenter.item?.url ?? "") {
        SafariView(url: url)
          .ignoresSafeArea()
      }
    }
  }
  
  var thumbnailImage: some View {
    CachedAsyncImage(url: URL(string: presenter.item?.thumbnail ?? "")) { image in
      image
        .resizable()
        .aspectRatio(contentMode: .fill)
        .frame(minWidth: 0, maxWidth: .infinity)
    } placeholder: {
      ProgressView()
    }
    .frame(height: 250)
    .clipped()
  }
  
  var contentView: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text(presenter.item?.title ?? "")
        .font(.largeTitle)
        .bold()
      
      // Platforms
      FlowLayout(spacing: 8) {
        ForEach(presenter.item?.platforms ?? [], id: \.self) { platform in
          Text(platform)
            .font(.caption)
            .fontWeight(.medium)
            .foregroundColor(.blue)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color.blue.opacity(0.1))
            .cornerRadius(8)
            .fixedSize(horizontal: true, vertical: false)
        }
      }
      
      Button {
        showSafari = true
      } label: {
        Text("Get Game")
          .font(.headline)
          .foregroundColor(.white)
          .frame(maxWidth: .infinity)
          .padding()
          .background(Color.blue)
          .cornerRadius(12)
      }
      
      Text("Description")
        .font(.headline)
      
      Text(presenter.item?.description ?? "")
        .font(.body)
        .foregroundStyle(.secondary)
        .lineSpacing(4)
    }
    .padding([.horizontal, .bottom], 16)
  }
}

#Preview {
//  DetailView()
}
