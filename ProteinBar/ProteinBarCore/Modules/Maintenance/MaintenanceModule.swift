//
//  
//  MaintenanceModule.swift
//  ProteinBar
//
//  Created by William Vabrinskas on 5/2/25.
//
//

import Foundation
import HuddleArch
import HuddleMacros

public struct MaintenanceFlowContext {
  var isPreviews: Bool {
    ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] != nil
  }
}

public protocol MaintenanceModuleComponent: Component {
  // add dependencies here
  var updateWidgetMaintenanceStepComponent: UpdateWidgetMaintenanceStepComponentImpl { get }
}

@ComponentImpl
public class MaintenanceModuleComponentImpl: Component, MaintenanceModuleComponent {
  // implement dependencies here
  public var updateWidgetMaintenanceStepComponent: UpdateWidgetMaintenanceStepComponentImpl {
    UpdateWidgetMaintenanceStepComponentImpl(parent: self)
  }
}

public protocol MaintenanceSupporting: Flow<MaintenanceFlowContext, MaintenanceModuleComponentImpl, EmptyResult> {
  var viewModel: MaintenanceViewModel { get }
}

public final class MaintenanceModule: Flow<MaintenanceFlowContext, MaintenanceModuleComponentImpl, EmptyResult>,
                                    MaintenanceSupporting,
                                    Module {
  
  public weak var holder: ModuleHolding?
  public weak var router: MaintenanceRouter?
  public var viewModel: MaintenanceViewModel = MaintenanceViewModel()
  
  deinit {
    // remove steps as this can cause a memory leak
    steps = []
  }
  
  public func onActive() {
    // no op
  }
  
  public func onAppear() {
    // no op
  }
  
  @MainActor
  public override func runIsolated() async {
    await super.runIsolated()
  }
  
  public init(holder: ModuleHolding?, context: RootModuleHolderContext, component: MaintenanceModuleComponentImpl) {
    self.holder = holder
    
    let context = MaintenanceFlowContext()
    
    super.init(context: context, component: component)
    
    self.steps = [
      UpdateWidgetMaintenanceStep(flow: self, context: context, component: component.updateWidgetMaintenanceStepComponent)
    ]
  }
}
