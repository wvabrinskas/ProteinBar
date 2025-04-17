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

    }
  }
}

public protocol Theme {
  var primaryColor: Color { get }
  var secondaryColor: Color { get }
  var primaryTextColor: Color { get }
  var secondaryTextColor: Color { get }
  var backgroundColorTop: Color { get }
  var backgroundColorBottom: Color { get }
}

public extension Color {
  static func app(_ colors: Colors) -> Color {
    return Color(colors.name)
  }
}

struct LaunchTheme: Theme, Sendable {
  var primaryColor: Color { .app(.primaryAppColor) }
  var secondaryColor: Color { .app(.secondaryAppColor) }
  var primaryTextColor: Color { .app(.primaryTextColor) }
  var secondaryTextColor: Color { .app(.secondaryTextColor) }
  var backgroundColorTop: Color { .app(.backgroundColorTop) }
  var backgroundColorBottom: Color { .app(.backgroundColorBottom) }
}
