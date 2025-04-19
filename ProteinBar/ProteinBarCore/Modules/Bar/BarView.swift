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
      ProteinBarLabel(text: "Protein Bar",
                      color: theme.primaryTextColor,
                      size: 42,
                      fontWeight: .heavy)
      ScrollView {
        LazyVStack {
          ForEach(0..<viewModel.values.count, id: \.self) { i in
            let value = self.viewModel.values[i]
            
            ValueBarView(value: $viewModel.values[i].value,
                         viewModel: .init(title: value.name.rawValue.capitalized,
                                          unit: value.name.unit,
                                          range: 0...value.maxValue,
                                          barColor: value.name.barColor(theme: theme),
                                          leadingIcon: value.name.icon))
          }
        }
        .padding()
      }
    }
    .onChange(of: viewModel.values, { oldValue, newValue in
      print(newValue)
    })
    .fullscreen()
    .applyThemeBackground(gradient: false)
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
