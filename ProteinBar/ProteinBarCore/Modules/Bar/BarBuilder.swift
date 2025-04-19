//
//  
//  BarBuilder.swift
//  ProteinBar
//
//  Created by William Vabrinskas on 4/16/25.
//
//

import Foundation
import HuddleArch
import HuddleMacros

public protocol BarBuilding: ViewBuilding, ModuleBuilder {}

@Building(BarRouter.self, BarViewComponentImpl.self)
public struct BarBuilder: BarBuilding {
  public static func build(parentComponent: Component, holder: ModuleHolding?, context: RootModuleHolderContext) -> BarModule {
      let component = BarModuleComponentImpl(parent: parentComponent)
      let module = BarModule(holder: holder, context: context, component: component)

      let viewComponent = BarViewComponentImpl(module: module, moduleHolder: holder)
      module.router = buildRouter(component: viewComponent)
      
      return module
  }
}

