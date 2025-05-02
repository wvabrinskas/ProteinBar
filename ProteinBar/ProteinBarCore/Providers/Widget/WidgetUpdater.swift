//
//  WidgetUpdater.swift
//  Huddle
//
//  Created by William Vabrinskas on 6/17/24.
//

import WidgetKit
import HuddleArch

public struct WidgetUpdaterPayload: FlowResult {
  let barStatusPayload: WidgetBarStatusPayload?
  
  init(barStatusPayload: WidgetBarStatusPayload?) {
    self.barStatusPayload = barStatusPayload
  }
  
  public func updating(_ with: WidgetUpdaterPayload) -> WidgetUpdaterPayload {
    .init(barStatusPayload: with.barStatusPayload ?? self.barStatusPayload)
  }
}

public protocol WidgetUpdating {
  func update(with payload: WidgetUpdaterPayload)
}

public final class WidgetUpdater: WidgetUpdating {
  private let extensionStorageProvider: UserStorageProvider<ExtensionStorageKeys>
  
  public init(extensionStorageProvider: UserStorageProvider<ExtensionStorageKeys>) {
    self.extensionStorageProvider = extensionStorageProvider
  }
  
  public func update(with payload: WidgetUpdaterPayload) {
    if let barStatusPayload = payload.barStatusPayload {
      extensionStorageProvider.setDataObject(key: .trackingValues, data: barStatusPayload)
    }
    
    WidgetCenter.shared.reloadAllTimelines()
  }
}
