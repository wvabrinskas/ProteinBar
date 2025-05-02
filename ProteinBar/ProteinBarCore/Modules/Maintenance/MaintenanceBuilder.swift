//
//  
//  MaintenanceBuilder.swift
//  ProteinBar
//
//  Created by William Vabrinskas on 5/2/25.
//
//

import Foundation
import HuddleArch
import HuddleMacros

public protocol MaintenanceBuilding: ViewBuilding, ModuleBuilder {}

@Building(MaintenanceRouter.self, MaintenanceViewComponentImpl.self)
public struct MaintenanceBuilder: MaintenanceBuilding {
  public static func build(parentComponent: Component, holder: ModuleHolding?, context: RootModuleHolderContext) -> MaintenanceModule {
      let component = MaintenanceModuleComponentImpl(parent: parentComponent)
      let module = MaintenanceModule(holder: holder, context: context, component: component)

      let viewComponent = MaintenanceViewComponentImpl(module: module, moduleHolder: holder)
      module.router = buildRouter(component: viewComponent)
      
      return module
  }
}