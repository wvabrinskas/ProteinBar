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

public protocol RootSupporting: ModuleHolding {
  var viewModel: RootViewModel { get }
  @MainActor
  func routeToRootView() -> any View
  @MainActor
  func onAppear() async
}

public protocol RootComponent: Component {
  var sharedStorageProvider: UserStorageProvider<SharedStorageKeys> { get }
  var extensionStorageProvider: UserStorageProvider<ExtensionStorageKeys> { get }
  var widgetUpdater: WidgetUpdating { get }
}

@RootComponentImpl
public class RootModuleComponentImpl: Component, RootComponent {
  public var sharedStorageProvider: UserStorageProvider<SharedStorageKeys> = .init(defaults: .standard)
  public var extensionStorageProvider: UserStorageProvider<ExtensionStorageKeys> = .init(defaults: UserDefaults(suiteName: SharedAppGroups.widget.rawValue ) ?? .standard)
  
  public var widgetUpdater: WidgetUpdating {
    WidgetUpdater(extensionStorageProvider: extensionStorageProvider)
  }
  
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

  @MainActor
  public required init(holder: ModuleHolding? = nil,
                       context: RootModuleHolderContext,
                       component: RootModuleComponentImpl) {
    self.context = context
    self.component = component
    
    super.init(holder: holder)

    supportedModules = [
      BarBuilder.build(parentComponent: component, holder: self, context: context),
      SettingsBuilder.build(parentComponent: component, holder: self, context: context)
    ]
  }
  
  @MainActor
  public func onAppear() async {
    // no op
    let maintenanceModule = MaintenanceBuilder.build(parentComponent: component,
                                                     holder: self,
                                                     context: context)
    
    await maintenanceModule.runIsolated()
  }
  
  public func onActive() {
    // no op
  }

  @MainActor
  public func routeToRootView() -> any View {
    router?.rootView() ?? EmptyView()
  }
}
