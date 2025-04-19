//
//  
//  BarRouter.swift
//  ProteinBar
//
//  Created by William Vabrinskas on 4/16/25.
//
//

import Foundation
import SwiftUI
import Logger
import HuddleArch

public protocol BarViewComponent: ViewComponent {
  var module: BarSupporting { get }
}

public struct BarViewComponentImpl: BarViewComponent {
  public var module: BarSupporting
  public var moduleHolder: ModuleHolding?
}

@MainActor
public protocol BarRouting: Router {
  func routeToSettingsView() -> any View
}

@MainActor
public class BarRouter: Router, BarRouting, @preconcurrency Logger {
  public var logLevel: LogLevel = .high
  private let moduleHolder: RootModuleHolder?
  private let component: BarViewComponent
  
  public init(component: BarViewComponent) {
    self.component = component
    self.moduleHolder = component.moduleHolder as? RootModuleHolder

    super.init()

    if moduleHolder == nil {
      log(type: .message, message: "No valid ModuleHolder to be found in \(#file)")
    }
  }
  
  public override func rootView() -> any View {
    BarView(router: self,
            module: component.module,
            moduleHolder: component.moduleHolder,
            viewModel: component.module.viewModel)
  }
  
  public func routeToSettingsView() -> any View {
    guard let settingsRouter: SettingsRouting = moduleHolder?.router(for: SettingsSupporting.self) else {
      fatalError()
    }
    
    return settingsRouter.rootView()
  }
}
