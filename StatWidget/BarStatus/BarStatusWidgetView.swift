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
  
  let entry: BarStatusTimelineEntry

  var body: some View {
    HStack {

    }
    .preferredColorScheme(.light)
    .fullscreen()
    .containerBackground(for: .widget) {
      modifier(ThemeBackgroundModifier(gradient: true))
    }
  }
}

struct LastPostWidgetViewPreviews: PreviewProvider {
  static var previews: some View {
    BarStatusWidgetView(entry: .mock)
      .previewContext(WidgetPreviewContext(family: .systemSmall))

  }
}
