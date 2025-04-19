//
//  
//  SettingsRouter.swift
//  ProteinBar
//
//  Created by William Vabrinskas on 4/18/25.
//
//

import Foundation
import SwiftUI
import Logger
import HuddleArch

public protocol SettingsViewComponent: ViewComponent {
  var module: SettingsSupporting { get }
}

public struct SettingsViewComponentImpl: SettingsViewComponent {
  public var module: SettingsSupporting
  public var moduleHolder: ModuleHolding?
}

@MainActor
public protocol SettingsRouting: Router {}

@MainActor
public class SettingsRouter: Router, SettingsRouting, @preconcurrency Logger {
  public var logLevel: LogLevel = .high
  private let moduleHolder: RootModuleHolder?
  private let component: SettingsViewComponent
  
  public init(component: SettingsViewComponent) {
    self.component = component
    self.moduleHolder = component.moduleHolder as? RootModuleHolder

    super.init()

    if moduleHolder == nil {
      log(type: .message, message: "No valid ModuleHolder to be found in \(#file)")
    }
  }
  
  public override func rootView() -> any View {
    SettingsView(router: self, module: component.module, moduleHolder: component.moduleHolder, viewModel: component.module.viewModel)
  }
}
