//
//  ProteinBarButton.swift
//  ProteinBar
//
//  Created by William Vabrinskas on 4/18/25.
//

import SwiftUI

public struct ProteinBarButtonViewModel {
  
  public enum LabelPosition {
    case inside, below
  }
  
  let image: Image?
  let title: String?
  let textSize: CGFloat
  let imageSize: CGFloat
  let foregroundColor: Color
  let buttonSize: CGSize
  let cornerRadius: CGFloat
  let enabled: Bool
  let backgroundColor: Color?
  let labelPosition: LabelPosition
  
  static func circle(image: Image? = nil,
                     size: CGFloat,
                     buttonSize: CGFloat,
                     backgroundColor: Color? = nil,
                     foregroundColor: Color = .white,
                     enabled: Bool = true) -> ProteinBarButtonViewModel {

    .init(image: image,
          title: nil,
          textSize: size,
          imageSize: size,
          foregroundColor: foregroundColor,
          buttonSize: CGSize(width: buttonSize,
                             height: buttonSize),
          cornerRadius: buttonSize / 2,
          enabled: enabled,
          backgroundColor: backgroundColor)
  }
    
  public init(image: Image? = nil,
              title: String? = nil,
              textSize: CGFloat,
              imageSize: CGFloat,
              foregroundColor: Color = .white,
              buttonSize: CGSize,
              cornerRadius: CGFloat,
              enabled: Bool = true,
              backgroundColor: Color? = nil,
              labelPosition: LabelPosition = .inside) {
    self.image = image
    self.title = title
    self.imageSize = imageSize
    self.foregroundColor = foregroundColor
    self.buttonSize = buttonSize
    self.cornerRadius = cornerRadius
    self.enabled = enabled
    self.textSize = textSize
    self.backgroundColor = backgroundColor
    self.labelPosition = labelPosition
  }
}

public struct ProteinBarButton: View {
  @Environment(\.theme) var theme
  
  let viewModel: ProteinBarButtonViewModel
  var action: () -> ()
  
  var color: Color {
    viewModel.backgroundColor ?? theme.backgroundColorTop
  }
  
  public var body: some View {
    VStack {
      Button {
        action()
      } label: {
        RoundedRectangle(cornerRadius: viewModel.cornerRadius, style: .continuous)
          .fill(color)
          .frame(width: viewModel.buttonSize.width, height: viewModel.buttonSize.height)
          .overlay {
            HStack {
              ProteinBarLabel(text: viewModel.title ?? "",
                              color: viewModel.foregroundColor,
                              size: viewModel.textSize,
                              fontWeight: .bold)
              .isHidden((viewModel.title == nil || viewModel.labelPosition == .below), remove: true)
              
              viewModel.image?
                .resizable()
                .bold()
                .aspectRatio(contentMode:.fit)
                .frame(width: viewModel.imageSize)
                .foregroundStyle(viewModel.foregroundColor.gradient.shadow(.inner(color: .black.opacity(0.2),
                                                                                  radius: 0.7,
                                                                                  x: 0,
                                                                                  y: 0)))
                .isHidden(viewModel.image == nil, remove: true)
            }
          }
      }
      .clipShape(RoundedRectangle(cornerRadius: viewModel.cornerRadius, style: .continuous))
      .frame(width: viewModel.buttonSize.width, height: viewModel.buttonSize.height)
      
      ProteinBarLabel(text: viewModel.title ?? "", color: viewModel.foregroundColor, size: viewModel.textSize, fontWeight: .regular)
      .isHidden((viewModel.title == nil || viewModel.labelPosition == .inside), remove: true)
    }
    .opacity(viewModel.enabled ? 1.0 : 0.6)
    .disabled(viewModel.enabled == false)
  }
}



struct ProteinBarButton_Previews: PreviewProvider {
  static var previews: some View {
    ProteinBarButton(viewModel: .circle(image: Image(systemName: "pencil"),
                                        size: 26,
                                        buttonSize: 60,
                                        backgroundColor: .app(.buttonPrimary),
                                        foregroundColor: .white,
                                        enabled: true)) {
      
    }
  }
}
