//
//  
//  SettingsView.swift
//  ProteinBar
//
//  Created by William Vabrinskas on 4/18/25.
//
//

import Foundation
import SwiftUI
import HuddleArch

public struct SettingsView: View {
  
  @Environment(\.theme) var theme
  let router:  SettingsRouting
  var module: any SettingsSupporting
  var moduleHolder: ModuleHolding?

  @State var viewModel: SettingsViewModel
  
  public var body: some View {
    VStack {
      ProteinBarLabel(text: "Settings",
                      color: theme.primaryTextColor,
                      size: 42,
                      fontWeight: .heavy)
      ScrollView {
        Grid(horizontalSpacing: 30, verticalSpacing: 30) {
          ProteinBarLabel(text: "Visible trackers",
                          color: theme.primaryTextColor,
                          size: 25,
                          fontWeight: .heavy)
          .align(.leading)
          
          ForEach(0..<viewModel.trackingValues.count, id: \.self) { row in
            GridRow {
              ForEach(0..<viewModel.numberOfColumns, id: \.self) { column in
                ProteinBarLabel(text: "(\(column), \(row))",
                                color: theme.primaryTextColor,
                                size: 16,
                                fontWeight: .regular)
              }
            }
          }
        }
      }
    }
    .padding()
    .fullscreen()
    .applyThemeBackground()
  }
}

struct SettingsView_Previews: PreviewProvider {
  static let context = RootModuleHolderContext()
  static let rootComponent =  RootModuleComponentImpl()
  static let moduleHolder = RootModuleHolder(context: context, component: rootComponent)

  static let module = SettingsBuilder.build(parentComponent: rootComponent, holder: moduleHolder, context: context)

  static var previews: some View {
    module.router!.rootView()
      .preview()
  }
}
