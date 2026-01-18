//
//  AboutView.swift
//  FreeGames
//
//  Created by Alif Rachmawan on 18/01/26.
//

import SwiftUI

struct AboutView: View {
  @EnvironmentObject var presenter: AboutPresenter
  
  var body: some View {
    ScrollView(.vertical) {
      VStack(spacing: 24) {
        profileView
        featuresView
      }
    }
  }
  
  var profileView: some View {
    VStack(spacing: 16) {
      Image("photo")
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: 120, height: 120)
        .cornerRadius(60)
        .shadow(color: .blue.opacity(0.3), radius: 20, x: 0, y: 10)
      
      VStack(spacing: 4) {
        Text(presenter.name)
          .font(.title)
          .bold()
        
        Text(presenter.occupation)
          .font(.subheadline)
          .foregroundStyle(.secondary)
      }
    }
    .frame(maxWidth: .infinity)
    .padding(.vertical, 32)
    .background(
      LinearGradient(
        gradient: Gradient(colors: [.blue.opacity(0.6), .purple.opacity(0.6)]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
      )
    )
    .cornerRadius(20)
    .padding(.horizontal, 16)
  }
  
  var featuresView: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("Features")
        .font(.title2)
        .fontWeight(.bold)
      
      ForEach(presenter.features) { feature in
        FeatureRow(feature: feature)
      }
    }
    .padding()
    .frame(maxWidth: .infinity, alignment: .leading)
    .background(Color(.systemBackground))
    .cornerRadius(16)
    .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
    .padding(.horizontal)
  }
}

#Preview {
  AboutView()
}
