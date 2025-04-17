//
//  
//  RootView.swift
//  ProteinBar
//
//  Created by William Vabrinskas on 4/16/25.
//
//
import SwiftUI
import HuddleArch

struct RootView: View {
  @Environment(\.scenePhase) var scenePhase

  let module: RootSupporting
  let router: RootRouting
  @State var viewModel: RootViewModel

  var body: some View {
    router.routeToBarView()
    .asAnyView()
  }
}

struct RootView_Previews: PreviewProvider {
  static let module = RootModuleHolder(context: RootModuleHolderContext(), component: RootModuleComponentImpl())
  static let router: RootRouter? = RootBuilder.buildRouter(component: RootViewComponentImpl(module: module, moduleHolder: module))
  
  static var previews: some View {
    router!.rootView()
      .preview()
  }
}
