//
//  RootRouter.swift
//  ProteinBar
//
//  Created by William Vabrinskas on 4/16/25.
//


import Foundation
import SwiftUI
import HuddleArch

public protocol RootViewComponent: ViewComponent {
  var rootModule: RootModule { get }
}

public struct RootViewComponentImpl: RootViewComponent {
  public var rootModule: RootModule
  public var moduleHolder: (any ModuleHolding)?
}

@MainActor
public protocol RootRouting: Router {
}

@MainActor
public final class RootRouter: Router, RootRouting {
  private let rootModule: RootModule
  private var moduleHolder: RootModuleHolder?
  
  public init(component: RootViewComponent) {
    self.moduleHolder = component.moduleHolder as? RootModuleHolder
    self.rootModule = component.rootModule
    
    super.init()
  }
  
  public override func rootView() -> any View {
    return RootView(module: rootModule,
                    router: self)
  }
}
