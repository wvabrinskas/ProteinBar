//
//  ProteinBarLabel.swift
//  ProteinBar
//
//  Created by William Vabrinskas on 4/18/25.
//

import SwiftUI


public struct ProteinBarLabel: View {
  @Environment(\.theme) var theme
  
  let text: String
  let color: Color
  let size: Double
  let fontWeight: Font.Weight
  
  public var body: some View {
    Text(text)
      .font(theme.font(size, weight: fontWeight))
      .foregroundStyle(color)
  }
}


struct ProteinBarLabel_Previews: PreviewProvider {
  static var previews: some View {
    ProteinBarLabel(text: "Test",
                    color: .black,
                    size: 55,
                    fontWeight: .black)
      .preview()
  }
}
