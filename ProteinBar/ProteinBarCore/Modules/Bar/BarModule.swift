//
//  
//  BarModule.swift
//  ProteinBar
//
//  Created by William Vabrinskas on 4/16/25.
//
//

import Foundation
import HuddleArch
import HuddleMacros

public protocol BarModuleComponent: Component {
  var sharedStorageProvider: UserStorageProvider<SharedStorageKeys> { get }
  var widgetUpdater: WidgetUpdating { get }
}

@ComponentImpl
public class BarModuleComponentImpl: Component, BarModuleComponent {
  public var sharedStorageProvider: UserStorageProvider<SharedStorageKeys>
  public let widgetUpdater: WidgetUpdating
  
  public var updateWidgetFlowComponent: UpdateWidgetFlowComponentImpl {
    UpdateWidgetFlowComponentImpl(parent: self)
  }
}

public protocol BarSupporting {
  var viewModel: BarViewModel { get }
  func save()
  func reset()
  @MainActor
  func setVisible(visible: Bool, name: TrackingName)
  @MainActor
  func isTrackerSelected(name: TrackingName?) -> Bool
  @MainActor
  func setMaxValue(maxValue: Int, name: TrackingName)
}

public final class BarModule: ModuleObject<RootModuleHolderContext, BarModuleComponentImpl,  BarRouter>, BarSupporting, @unchecked Sendable {
  private let sharedStorageProvider: UserStorageProvider<SharedStorageKeys>
  private let updateWidgetFlowComponent: UpdateWidgetFlowComponentImpl
  private let widgetUpdater: WidgetUpdating
  
  private var updateWidgetTask: Task<Void, Never>?
  
  public var viewModel: BarViewModel = BarViewModel()
  

  public required init(holder: ModuleHolding?, context: Context, component: BarModuleComponentImpl) {
    self.sharedStorageProvider = component.sharedStorageProvider
    self.updateWidgetFlowComponent = component.updateWidgetFlowComponent
    self.widgetUpdater = component.widgetUpdater
    
    super.init(holder: holder, context: context, component: component)

    setupViewModel()
  }
  
  public func save() {
    saveValues(viewModel.values)
  }
  
  public func reset() {
    
    let newValues: [TrackingValue] = viewModel.values.map { $0.updating(value: 0) }
    
    viewModel.values = newValues
    sharedStorageProvider.setDataObject(key: .trackingValues, data: TrackingValues(values: newValues))
    
    startUpdateWidgetTask()
  }
  
  @MainActor
  public func isTrackerSelected(name: TrackingName?) -> Bool {
    viewModel.values.first(where: { $0.name == name })?.visible ?? false
  }
  
  @MainActor
  public func setMaxValue(maxValue: Int, name: TrackingName) {
    var currentValues: [TrackingValue] = viewModel.values
    
    guard let indexOfValueToUpdate = currentValues.firstIndex(where: { $0.name == name }) else { return }
    
    let currentValue = currentValues[indexOfValueToUpdate].value
    
    currentValues[indexOfValueToUpdate] = currentValues[indexOfValueToUpdate].updating(value: min(currentValue, maxValue),
                                                                                       maxValue: min(maxValue, TrackingName.maxMaxValue))
        
    saveValues(currentValues)

    updateViewModel(with: currentValues)
  }
  
  @MainActor
  public func setVisible(visible: Bool, name: TrackingName) {
    var currentValues: [TrackingValue] = viewModel.values
    
    guard let indexOfValueToUpdate = currentValues.firstIndex(where: { $0.name == name }) else { return }
    
    currentValues[indexOfValueToUpdate] = currentValues[indexOfValueToUpdate].updating(visible: visible)
        
    saveValues(currentValues)

    updateViewModel(with: currentValues)
  }
  
  // MARK: Private
  private func startUpdateWidgetTask() {
    updateWidgetTask?.cancel()
    
    updateWidgetTask = Task {
      guard Task.isCancelled == false else { return }
      
      await updateWidget()
    }
  }
  
  private func updateWidget() async {
    
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
  }
  
  private func saveValues(_ newValues: [TrackingValue]) {
    sharedStorageProvider.setDataObject(key: .trackingValues, data: TrackingValues(values: newValues))
    startUpdateWidgetTask()
  }
  
  private func updateViewModel(with newValues: [TrackingValue]) {
    viewModel.values = newValues
  }
  
  @MainActor
  private func setupViewModel() {
    guard var currentTrackingValues: TrackingValues = sharedStorageProvider.getDataObject(key: .trackingValues) else {
      viewModel = .init(values: TrackingValues.empty().values)
      return
    }
    
    let allCases = TrackingName.allCases
    
    var hadNewValues: Bool = false
    
    for i in 0..<allCases.count {
      let name = allCases[i]
      
      guard currentTrackingValues.values.contains(where: { $0.name == name }) == false else {
        continue
      }
      
      hadNewValues = true
      
      let newValue: TrackingValue = .init(name: name,
                                          value: 0,
                                          maxValue: name.defaultMaxValue,
                                          visible: true)
      
      if i < currentTrackingValues.values.count {
        currentTrackingValues.values.insert(newValue, at: i)
      } else {
        currentTrackingValues.values.append(newValue)
      }
    }
    
    if hadNewValues {
      sharedStorageProvider.setDataObject(key: .trackingValues,
                                          data: currentTrackingValues)
    }
    
    updateViewModel(with: currentTrackingValues.values)
  }
}

