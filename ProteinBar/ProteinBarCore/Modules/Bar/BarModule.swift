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
}

@ComponentImpl
public class BarModuleComponentImpl: Component, BarModuleComponent {
  public var sharedStorageProvider: UserStorageProvider<SharedStorageKeys>
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

public final class BarModule: ModuleObject<RootModuleHolderContext, BarModuleComponentImpl,  BarRouter>, BarSupporting {
  private let sharedStorageProvider: UserStorageProvider<SharedStorageKeys>
  
  public var viewModel: BarViewModel = BarViewModel()

  public required init(holder: ModuleHolding?, context: Context, component: BarModuleComponentImpl) {
    self.sharedStorageProvider = component.sharedStorageProvider
    
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
  
  private func saveValues(_ newValues: [TrackingValue]) {
    sharedStorageProvider.setDataObject(key: .trackingValues, data: TrackingValues(values: newValues))
  }
  
  private func updateViewModel(with newValues: [TrackingValue]) {
    viewModel.values = newValues
  }
  
  @MainActor
  private func setupViewModel() {
    guard let currentTrackingValues: TrackingValues = sharedStorageProvider.getDataObject(key: .trackingValues) else {
      viewModel = .init(values: TrackingValues.empty().values)
      return
    }
    
    updateViewModel(with: currentTrackingValues.values)
  }
}

