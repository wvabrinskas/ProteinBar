//
//  
//  SettingsBuilder.swift
//  ProteinBar
//
//  Created by William Vabrinskas on 4/18/25.
//
//

import Foundation
import HuddleArch
import HuddleMacros

public protocol SettingsBuilding: ViewBuilding, ModuleBuilder {}

@Building(SettingsRouter.self, SettingsViewComponentImpl.self)
public struct SettingsBuilder: SettingsBuilding {
  public static func build(parentComponent: Component, holder: ModuleHolding?, context: RootModuleHolderContext) -> SettingsModule {
      let component = SettingsModuleComponentImpl(parent: parentComponent)
      let module = SettingsModule(holder: holder, context: context, component: component)

      let viewComponent = SettingsViewComponentImpl(module: module, moduleHolder: holder)
      module.router = buildRouter(component: viewComponent)
      
      return module
  }
}

