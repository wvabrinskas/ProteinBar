//
//  ModuleBuilder.swift
//  ProteinBar
//
//  Created by William Vabrinskas on 1/30/23.
//

import Foundation
import CoreData
import Combine
import SwiftUI
import HuddleArch
import HuddleMacros

public protocol RootModule {
  
}

public protocol RootComponent: Component {
}

@RootComponentImpl
public class RootComponentImpl: Component, RootComponent {
  public init() { super.init(parent: nil) }
}

public class RootModuleHolderContext: ModuleHolderContext {}


public class RootModuleHolder: ModuleHolder, RootModule, Module, @unchecked Sendable {
  public typealias ModuleComponent = RootComponentImpl
  public typealias Context = RootModuleHolderContext
  public typealias Router = RootRouter
    
  public var router: Router?
  
  private let component: RootComponent
  private let context: RootModuleHolderContext

  public required init(holder: ModuleHolding? = nil,
                       context: RootModuleHolderContext,
                       component: RootComponentImpl) {
    self.context = context
    self.component = component
    
    super.init(holder: holder)
  }
  
  public func onActive() {
    // no op
  }
  
}
