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

public struct TrackerCellView: View {
  @Environment(\.theme) var theme
  
  let viewModel: TrackerCellViewModel
  var selectedAction: (Bool, TrackingName) -> ()
  
  private let iconSize : CGFloat = 30
  
  @State private var selected: Bool
  
  init(viewModel: TrackerCellViewModel, selectedAction: @escaping (Bool, TrackingName) -> Void) {
    self.viewModel = viewModel
    self.selectedAction = selectedAction
    self.selected = viewModel.isSelected
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
        
      }
      .frame(width: 100, height: 100)
      .padding()
      .depth()
      .onTapGesture {
        withAnimation(.easeInOut(duration: 0.1)) {
          selected.toggle()
        }
      }
      .onChange(of: selected, { oldValue, newValue in
        selectedAction(newValue, value.name)
      })
      .overlay {
        RoundedRectangle(cornerRadius: 16, style: .continuous)
          .fill(.clear)
          .stroke(theme.primaryTextColor, style: .init(lineWidth: selected ? 3 : 0))
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
                                     isSelected: true)) { _, _ in
      
    }
  }
}
