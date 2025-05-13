//
//  Theme.swift
//  ProteinBar
//
//  Created by William Vabrinskas on 4/16/25.
//

import Foundation
import UIKit
import SwiftUI

public enum Colors {
  case primaryAppColor
  case secondaryAppColor
  case primaryTextColor
  case secondaryTextColor
  case backgroundColorTop
  case backgroundColorBottom
  case shadowColor
  case fatColor
  case proteinColor
  case carbColor
  case fiberColor
  case waterColor
  case errorColor
  case successColor
  case buttonPrimary
  case caloriesColor
  
  
  var name: String {
    switch self {
    case .primaryAppColor:
      return "PrimaryAppColor"
    case .secondaryAppColor:
      return "SecondaryAppColor"
    case .primaryTextColor:
      return "PrimaryTextColor"
    case .secondaryTextColor:
      return "SecondaryTextColor"
    case .backgroundColorTop:
      return "BackgroundColorTop"
    case .backgroundColorBottom:
      return "BackgroundColorBottom"
    case .shadowColor:
      return "ShadowColor"
    case .fatColor:
      return "Fat"
    case .proteinColor:
      return "Protein"
    case .carbColor:
      return "Carb"
    case .fiberColor:
      return "Fiber"
    case .waterColor:
      return "Water"
    case .errorColor:
      return "ErrorColor"
    case .successColor:
      return "SuccessColor"
    case .buttonPrimary:
      return "ButtonPrimary"
    case .caloriesColor:
      return "CaloriesColor"
    }
  }
}

public protocol Theme {
  associatedtype A: Assets
  var assets: A { get }
  var primaryColor: Color { get }
  var secondaryColor: Color { get }
  var primaryTextColor: Color { get }
  var secondaryTextColor: Color { get }
  var backgroundColorTop: Color { get }
  var backgroundColorBottom: Color { get }
  var shadowColor: Color { get }
  var fatColor: Color { get }
  var proteinColor: Color { get }
  var carbColor: Color { get }
  var fiberColor: Color { get }
  var waterColor: Color { get }
  var caloriesColor: Color { get }
  var errorColor: Color { get }
  var successColor: Color { get }
  var buttonPrimary: Color { get }
  
  var springAnimation: Animation { get }
  func font(_ size: Double, weight: Font.Weight) -> Font
}

public extension Color {
  static func app(_ colors: Colors) -> Color {
    return Color(colors.name)
  }
}

struct LaunchTheme: Theme, Sendable {
  var assets = LaunchAssets()
  var primaryColor: Color { .app(.primaryAppColor) }
  var secondaryColor: Color { .app(.secondaryAppColor) }
  var primaryTextColor: Color { .app(.primaryTextColor) }
  var secondaryTextColor: Color { .app(.secondaryTextColor) }
  var backgroundColorTop: Color { .app(.backgroundColorTop) }
  var backgroundColorBottom: Color { .app(.backgroundColorBottom) }
  var shadowColor: Color { .app(.shadowColor) }
  var fatColor: Color { .app(.fatColor) }
  var proteinColor: Color { .app(.proteinColor) }
  var carbColor: Color { .app(.carbColor) }
  var fiberColor: Color { .app(.fiberColor) }
  var waterColor: Color { .app(.waterColor) }
  var errorColor: Color { .app(.errorColor) }
  var successColor: Color { .app(.successColor) }
  var buttonPrimary: Color { .app(.buttonPrimary) }
  var caloriesColor: Color { .app(.caloriesColor) }
  
  var springAnimation: Animation =
    .spring(response: 0.5,
            dampingFraction: 0.7,
            blendDuration: 1)

  func font(_ size: Double, weight: Font.Weight) -> Font {
    Font.system(size: size, weight: weight, design: .rounded)
  }
}
