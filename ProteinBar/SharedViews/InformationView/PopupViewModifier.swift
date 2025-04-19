//
//  PopupModifier.swift
//  Huddle
//
//  Created by William Vabrinskas on 6/14/23.
//

import Foundation
import SwiftUI

fileprivate struct PopupViewModifier: ViewModifier {
  @Binding var show: Bool
  let viewModel: InformationViewModel
  var onClose: (() -> ())?

  public func body(content: Content) -> some View {
    ZStack {
      content
      InformationView(show: $show,
                      viewModel: viewModel,
                      onClose: onClose)
    }
  }
}

fileprivate struct PopupViewWithStorageModifier: ViewModifier {
  @State private var show: Bool = false
  let key: SharedStorageKeys
  let userStorageProvider: UserStorageProvider<SharedStorageKeys>
  let viewModel: InformationViewModel
  var onClose: (() -> ())?

  public func body(content: Content) -> some View {
    ZStack {
      content
      InformationView(show: $show,
                      viewModel: viewModel,
                      onClose: {
        userStorageProvider.setObject(key: key, object: true)
        onClose?()
      })
    }
    .onAppear {
      if let s: Bool = userStorageProvider.getObject(key: key) {
        show = !s
      } else {
        show = true
      }
    }
  }
}


extension View {
  func popup(show: Binding<Bool>,
             viewModel: InformationViewModel,
             onClose: (() -> ())? = nil) -> some View {
    self.modifier(PopupViewModifier(show: show,
                                    viewModel: viewModel,
                                    onClose: onClose))
  }
  
  func popupOnceOnAppear(key: SharedStorageKeys,
                         userStorageProvider: UserStorageProvider<SharedStorageKeys>,
                         viewModel: InformationViewModel,
                         onClose: (() -> ())? = nil)  -> some View {
    self.modifier(PopupViewWithStorageModifier(key: key,
                                               userStorageProvider: userStorageProvider,
                                               viewModel: viewModel,
                                               onClose: onClose))
  }
}
