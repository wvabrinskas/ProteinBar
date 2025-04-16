
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
  var maxProtein: Int
  var maxWater: Int
  var currentProtein: Int
  var currentWater: Int
  
  init(maxProtein: Int = 100,
       maxWater: Int = 100,
       currentProtein: Int = 0,
       currentWater: Int = 0) {
    self.maxProtein = maxProtein
    self.maxWater = maxWater
    self.currentProtein = currentProtein
    self.currentWater = currentWater
  }
}

