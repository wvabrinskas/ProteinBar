//
//  ExtensionsEnvironment.swift
//  ProteinBar
//
//  Created by William Vabrinskas on 5/2/25.
//

import Foundation
import SwiftUI

struct ThemeKey: EnvironmentKey {
  static let defaultValue = LaunchTheme()
}

extension EnvironmentValues {
  var theme: LaunchTheme {
    get { self[ThemeKey.self] }
    set { self[ThemeKey.self] = newValue }
  }
}

