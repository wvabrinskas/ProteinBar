//
//  
//  SettingsModule.swift
//  ProteinBar
//
//  Created by William Vabrinskas on 4/18/25.
//
//

import Foundation
import HuddleArch
import HuddleMacros
import NumSwift

public protocol SettingsModuleComponent: Component {
  var sharedStorageProvider: UserStorageProvider<SharedStorageKeys> { get }
}

@ComponentImpl
public class SettingsModuleComponentImpl: Component, SettingsModuleComponent {
  public var sharedStorageProvider: UserStorageProvider<SharedStorageKeys>
}

public protocol SettingsSupporting {
  var viewModel: SettingsViewModel { get }
  @MainActor
  func isTrackerSelected(name: TrackingName?) -> Bool
  @MainActor
  func onSelected(selected: Bool, name: TrackingName)
  @MainActor
  func onAppear()
  @MainActor
  func setMaxValue(maxValue: Int, name: TrackingName) 
}

public final class SettingsModule: ModuleObject<RootModuleHolderContext, SettingsModuleComponentImpl,  SettingsRouter>, SettingsSupporting {
  private let sharedStorageProvider: UserStorageProvider<SharedStorageKeys>
  
  public var viewModel: SettingsViewModel = SettingsViewModel()

  public required init(holder: ModuleHolding?, context: Context, component: SettingsModuleComponentImpl) {
    self.sharedStorageProvider = component.sharedStorageProvider
    
    super.init(holder: holder, context: context, component: component)
    
    buildViewModel()
  }
  
  // TODO: A way to update the max value
  
  @MainActor
  public func onAppear() {
    buildViewModel()
  }
  
  @MainActor
  public func setMaxValue(maxValue: Int, name: TrackingName) {
    guard let barModule: BarSupporting = holder?.module() else { return }
    barModule.setMaxValue(maxValue: maxValue, name: name)
    
    buildViewModel()
  }
  
  @MainActor
  public func onSelected(selected: Bool, name: TrackingName) {
    guard let barModule: BarSupporting = holder?.module() else { return }
    barModule.setVisible(visible: selected, name: name)
  }
  
  @MainActor
  public func isTrackerSelected(name: TrackingName?) -> Bool {
    guard let barModule: BarSupporting = holder?.module() else { return false }
    
    return barModule.isTrackerSelected(name: name)
  }
  
  
  // MARK: - Private

  private func buildViewModel() {
    let currentTrackingValues: TrackingValues = sharedStorageProvider.getDataObject(key: .trackingValues) ?? .empty()
    
    let numberOfRows = Int(ceil(Float(currentTrackingValues.values.count) / Float(viewModel.numberOfColumns)))
            
    var values: [[TrackingValue]] = []
    
    for r in 0..<numberOfRows {
      var columnValues : [TrackingValue] = []
      for c in 0..<viewModel.numberOfColumns {
        //(row * length_of_row) + column;
        let index = (r * viewModel.numberOfColumns) + c
        
        if let v = currentTrackingValues.values[safe: index] {
          columnValues.append(v)
        }
      }
      values.append(columnValues)
    }
    
    viewModel.trackingValues = values
    
  }
}
