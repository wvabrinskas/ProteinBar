//
//  ProteinTextField.swift
//  ProteinBar
//
//  Created by William Vabrinskas on 4/19/25.
//

import SwiftUI

public struct ProteinBarTextFieldViewModel {
  let placeholder: String
  let secure: Bool
  let text: Binding<String>
  let size: CGFloat
  let color: Color?
  let showClearButton: Bool
  let sentenceCase: Bool
  let keyboardType: UIKeyboardType?
  let trailingLabelText: String?
  
  init(placeholder: String,
       secure: Bool = false,
       text: Binding<String>,
       size: CGFloat,
       color: Color? = nil,
       showClearButton: Bool = false,
       sentenceCase: Bool = false,
       keyboardType: UIKeyboardType = .default,
       trailingLabelText: String? = nil) {
    self.placeholder = placeholder
    self.secure = secure
    self.text = text
    self.size = size
    self.color = color
    self.showClearButton = showClearButton
    self.sentenceCase = sentenceCase
    self.keyboardType = keyboardType
    self.trailingLabelText = trailingLabelText
  }
}

struct ProteinBarTextField: View {
  @Environment(\.theme) var theme
  let viewModel: ProteinBarTextFieldViewModel
  
  var body: some View {
    HStack {
      getField()
        .textInputAutocapitalization(viewModel.sentenceCase ? .words : .never)
        .asAnyView()
        .font(theme.font(viewModel.size, weight: .bold))
        .foregroundColor(viewModel.color ?? theme.primaryTextColor)
        .padding(10)
        .depth()
      
      if let trailingLabelText = viewModel.trailingLabelText {
        ProteinBarLabel(text: trailingLabelText,
                        color: theme.primaryTextColor.opacity(0.5),
                        size: 30,
                        fontWeight: .bold)
      }
    }
    .preferredColorScheme(.light)
    .onAppear {
      if viewModel.showClearButton {
        UITextField.appearance().clearButtonMode = .whileEditing
      }
    }
  }
  
  private func getField() -> any View {
    if viewModel.secure {
      return SecureField(viewModel.placeholder, text: viewModel.text) {
        #if !TARGET_IS_SHARE
        UIApplication.shared.endEditing()
        #endif
      }
    } else {
      return TextField(viewModel.placeholder, text: viewModel.text) {
        #if !TARGET_IS_SHARE
        UIApplication.shared.endEditing()
        #endif
      }
    }
  }
}

#if !TARGET_IS_SHARE
struct HuddleTextField_Previews: PreviewProvider {
  static var previews: some View {
    ProteinBarTextField(viewModel: .init(placeholder: "Hello",
                                     text: .constant(""),
                                     size: 30,
                                     trailingLabelText: "g"))
    .frame(width: 140)
    .preview()
  }
}
#endif


