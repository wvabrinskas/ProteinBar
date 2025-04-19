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
}

public final class SettingsModule: ModuleObject<RootModuleHolderContext, SettingsModuleComponentImpl,  SettingsRouter>, SettingsSupporting {
  private let sharedStorageProvider: UserStorageProvider<SharedStorageKeys>
  
  public var viewModel: SettingsViewModel = SettingsViewModel()

  public required init(holder: ModuleHolding?, context: Context, component: SettingsModuleComponentImpl) {
    self.sharedStorageProvider = component.sharedStorageProvider
    
    super.init(holder: holder, context: context, component: component)
    
    buildViewModel()
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
