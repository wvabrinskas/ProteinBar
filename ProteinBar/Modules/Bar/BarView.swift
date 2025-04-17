//
//  
//  BarView.swift
//  ProteinBar
//
//  Created by William Vabrinskas on 4/16/25.
//
//

import Foundation
import SwiftUI
import HuddleArch

public struct BarView: View {
  
  @Environment(\.theme) var theme
  let router:  BarRouting
  var module: any BarSupporting
  var moduleHolder: ModuleHolding?

  @State var viewModel: BarViewModel

  public var body: some View {
    VStack {
      Text("Some Text")
    }
    .fullscreen()
    .applyThemeBackground()
  }
}

struct BarView_Previews: PreviewProvider {
  static let context = RootModuleHolderContext()
  static let rootComponent =  RootModuleComponentImpl()
  static let moduleHolder = RootModuleHolder(context: context, component: rootComponent)

  static let module = BarBuilder.build(parentComponent: rootComponent, holder: moduleHolder, context: context)

  static var previews: some View {
    module.router!.rootView()
      .preview()
  }
}
