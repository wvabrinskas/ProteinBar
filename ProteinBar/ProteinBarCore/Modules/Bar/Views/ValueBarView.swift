//
//  ValueBarView.swift
//  ProteinBar
//
//  Created by William Vabrinskas on 4/18/25.
//

import Foundation
import SwiftUI
import HuddleArch

public struct ValueBarViewModel {
  var title: String
  var unit: String?
  var range: ClosedRange<Int>
  var barColor: Color
  var leadingIcon: Image?
  var editing: Bool = false
  var id: String
  var hidden: Bool = false
}

public struct ValueBarView: View {
  
  @Environment(\.theme) var theme
  
  @Binding public var value: Int
  public var viewModel: ValueBarViewModel

  public var body: some View {
    VStack(spacing: 8) {
      HStack {
        if let leadingIcon = viewModel.leadingIcon {
          leadingIcon
            .resizable()
            .aspectRatio(contentMode: .fit)
            .bold()
            .foregroundStyle(theme.primaryTextColor.opacity(0.65))
            .frame(width: 32, height: 32)
        }
        
        ProteinBarLabel(text: viewModel.title,
                        color: theme.primaryTextColor.opacity(0.65),
                        size: 28,
                        fontWeight: .heavy)
        
        Spacer()
        
        ProteinBarLabel(text: valueTitle(),
                        color: theme.primaryTextColor.opacity(0.65),
                        size: 28,
                        fontWeight: .heavy)
        .contentTransition(.numericText())
      }
      .padding([.leading, .trailing], 8)
      
      ColorSlider(value: $value,
                  range: viewModel.range,
                  trackColor: theme.backgroundColorBottom,
                  progressColor: viewModel.barColor,
                  thumbColor: viewModel.barColor,
                  height: 40)
      .padding([.leading, .trailing], 8)
      .padding(.bottom, 16)
    }
    .padding()
    .depth(foregroundColor: .backgroundColorTop)
    .isHidden(viewModel.hidden, remove: true)
  }
  
  private func valueTitle() -> String {
    var title = "\(Int(value))"
    
    if let unit = viewModel.unit {
      title += " \(unit)"
    }
    
    return title
  }
}

struct CloseButtonModifier: ViewModifier {
  
  @Environment(\.theme) var theme
  var show: Bool
  public var onDelete: () -> ()
  
  func body(content: Content) -> some View {
    HStack(spacing: 0) {
      content
      ProteinBarButton(viewModel: .circle(image: Image(systemName: "trash"),
                                          size: 21,
                                          buttonSize: 45,
                                          backgroundColor: theme.errorColor,
                                          foregroundColor: theme.backgroundColorTop,
                                          enabled: true)) {
        onDelete()
      }
                                          .align(.trailing)
                                          .frame(width: 55)
                                          .isHidden(show == false, remove: true)
    }
  }
}

struct ValueBarView_Previews: PreviewProvider {
  static var previews: some View {
    ScrollView {
      ValueBarView(value: .constant(50),
                   viewModel: .init(title: TrackingName.protein.rawValue
                    .capitalized,
                                    range: 0...100,
                                    barColor: .app(.proteinColor),
                                    id: TrackingName.protein.rawValue))
      ValueBarView(value: .constant(50),
                   viewModel: .init(title: TrackingName.water.rawValue
                    .capitalized,
                                    range: 0...100,
                                    barColor: .app(.waterColor),
                                    id: TrackingName.water.rawValue))
      ValueBarView(value: .constant(50),
                   viewModel: .init(title: TrackingName.fiber.rawValue
                    .capitalized,
                                    range: 0...100,
                                    barColor: .app(.fiberColor),
                                    id: TrackingName.fiber.rawValue))
      ValueBarView(value: .constant(50),
                   viewModel: .init(title: TrackingName.carbohydrates.rawValue
                    .capitalized,
                                    range: 0...100,
                                    barColor: .app(.carbColor),
                                    id: TrackingName.carbohydrates.rawValue))
    }
    .padding()
      .preview()
  }
}
