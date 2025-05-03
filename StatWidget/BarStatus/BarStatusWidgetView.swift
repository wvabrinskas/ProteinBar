//
//  BarStatusWidgetView.swift
//  ProteinBar
//
//  Created by William Vabrinskas on 5/2/25.
//

import SwiftUI
import WidgetKit

struct BarStatusWidgetView: View {
  @Environment(\.theme) var theme
  
  private let cornerRadius: CGFloat = 6
  private let barHeight: CGFloat = 129
  
  let entry: BarStatusTimelineEntry

  var body: some View {
    ZStack {
      VStack {
        ProteinBarLabel(text: "Your Stats",
                        color: theme.primaryTextColor.opacity(0.5),
                        size: 18,
                        fontWeight: .bold)
        Spacer()
      }
      
      VStack { // Use VStack for vertical arrangement
        Spacer()
        HStack(alignment: .bottom, spacing: 0) {
          ForEach(0..<entry.trackingValues.values.count, id: \.self) { index in
              UnevenRoundedRectangle(cornerRadii: .init(topLeading: cornerRadius,
                                                        bottomLeading: 0,
                                                        bottomTrailing: 0,
                                                        topTrailing: cornerRadius))
              .fill(theme.backgroundColorBottom.opacity(0.1))
              .frame(height: barHeight)
              .overlay {
                let value = entry.trackingValues.values[index]
                
                UnevenRoundedRectangle(cornerRadii: .init(topLeading: cornerRadius,
                                                          bottomLeading: 0,
                                                          bottomTrailing: 0,
                                                          topTrailing: cornerRadius))
                .fill(value.name.barColor(theme: theme))
                .frame(height: height(for: value, frameHeight: barHeight))
                .align(.bottom)
              }
              .depth(foregroundColor: .clear, cornerRadius: cornerRadius)
          }
        }
      }
    }
    .fullscreen()
    .containerBackground(for: .widget) {
      modifier(ThemeBackgroundModifier(gradient: true))
    }
    .padding(.top, 8)
  }
  
  func height(for value: TrackingValue, frameHeight: CGFloat) -> CGFloat {
    let current = value.value
    let maxValue = value.maxValue
    let height: CGFloat = CGFloat(current) / CGFloat(maxValue)
    
    return max(15, height * frameHeight)
  }
}

struct LastPostWidgetViewPreviews: PreviewProvider {
  static var previews: some View {
    BarStatusWidgetView(entry: .mock)
      .previewContext(WidgetPreviewContext(family: .systemSmall))

  }
}
