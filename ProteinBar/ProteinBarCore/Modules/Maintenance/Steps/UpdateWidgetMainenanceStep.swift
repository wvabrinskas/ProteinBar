//
//  UpdateWidgetMainenanceStep.swift
//  ProteinBar
//
//  Created by William Vabrinskas on 5/2/25.
//

import Foundation
import HuddleArch
import HuddleMacros
import UIKit
import WidgetKit

public protocol UpdateWidgetMaintenanceStepComponent: FlowStepComponent {
  var extensionStorageProvider: UserStorageProvider<ExtensionStorageKeys> { get }
  var widgetUpdater: WidgetUpdating { get }
}

@ComponentImpl
public final class UpdateWidgetMaintenanceStepComponentImpl: Component, UpdateWidgetMaintenanceStepComponent {
  public let extensionStorageProvider: UserStorageProvider<ExtensionStorageKeys>
  public let widgetUpdater: WidgetUpdating
  
  public var updateWidgetFlowComponent: UpdateWidgetFlowComponentImpl {
    UpdateWidgetFlowComponentImpl(parent: self)
  }
}

public final class UpdateWidgetMaintenanceStep: FlowStep<MaintenanceFlowContext, MaintenanceModuleComponentImpl, EmptyResult> {
  let extensionStorageProvider: UserStorageProvider<ExtensionStorageKeys>
  let updateWidgetFlowComponent: UpdateWidgetFlowComponentImpl
  let widgetUpdater: WidgetUpdating

  public override init<FComponent: FlowStepComponent>(flow: Flow<MaintenanceFlowContext, MaintenanceModuleComponentImpl, EmptyResult>,
                                                      context: MaintenanceFlowContext,
                                                      component: FComponent) {
    extensionStorageProvider = component.extensionStorageProvider
    updateWidgetFlowComponent = component.updateWidgetFlowComponent
    widgetUpdater = component.widgetUpdater
    super.init(flow: flow, context: context, component: component)
  }

  public override func isApplicable(context: FlowContext) -> Bool {
    context.isPreviews == false
  }

  public override func run() async {
    let updateWidgetStepContext = UpdateWidgetFlowContext()
    
    let updateFlow = UpdateWidgetFlow(context: updateWidgetStepContext,
                                      component: updateWidgetFlowComponent) {
      .init()
    }
    
    
    let result = await updateFlow.runResult()
    
    if let result {
      widgetUpdater.update(with: result)
    } else {
      print("error updating widget")
    }

    await super.run()
    onNext()
  }
}
