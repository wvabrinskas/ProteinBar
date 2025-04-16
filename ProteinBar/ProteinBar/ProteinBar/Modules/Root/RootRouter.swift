//
//  
//  RootRouter.swift
//  ProteinBar
//
//  Created by William Vabrinskas on 4/16/25.
//
//

import Foundation
import SwiftUI
import HuddleArch

public protocol RootViewComponent: ViewComponent {
  var module: RootSupporting { get }
}

public struct RootViewComponentImpl: RootViewComponent {
  public var module: RootSupporting
  public var moduleHolder: (any ModuleHolding)?
}

@MainActor
public protocol RootRouting: Router {
}

@MainActor
public final class RootRouter: Router, RootRouting {
  private let module: RootSupporting
  private var moduleHolder: RootModuleHolder?
  
  public init(component: RootViewComponent) {
    self.moduleHolder = component.moduleHolder as? RootModuleHolder
    self.module = component.module
    
    super.init()
  }
  
  public override func rootView() -> any View {
    return RootView(module: module,
                    router: self,
                    viewModel: module.viewModel)
  }
}
