//
//  FeatureRow.swift
//  FreeGames
//
//  Created by Alif Rachmawan on 18/01/26.
//

import SwiftUI

struct FeatureRow: View {
  let feature: FeatureModel
  
  var body: some View {
    HStack(alignment: .top, spacing: 12) {
      Image(systemName: feature.icon)
        .font(.title3)
        .foregroundStyle(feature.color)
        .frame(width: 32, height: 32)
        .background(feature.color.opacity(0.1))
        .cornerRadius(8)
      
      VStack(alignment: .leading, spacing: 2) {
        Text(feature.title)
          .font(.headline)
        
        Text(feature.description)
          .font(.subheadline)
          .foregroundStyle(.secondary)
      }
    }
  }
}

#Preview {
  let feature = FeatureModel(
    id: "1234",
    icon: "star",
    color: .blue,
    title: "Title",
    description: "Description"
  )
  FeatureRow(feature: feature)
}
