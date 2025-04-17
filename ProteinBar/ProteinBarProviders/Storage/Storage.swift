
//
//  SharedStorageKeys.swift
//  ProteinBar
//
//  Created by William Vabrinskas on 4/16/25.
//

public enum SharedStorageKeys: String, StorageKeying {
  case trackingValues
  
  public func defaultValue<T: Eraseable>() -> T? {
    switch self {
    case .trackingValues:
      return TrackingValues() as? T
    }
  }
}


struct TrackingValues: Codable {
  var values: [TrackingValue] = []
}

struct TrackingValue: Codable {
  var name: String
  var value: Int
  var maxValue: Int
}
