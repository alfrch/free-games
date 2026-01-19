//
//  DetailView.swift
//  FreeGames
//
//  Created by Alif Rachmawan on 18/01/26.
//

import SwiftUI
import CachedAsyncImage

struct DetailView: View {
  @StateObject var presenter: DetailPresenter
  @State private var showSafari = false
  
  var body: some View {
    ScrollView(.vertical) {
      VStack(alignment: .leading, spacing: 20) {
        thumbnailImage
        contentView
      }
    }
    .navigationTitle("Detail")
    .navigationBarTitleDisplayMode(.inline)
    .toolbar(.hidden, for: .tabBar)
    .toolbar {
      Button {
        presenter.toggleFavorite()
      } label: {
        Image(systemName: presenter.isFavorite ? "heart.fill" : "heart")
          .foregroundStyle(.red)
      }
    }
    .sheet(isPresented: $showSafari) {
      if let url = URL(string: presenter.game.url) {
        SafariView(url: url)
          .ignoresSafeArea()
      }
    }
  }
  
  var thumbnailImage: some View {
    CachedAsyncImage(url: URL(string: presenter.game.thumbnail)) { image in
      image
        .resizable()
        .aspectRatio(contentMode: .fill)
        .frame(maxWidth: UIScreen.main.bounds.width)
    } placeholder: {
      ProgressView()
    }
    .frame(height: 300)
    .clipped()
  }
  
  var contentView: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text(presenter.game.title)
        .font(.largeTitle)
        .bold()
      
      // Platforms
      FlowLayout(spacing: 8) {
        ForEach(presenter.game.platforms, id: \.self) { platform in
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
      
      Text(presenter.game.description)
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
