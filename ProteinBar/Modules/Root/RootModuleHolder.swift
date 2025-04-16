//
//  
//  RootModuleHolder.swift
//  ProteinBar
//
//  Created by William Vabrinskas on 4/16/25.
//
//
import Foundation
import SwiftUI
import HuddleArch
import HuddleMacros

public protocol RootSupporting {
  var viewModel: RootViewModel { get }
}

public protocol RootComponent: Component {
  var sharedStorageProvider: UserStorageProvider<SharedStorageKeys> { get }
}

@RootComponentImpl
public class RootModuleComponentImpl: Component, RootComponent {
  public var sharedStorageProvider: UserStorageProvider<SharedStorageKeys> = .init(defaults: .standard)
  
  public init() { super.init(parent: nil) }
}

public class RootModuleHolderContext: ModuleHolderContext {}

public class RootModuleHolder: ModuleHolder, RootSupporting, Module, @unchecked Sendable {
  public typealias ModuleComponent = RootModuleComponentImpl
  public typealias Context = RootModuleHolderContext
  public typealias Router = RootRouter
    
  // we don't need weak here because the Router references the module through the Component and 
  // not the router directly, so there's no reference cycle.
  public var router: Router? 
  public var viewModel: RootViewModel = RootViewModel()
  
  private let component: RootComponent
  private let context: RootModuleHolderContext

  public required init(holder: ModuleHolding? = nil,
                       context: RootModuleHolderContext,
                       component: RootModuleComponentImpl) {
    self.context = context
    self.component = component
    
    super.init(holder: holder)

    supportedModules = [
      // add supported modules here
    ]
  }
  
  public func onActive() {
    // no op
  }
  
}
