//
//  FlowLayout.swift
//  FreeGames
//
//  Created by Alif Rachmawan on 18/01/26.
//

import SwiftUI

struct FlowLayout: Layout {
  var spacing: CGFloat = 8
  
  func sizeThatFits(
    proposal: ProposedViewSize,
    subviews: Subviews,
    cache: inout ()
  ) -> CGSize {
    let maxWidth = proposal.width ?? 0
    var currentX: CGFloat = 0
    var totalHeight: CGFloat = 0
    var rowHeight: CGFloat = 0
    var maxRowWidth: CGFloat = 0
    
    for view in subviews {
      let size = view.sizeThatFits(.unspecified)
      if currentX + size.width > maxWidth && currentX > 0 {
        currentX = 0
        totalHeight += rowHeight + spacing
        rowHeight = 0
      }
      currentX += size.width + spacing
      rowHeight = max(rowHeight, size.height)
      maxRowWidth = max(maxRowWidth, currentX)
    }
    
    totalHeight += rowHeight
    return CGSize(width: min(maxRowWidth, maxWidth), height: totalHeight)
  }
  
  func placeSubviews(
    in bounds: CGRect,
    proposal: ProposedViewSize,
    subviews: Subviews,
    cache: inout ()
  ) {
    var minX = bounds.minX
    var minY = bounds.minY
    var rowHeight: CGFloat = 0
    
    for view in subviews {
      let size = view.sizeThatFits(.unspecified)
      if minX + size.width > bounds.maxX {
        minX = bounds.minX
        minY += rowHeight + spacing
        rowHeight = 0
      }
      
      view.place(
        at: CGPoint(x: minX, y: minY),
        proposal: ProposedViewSize(size)
      )
      
      minX += size.width + spacing
      rowHeight = max(rowHeight, size.height)
    }
  }
}
