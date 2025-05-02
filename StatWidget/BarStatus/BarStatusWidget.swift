//
//  BarStatusWidget.swift
//  ProteinBar
//
//  Created by William Vabrinskas on 5/2/25.
//

import Foundation
import SwiftUI
import WidgetKit

struct BarStatusWidget: Widget {
  var body: some WidgetConfiguration {
    StaticConfiguration(kind: "com.wvabrinskas.proteinbar.bar-status-widget",
                        provider: BarStatusTimelineProvider()) { entry in
      BarStatusWidgetView(entry: entry)
    }
    .contentMarginsDisabled()
    .configurationDisplayName("Tracking bar status")
    .description("Shows current progress of your macro tracking.")
    .supportedFamilies([
        .systemSmall
    ])
  }
}
