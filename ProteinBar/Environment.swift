//
//  Environment.swift
//  ProteinBar
//
//  Created by William Vabrinskas on 4/16/25.
//

import Foundation
import CoreData
import Combine
import SwiftUI
import HuddleArch

struct EnvironmentProperties {
  static var isRunningUnitTests: Bool {
    NSClassFromString("XCTest") != nil
  }
}

struct ThemeKey: EnvironmentKey {
  static let defaultValue = LaunchTheme()
}

struct StateKey: @preconcurrency EnvironmentKey {
  @MainActor static let defaultValue: RootModuleHolder = RootBuilder.build(parentComponent: EmptyComponent(),
                                                                           holder: nil,
                                                                           context: .init())
}

public final class WindowStore {
  public var windowSize: CGSize = .zero
}

extension EnvironmentValues {
  var rootModule: RootModuleHolder {
    get { self[StateKey.self] }
    set { self[StateKey.self] = newValue }
  }
  
  var theme: LaunchTheme {
    get { self[ThemeKey.self] }
    set { self[ThemeKey.self] = newValue }
  }
}

