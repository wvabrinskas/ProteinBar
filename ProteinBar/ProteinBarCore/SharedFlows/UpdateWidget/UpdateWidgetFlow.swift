//
//  UpdateWidgetFlow.swift
//  ProteinBar
//
//  Created by William Vabrinskas on 5/2/25.
//

import Foundation
import HuddleArch
import HuddleMacros

public protocol UpdateWidgetFlowSupporting: Flow<UpdateWidgetFlowContext, UpdateWidgetFlowComponentImpl, WidgetUpdaterPayload> {
}

public struct UpdateWidgetFlowContext {}

public protocol UpdateWidgetFlowComponent: Component {
  var sharedStorageProvider: UserStorageProvider<SharedStorageKeys> { get }
}

@ComponentImpl
public final class UpdateWidgetFlowComponentImpl: Component, UpdateWidgetFlowComponent {
  public let sharedStorageProvider: UserStorageProvider<SharedStorageKeys>
  public var updateBarStatusStepComponent: UpdateBarStatusStepComponentImpl {
    UpdateBarStatusStepComponentImpl(parent: self)
  }
}

public final class UpdateWidgetFlow: Flow<UpdateWidgetFlowContext, UpdateWidgetFlowComponentImpl, WidgetUpdaterPayload>,
                                     UpdateWidgetFlowSupporting {
  private let sharedStorageProvider: UserStorageProvider<SharedStorageKeys>
  
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
  
  override public init(context: UpdateWidgetFlowContext,
                       component: UpdateWidgetFlowComponentImpl,
                       result: (@Sendable () -> WidgetUpdaterPayload?)? = nil) {
    sharedStorageProvider = component.sharedStorageProvider
    
    super.init(context: context, component: component, result: result)
    
    self.steps = [
      UpdateBarStatusStep(flow: self, context: context, component: component.updateBarStatusStepComponent)
    ]
  }
}
