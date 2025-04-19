//
//  TrackerCellView.swift
//  ProteinBar
//
//  Created by William Vabrinskas on 4/18/25.
//

import SwiftUI

public struct TrackerCellViewModel {
  let value: TrackingValue?
  let isSelected: Bool
}

public enum TrackerCellAction {
  case select(Bool, TrackingName)
  case setMaxValue(Int, TrackingName)
}

public struct TrackerCellView: View {
  @Environment(\.theme) var theme
  
  let viewModel: TrackerCellViewModel
  var action: (TrackerCellAction) -> ()
  
  private let iconSize : CGFloat = 30
  
  @State private var selected: Bool
  @State private var maxValue: String
  @State private var editing: Bool = false
  
  init(viewModel: TrackerCellViewModel, action: @escaping (TrackerCellAction) -> ()) {
    self.viewModel = viewModel
    self.action = action
    self.selected = viewModel.isSelected
    if let value = viewModel.value {
      self.maxValue = "\(value.maxValue)"
    } else {
      self.maxValue = ""
    }
  }
  
  public var body: some View {
    
    if let value = viewModel.value {
      VStack {
        value.name.icon
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: iconSize, height: iconSize)
          .foregroundColor(value.name.barColor(theme: theme))
        
        ProteinBarLabel(text: value.name.shortName.capitalized,
                        color: theme.primaryTextColor,
                        size: 18,
                        fontWeight: .bold)
        
        ProteinBarLabel(text: "\(value.value) / \(value.maxValue) \(value.name.unit)",
                        color: theme.primaryTextColor.opacity(0.6),
                        size: 14,
                        fontWeight: .bold)
        
        ProteinBarButton(viewModel: .init(image: nil,
                                          title: "Edit",
                                          textSize: 14,
                                          imageSize: 14,
                                          foregroundColor: theme.primaryTextColor,
                                          buttonSize: .init(width: 70, height: 30),
                                          cornerRadius: 25,
                                          enabled: true,
                                          backgroundColor: nil,
                                          labelPosition: .inside)) {
          editing.toggle()
        }
        
      }
      .frame(width: 120, height: 120)
      .padding()
      .depth()
      .sheet(isPresented: $editing) {
        VStack {
          ProteinBarTextField(viewModel: .init(placeholder: "Max",
                                               secure: false,
                                               text: $maxValue,
                                               size: 21,
                                               showClearButton: false,
                                               sentenceCase: false,
                                               keyboardType: .numberPad,
                                               trailingLabelText: viewModel.value?.name.unit))
          .frame(width: 150)
          
          HStack {
            ProteinBarButton(viewModel: .init(image: nil,
                                              title: "Okay",
                                              textSize: 16,
                                              imageSize: 14,
                                              foregroundColor: theme.backgroundColorTop,
                                              buttonSize: .init(width: 70, height: 30),
                                              cornerRadius: 25,
                                              enabled: true,
                                              backgroundColor: theme.successColor,
                                              labelPosition: .inside)) {
              
              if let intValue = Int(maxValue), let value = viewModel.value {
                action(.setMaxValue(intValue, value.name))
              }
              
              editing.toggle()
            }
            
            ProteinBarButton(viewModel: .init(image: nil,
                                              title: "Cancel",
                                              textSize: 16,
                                              imageSize: 14,
                                              foregroundColor: theme.backgroundColorTop,
                                              buttonSize: .init(width: 70, height: 30),
                                              cornerRadius: 25,
                                              enabled: true,
                                              backgroundColor: theme.errorColor,
                                              labelPosition: .inside)) {
              editing.toggle()
            }
            
          }
        }
        .frame(width: 300)
        .presentationDetents([.height(150)])
        .presentationCornerRadius(22)
        .presentationBackground(theme.backgroundColorBottom)
      }
      .onTapGesture {
        withAnimation(.easeInOut(duration: 0.1)) {
          selected.toggle()
        }
      }
      .onChange(of: selected, { oldValue, newValue in
        action(.select(newValue, value.name))
      })
      .overlay {
        RoundedRectangle(cornerRadius: 16, style: .continuous)
          .fill(.clear)
          .stroke(theme.primaryTextColor, style: .init(lineWidth: selected ? 5 : 0))
      }
    } else {
      EmptyView()
    }
  }
}


struct TrackerCellView_Previews: PreviewProvider {
  static var previews: some View {
    TrackerCellView(viewModel: .init(value: .init(name: .water,
                                                  value: 100,
                                                  maxValue: 1000),
                                     isSelected: true)) { action in
      
    }
  }
}
