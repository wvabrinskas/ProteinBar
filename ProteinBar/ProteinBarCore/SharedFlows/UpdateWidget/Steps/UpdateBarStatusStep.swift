//
//  Update.swift
//  ProteinBar
//
//  Created by William Vabrinskas on 5/2/25.
//

import HuddleArch
import HuddleMacros
import UIKit

public protocol UpdateBarStatusStepComponent: FlowStepComponent {
  var sharedStorageProvider: UserStorageProvider<SharedStorageKeys> { get }
}

@ComponentImpl
public final class UpdateBarStatusStepComponentImpl: Component, UpdateBarStatusStepComponent {
  public let sharedStorageProvider: UserStorageProvider<SharedStorageKeys>
}


public class UpdateBarStatusStep: FlowStep<UpdateWidgetFlowContext, UpdateWidgetFlowComponentImpl, WidgetUpdaterPayload> {
  private let sharedStorageProvider: UserStorageProvider<SharedStorageKeys>

  public override init<T>(flow: Flow<UpdateWidgetFlowContext, UpdateWidgetFlowComponentImpl, WidgetUpdaterPayload>, context: UpdateWidgetFlowContext, component: T) where T : FlowStepComponent {
    sharedStorageProvider = component.sharedStorageProvider
    
    super.init(flow: flow, context: context, component: component)
  }
  
  public override func run() async {
    await super.run()
    onNext()
  }
  
  public override func run(flowResult: WidgetUpdaterPayload? = nil) async -> WidgetUpdaterPayload? {
    
    var newResult = flowResult
    
    if let currentTrackingValues: TrackingValues = sharedStorageProvider.getDataObject(key: .trackingValues) {
      newResult = newResult?.updating(.init(barStatusPayload: .init(trackingValues: currentTrackingValues)))
    }
    
    return await super.run(flowResult: newResult)
  }
}
