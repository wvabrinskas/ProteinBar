//
//  Tracking.swift
//  ProteinBar
//
//  Created by William Vabrinskas on 4/18/25.
//

import Foundation
import SwiftUI

enum TrackingName: String, Codable, CaseIterable {
  case water, protein, carbohydrates, fiber, fat
  
  func barColor(theme: Theme) -> Color {
    switch self {
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
  
  var icon: Image {
    switch self {
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

struct TrackingValues: Codable, Equatable {
  var values: [TrackingValue] = []
  
  static func empty() -> Self {
    let availableTrackingNames: [TrackingName] = TrackingName.allCases
    
    let viewModels = availableTrackingNames.map {
      TrackingValue(name: $0, value: 0, maxValue: $0.defaultMaxValue)
    }
    
    return .init(values: viewModels)
  }
}

struct TrackingValue: Codable, Identifiable, Equatable {
  var id: String {
    name.rawValue + "_\(value)"
  }
  
  var name: TrackingName
  var value: Int
  var maxValue: Int
}
