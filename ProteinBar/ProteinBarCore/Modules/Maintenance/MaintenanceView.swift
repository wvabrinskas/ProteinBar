//
//  
//  MaintenanceView.swift
//  ProteinBar
//
//  Created by William Vabrinskas on 5/2/25.
//
//

import Foundation
import SwiftUI
import HuddleArch

public struct MaintenanceView: View {
  
  @Environment(\.theme) var theme
  let router: MaintenanceRouting
  var module: any MaintenanceSupporting
  var moduleHolder: ModuleHolding?
  
  @State var viewModel: MaintenanceViewModel

  public var body: some View {
    VStack {
      Text("Some Text")
    }
    .applyThemeBackground()
  }
}

struct MaintenanceView_Previews: PreviewProvider {
  static let context = RootModuleHolderContext()
  static let rootComponent = RootModuleComponentImpl()
  static let moduleHolder = RootModuleHolder(context: context, component: rootComponent)

  static let module = MaintenanceBuilder.build(parentComponent: rootComponent, holder: moduleHolder, context: context)

  static var previews: some View {
    module.router!.rootView()
      .preview()
  }
}