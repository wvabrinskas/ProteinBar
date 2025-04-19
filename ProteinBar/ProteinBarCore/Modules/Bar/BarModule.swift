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
    sharedStorageProvider.setDataObject(key: .trackingValues, data: viewModel.values)
  }
  
  public func reset() {
    viewModel.values = .empty()
    sharedStorageProvider.setDataObject(key: .trackingValues, data: TrackingValues.empty())
  }
  
  public func remove(id: String) {
    guard let name = TrackingName(rawValue: id) else { return }
    
    let filteredCurrent = viewModel.values.values.filter { $0.name != name }
    viewModel.values = .init(values: filteredCurrent)
    save()
  }
  
  // MARK: Private
  
  @MainActor
  private func setupViewModel() {
    guard let currentTrackingValues: TrackingValues = sharedStorageProvider.getDataObject(key: .trackingValues) else {
      viewModel = .init(values: TrackingValues.empty())
      return
    }
    
    viewModel = .init(values: currentTrackingValues)
  }
}

