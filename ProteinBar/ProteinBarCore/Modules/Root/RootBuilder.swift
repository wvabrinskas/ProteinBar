//
//  
//  RootBuilder.swift
//  ProteinBar
//
//  Created by William Vabrinskas on 4/16/25.
//
//

import Foundation
import HuddleArch
import HuddleMacros

public protocol RootBuilding: ViewBuilding, ModuleBuilder {}

@Building(RootRouter.self, RootViewComponentImpl.self)
public struct RootBuilder: RootBuilding {
  public static func build(parentComponent: Component, holder: ModuleHolding?, context: RootModuleHolderContext) -> RootModuleHolder {
      let component = RootModuleComponentImpl()
      let module = RootModuleHolder(holder: nil, context: context, component: component)

      let viewComponent = RootViewComponentImpl(module: module, moduleHolder: holder)
      module.router = buildRouter(component: viewComponent)
      
      return module
  }
}
