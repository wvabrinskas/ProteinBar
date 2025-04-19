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
import NumSwift

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
        Grid(horizontalSpacing: 0, verticalSpacing: 30) {
          ProteinBarLabel(text: "Trackers",
                          color: theme.primaryTextColor,
                          size: 25,
                          fontWeight: .heavy)
          .align(.leading)
          
          ForEach(0..<viewModel.trackingValues.count, id: \.self) { row in
            GridRow {
              ForEach(0..<viewModel.numberOfColumns, id: \.self) { column in
                TrackerCellView(viewModel: .init(value: viewModel.trackingValues[safe: row]?[safe: column],
                                                 isSelected: module.isTrackerSelected(name: viewModel.trackingValues[safe: row]?[safe: column]?.name))) { selected, name in
                  onSelected(selected: selected, name: name)
                }
              }
            }
          }
        }
      }
    }
    .padding()
    .fullscreen()
    .applyThemeBackground()
    .onAppear {
      module.onAppear()
    }
  }
  
  private func onSelected(selected: Bool, name: TrackingName) {
    module.onSelected(selected: selected, name: name)
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
