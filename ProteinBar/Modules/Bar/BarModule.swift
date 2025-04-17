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
  public var viewModel: BarViewModel = BarViewModel()

  public required init(holder: ModuleHolding?, context: Context, component: BarModuleComponentImpl) {
    super.init(holder: holder, context: context, component: component)
  }
}
