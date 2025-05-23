
//
//  SharedStorageKeys.swift
//  ProteinBar
//
//  Created by William Vabrinskas on 4/16/25.
//

import Foundation

public enum SharedAppGroups: String {
  case widget = "group.wvabrinskas.proteinbar"
}

public enum SharedStorageKeys: String, StorageKeying {
  case trackingValues
  
  public func defaultValue<T: Eraseable>() -> T? {
    switch self {
    case .trackingValues:
      return TrackingValues.empty() as? T
    }
  }
}

public enum ExtensionStorageKeys: String, StorageKeying {
  case trackingValues
  
  public func defaultValue<T: Eraseable>() -> T? {
    switch self {
    case .trackingValues:
      return TrackingValues.empty() as? T
    }
  }
}
