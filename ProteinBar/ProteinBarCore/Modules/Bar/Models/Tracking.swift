//
//  Tracking.swift
//  ProteinBar
//
//  Created by William Vabrinskas on 4/18/25.
//

import Foundation
import SwiftUI

public enum TrackingName: String, Codable, CaseIterable, Sendable {
  case calories,
       water,
       protein,
       carbohydrates,
       fiber,
       fat
  
  static var maxMaxValue: Int {
    return 9999
  }
  
  func barColor(theme: any Theme) -> Color {
    switch self {
    case .calories:
      return theme.caloriesColor
    case .water:
      return theme.waterColor
    case .protein:
      return theme.proteinColor
    case .carbohydrates:
      return theme.carbColor
    case .fat:
      return theme.fatColor
    case .fiber:
      return theme.fiberColor
    }
  }
  
  var shortName: String {
    switch self {
    case .carbohydrates:
      return "Carbs"
    default:
      return rawValue
    }
  }
  
  var icon: Image {
    switch self {
    case .calories:
      return Image(systemName: "flame.fill")
    case .water:
      return Image(systemName: "drop.fill")
    case .protein:
      return Image(systemName: "dumbbell.fill")
    case .carbohydrates:
      return Image(systemName: "laurel.leading")
    case .fat:
      return Image(systemName: "heart.fill")
    case .fiber:
      return Image(systemName: "carrot.fill")
    }
  }
  
  var defaultMaxValue: Int {
    switch self {
    case .calories:
      return 2000
    case .water:
      return 1000
    case .protein:
      return 100
    case .carbohydrates:
      return 300
    case .fat:
      return 50
    case .fiber:
      return 35
    }
  }
  
  var unit: String {
    switch self {
    case .calories:
      return "kcal"
    case .water:
      return "ml"
    case .protein:
      return "g"
    case .carbohydrates:
      return "g"
    case .fat:
      return "g"
    case .fiber:
      return "g"
    }
  }

}

public struct TrackingValues: Codable, Equatable, Sendable {
  
  var values: [TrackingValue] = []
  
  static func empty() -> Self {
    let availableTrackingNames: [TrackingName] = TrackingName.allCases
    
    let viewModels = availableTrackingNames.map {
      TrackingValue(name: $0, value: 0, maxValue: $0.defaultMaxValue)
    }
    
    return .init(values: viewModels)
  }
  
  static func mock() -> Self {
    let availableTrackingNames: [TrackingName] = TrackingName.allCases
    
    let viewModels = availableTrackingNames.map {
      TrackingValue(name: $0, value: .random(in: 10...$0.defaultMaxValue), maxValue: $0.defaultMaxValue)
    }
    
    return .init(values: viewModels)
  }
}

public struct TrackingValue: Codable, Identifiable, Equatable, Sendable {
  public var id: String {
    name.rawValue + "_\(value)"
  }
  
  var name: TrackingName
  var value: Int
  var maxValue: Int
  var visible: Bool = true
  
  func updating(value: Int? = nil, maxValue: Int? = nil, visible: Bool? = nil) -> TrackingValue {
    .init(name: name,
          value: value ?? self.value,
          maxValue: maxValue ?? self.maxValue,
          visible: visible ?? self.visible)
  }
}
