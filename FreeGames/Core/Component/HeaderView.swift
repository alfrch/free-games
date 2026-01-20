//
//  HeaderView.swift
//  FreeGames
//
//  Created by Alif Rachmawan on 19/01/26.
//

import SwiftUI

struct HeaderView: View {
  let title: String
  var subtitle: String?
  
  var body: some View {
    VStack(alignment: .leading, spacing: 4) {
      Text(title)
        .font(.largeTitle)
        .fontWeight(.bold)
      
      if let subtitle = subtitle {
        Text(subtitle)
          .font(.subheadline)
          .foregroundStyle(.secondary)
      }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(.top, 8)
  }
}

#Preview {
  HeaderView(title: "Title", subtitle: "Subtitle")
}
