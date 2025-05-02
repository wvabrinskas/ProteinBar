//
//  
//  MaintenanceRouter.swift
//  ProteinBar
//
//  Created by William Vabrinskas on 5/2/25.
//
//

import Foundation
import SwiftUI
import HuddleArch

public protocol MaintenanceViewComponent: ViewComponent {
  var module: MaintenanceSupporting { get }
}

public struct MaintenanceViewComponentImpl: MaintenanceViewComponent {
  public var module: MaintenanceSupporting
  public var moduleHolder: ModuleHolding?
}

@MainActor
public protocol MaintenanceRouting: Router {}

@MainActor
public class MaintenanceRouter: Router, MaintenanceRouting {
  private let moduleHolder: RootModuleHolder?
  private let component: MaintenanceViewComponent
  
  public init(component: MaintenanceViewComponent) {
    self.component = component
    self.moduleHolder = component.moduleHolder as? RootModuleHolder
    
    super.init()
  }
  
  public override func rootView() -> any View {
    MaintenanceView(router: self, 
                       module: component.module, 
                       moduleHolder: component.moduleHolder, 
                       viewModel: component.module.viewModel)
  }
}