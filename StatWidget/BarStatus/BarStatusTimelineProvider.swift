//
//  BarStatusTimelineProvider.swift
//  ProteinBar
//
//  Created by William Vabrinskas on 5/2/25.
//

import Foundation
import WidgetKit

public struct BarStatusTimelineEntry: TimelineEntry, Sendable {
  public var date: Date
  public let trackingValues: TrackingValues
  
  public static let mock = BarStatusTimelineEntry(date: Date(),
                                                  trackingValues: .mock())
}

public struct BarStatusTimelineProvider: TimelineProvider {
  public typealias Entry = BarStatusTimelineEntry
  private let sharedUserDefaults = UserStorageProvider<ExtensionStorageKeys>(defaults: .init(suiteName: SharedAppGroups.widget.rawValue) ?? .standard)

  public func placeholder(in context: Context) -> BarStatusTimelineEntry {
    .mock
  }
  
  public func getSnapshot(in context: Context, completion: @escaping (BarStatusTimelineEntry) -> Void) {
    let entry: Entry
    
    if let trackingValues: TrackingValues = sharedUserDefaults.getDataObject(key: .trackingValues) {
      entry = .init(date: Date(), trackingValues: trackingValues)
    } else {
      entry = .mock
    }

    completion(entry)
  }
  
  public func getTimeline(in context: Context, completion: @escaping (Timeline<BarStatusTimelineEntry>) -> Void) {
    let trackingValues: TrackingValues = sharedUserDefaults.getDataObject(key: .trackingValues) ?? .empty()
    
    let currentDate = Date()
    let startOfDay = Calendar.current.startOfDay(for: currentDate)
    let endOfDay = Calendar.current.date(byAdding: .hour, value: 1, to: startOfDay) ?? Date()
    
    let entry: Entry = .init(date: startOfDay, trackingValues: trackingValues)
    let timeline = Timeline(entries: [entry], policy: .after(endOfDay))
    
    completion(timeline)
  }
}
