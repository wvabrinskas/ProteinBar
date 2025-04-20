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
      ZStack {
        ProteinBarButton(viewModel: .circle(image: Image(systemName: "arrow.clockwise"),
                                            size: 24,
                                            buttonSize: 32,
                                            backgroundColor: .clear,
                                            foregroundColor: theme.primaryTextColor,
                                            enabled: true)) {
          viewModel.reset.toggle()
        }
        .align(.leading)
        .padding(.leading, 16)
        
        ProteinBarButton(viewModel: .circle(image: Image(systemName: "gearshape.fill"),
                                            size: 28,
                                            buttonSize: 32,
                                            backgroundColor: .clear,
                                            foregroundColor: theme.primaryTextColor,
                                            enabled: true)) {
          viewModel.settings.toggle()
        }
        .align(.trailing)
        .padding(.trailing, 16)

        ProteinBarLabel(text: "Protein Bar",
                        color: theme.primaryTextColor.opacity(0.65),
                        size: 32,
                        fontWeight: .heavy)
      }

      ScrollView {
        LazyVStack {
          ForEach(0..<viewModel.values.count, id: \.self) { i in
            let value: TrackingValue = viewModel.values[i]
            
            ValueBarView(value: $viewModel.values[i].value,
                         viewModel: .init(title: value.name.shortName.capitalized,
                                          unit: value.name.unit,
                                          range: 0...value.maxValue,
                                          barColor: value.name.barColor(theme: theme),
                                          leadingIcon: value.name.icon,
                                          id: value.name.rawValue,
                                          hidden: value.visible == false))
          }
        }
        .padding()
      }
    }
    .onChange(of: viewModel.values, { oldValue, newValue in
      module.save()
    })
    .popup(show: $viewModel.reset, viewModel: .init(title: "Reset", subtitle: "Reset values to zero?",
                                                    body: nil,
                                                    detailTitle: nil,
                                                    closeType: .destructive,
                                                    buttons: [
      .init(viewModel: .init(title: "Okay",
                             icon: "checkmark",
                             action: {
                               withAnimation {
                                 module.reset()
                               }
        viewModel.reset.toggle()
      }))
    ]))
    .sheet(isPresented: $viewModel.settings) {
      router.routeToSettingsView().asAnyView()
    }
    .fullscreen()
    .applyThemeBackground(gradient: false)
  }
  
  private func remove(id: String) {
    
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
