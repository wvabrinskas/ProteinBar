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
    let newValues = TrackingValues(values: viewModel.values)
    sharedStorageProvider.setDataObject(key: .trackingValues, data: newValues)
  }
  
  // MARK: Private
  
  @MainActor
  private func setupViewModel() {
    let availableTrackingNames: [TrackingName] = TrackingName.allCases
    
    let viewModels = availableTrackingNames.map {
      TrackingValue(name: $0, value: 0, maxValue: $0.defaultMaxValue)
    }
    
    viewModel = .init(values: viewModels)
  }
}
