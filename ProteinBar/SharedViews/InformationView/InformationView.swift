//
//  InformationView.swift
//  Huddle
//
//  Created by William Vabrinskas on 2/7/23.
//

import Foundation
import SwiftUI

public enum InformationViewType {
  case confirm, destructive
  
  var buttonTitle: String {
    switch self {
    case .confirm:
      return "Okay"
    case .destructive:
      return "Cancel"
    }
  }
  
  var buttonImage: String {
    switch self {
    case .confirm:
      return "checkmark.circle"
    case .destructive:
      return "xmark.circle"
    }
  }
  
  var buttonType: InformationButtonViewModel.ButtonType {
    switch self {
    case .destructive:
      return .cancel
    default:
      return .priority
    }
  }
}

public struct InformationViewModel {
  let title: String
  let subtitle: String
  var body: String? = nil
  var detailTitle: String? = nil
  var closeType: InformationViewType = .confirm
  var buttons: [InformationButton] = []
}

public typealias InformationButtonAction = () async throws -> ()

public struct InformationButtonViewModel {
  enum ButtonType {
    case `default`, cancel, priority, action(title: String)
    
    func color(theme: any Theme) -> Color {
      switch self {
      case .`default`, .action:
        return theme.primaryTextColor
      case .cancel:
        return theme.errorColor
      case .priority:
        return theme.buttonPrimary
      }
    }
  }
  
  var title: String
  var icon: String
  var type: ButtonType = .default
  var imageSize: CGFloat = 14
  var textSize: CGFloat = 18
  var buttonSize: CGSize? = nil
  var action: InformationButtonAction
}

public struct InformationButton: View {
  @Environment(\.theme) var theme
  var viewModel: InformationButtonViewModel
  
  @State private var actionComplete: Bool = false
  @State private var buttonTitle: String = ""
  @State private var timer: Timer? = nil
  
  public var body: some View {
    Text("")
//    HuddleButton(viewModel: HuddleButtonViewModel(image: Image(systemName: viewModel.icon),
//                                                  text: buttonTitle,
//                                                  imageSize: viewModel.imageSize,
//                                                  textSize: viewModel.textSize,
//                                                  foregroundColor: viewModel.type.color(theme: theme),
//                                                  buttonSize: viewModel.buttonSize ?? CGSize(width: 120, height: 40),
//                                                  cornerRadius: 30,
//                                                  enabled: true,
//                                                  analyticsName: "information_button_" + buttonTitle)) {
//      Task { @MainActor in
//        do {
//          timer = Timer(timeInterval: 3, repeats: false, block: { t in
//            Task { @MainActor in
//              updateButtonTitle(string: "...")
//            }
//          })
//          try await viewModel.action()
//          timer?.invalidate()
//          timer = nil
//        } catch {
//          buttonTitle = "Error"
//          return
//        }
//        
//        if case .action(let title) = viewModel.type {
//          withAnimation {
//            actionComplete = true
//            buttonTitle = title
//            Timer.mainScheduledTimerAutoStop(withTimeInterval: 1, repeats: false) {
//              updateButtonTitle(string: viewModel.title)
//            }
//          }
//        }
//      }
//      
//    }
//    .onAppear {
//      buttonTitle = viewModel.title
//    }
  }
  
  @MainActor
  func updateButtonTitle(string: String) {
    withAnimation {
      buttonTitle = string
    }
  }
}

public struct InformationView: View {
  @Environment(\.theme) var theme
  @Binding var show: Bool
  let viewModel: InformationViewModel
  var onClose: (() -> ())?
  
  @State private var scale: CGFloat = 0
  @State private var opacity: CGFloat = 0
  
  public var body: some View {
    GeometryReader { g in
      ZStack {
        VStack {
          ProteinBarLabel(text: viewModel.title, color: theme.primaryTextColor, size: 20, fontWeight: .bold)
          .padding(.bottom, 1)
          .lineLimit(2)
          .multilineTextAlignment(.center)
          
          ProteinBarLabel(text: viewModel.subtitle, color: theme.primaryTextColor, size: 19, fontWeight: .bold)
          .padding(.bottom, 2)
          .lineLimit(15)
          .multilineTextAlignment(.center)
          .textSelection(.enabled)
          
          if let body = viewModel.body {
            ProteinBarLabel(text: body, color: theme.primaryTextColor, size: 17, fontWeight: .bold)
            .padding(.bottom, 2)
            .lineLimit(15)
            .multilineTextAlignment(.leading)
          }
          
          if let detailTitle = viewModel.detailTitle {
            ProteinBarLabel(text: detailTitle, color: theme.primaryTextColor, size: 25, fontWeight: .bold)
            .padding(.bottom, 20)
            .lineLimit(4)
            .multilineTextAlignment(.center)
            .textSelection(.enabled)
          }
          
          
          VStack {
            
            ForEach(0..<viewModel.buttons.count, id: \.self) { i in
              viewModel.buttons[i]
            }
            
            InformationButton(viewModel: InformationButtonViewModel(title: viewModel.closeType.buttonTitle,
                                                                    icon: viewModel.closeType.buttonImage,
                                                                    type: viewModel.closeType.buttonType,
                                                                    imageSize: 16,
                                                                    action: {
              show = false
            }))
          }
          
        }
        .padding(20)
        .background(
          .ultraThinMaterial,
          in: RoundedRectangle(cornerRadius: 35,
                               style: .continuous)
        )
        .colorScheme(.light)
        .scaleEffect(x: scale, y: scale)
        .animation(theme.springAnimation, value: scale)
      }
      .padding()
      .position(x: g.frame(in: .global).midX, y: g.frame(in: .global).midY - 60)
      .background(.ultraThinMaterial.opacity(0.8))
    }
    .onAppear {
      scale = show ? 1.0 : 0
      opacity = show ? 1.0 : 0
    }
    .onChange(of: show) { _, newValue in
      scale = newValue ? 1.0 : 0
      opacity = newValue ? 1.0 : 0
      
      if show == false {
        onClose?()
      }
    }
    .fullscreen()
    .opacity(opacity)
    .animation(.easeIn, value: opacity)
  }
}

struct InformationView_Previews: PreviewProvider {
  
  static var text: String {
    "Some test alert"
  }
  
  static var buttons: [InformationButton] {
    [
      InformationButton(viewModel: InformationButtonViewModel(title: "Copy",
                                                              icon: "clipboard",
                                                              type: .action(title: "Copied!"),
                                                              action: {
                                                                
                                                              }))
    ]
  }
  
  static var previews: some View {
    InformationView(show: .constant(true),
                    viewModel: InformationViewModel(title: "Alert",
                                                    subtitle: text,
                                                    body: "",
                                                    detailTitle: "BACKUP_CODE",
                                                    closeType: .confirm,
                                                    buttons: self.buttons))
    .preview()
  }
}
