
//
//  RootView.swift
//  ProteinBar
//
//  Created by William Vabrinskas on 4/16/25.
//


import SwiftUI

struct RootView: View {
  @Environment(\.scenePhase) var scenePhase

  let module: RootModule
  let router: RootRouting
  
  var body: some View {
    Text("")
  }
}

struct RootView_Previews: PreviewProvider {
  static let rootModule = RootModuleHolder(context: RootModuleHolderContext(), component: RootComponentImpl())
  static let router: RootRouter? = RootBuilder.buildRouter(component: RootViewComponentImpl(rootModule: rootModule,
                                                                                              moduleHolder: rootModule))
  
  static var previews: some View {
    router!.rootView()
      .preview()
  }
}
