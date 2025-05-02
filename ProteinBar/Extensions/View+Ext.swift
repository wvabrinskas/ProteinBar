//
//  View+Ext.swift
//  ProteinBar
//
//  Created by William Vabrinskas on 4/16/25.
//

import Combine
import Foundation
import SwiftUI

public struct Dimension<Content: Shape>: View {
  let color: Color
  let content: Content
  
  public var body: some View {
      content
      .fill(Gradient(colors: [color, color.opacity(0.8)]))
      .stroke(Gradient(colors: [.white.opacity(0.6), color]), lineWidth: 1)
  }
}

public extension Shape {
  func dimension(color: Color) -> some View {
    Dimension(color: color, content: self)
  }
  
  func depthShape(foregroundColor: Color = .app(.backgroundColorBottom), cornerRadius: CGFloat = 16) -> some View {
    DepthShape(foregroundColor: foregroundColor, cornerRadius: cornerRadius, content: self)
  }
}

public struct DepthShape<Content: Shape>: View  {
  @Environment(\.theme) var theme
  
  var foregroundColor: Color
  var cornerRadius: CGFloat
  let content: Content
  
  public var body: some View {
    content
        .fill(.shadow(.inner(color: theme.shadowColor.opacity(0.3),
                             radius: 1,
                             x: 0,
                             y: 3)))
          .foregroundStyle(foregroundColor)
      .overlay(
          RoundedRectangle(cornerRadius: cornerRadius)
            .strokeBorder( LinearGradient(
              gradient: Gradient(colors: [
                theme.shadowColor.opacity(0.2),
                Color.black.opacity(0.1)
              ]),
              startPoint: .top,
              endPoint: .bottom
          ),
                           lineWidth: 1)
      )
      .compositingGroup()
      .shadow(color: theme.shadowColor.opacity(0.2), radius: 2, x: 0, y: 3)
  }
}

public struct Depth: ViewModifier {
  @Environment(\.theme) var theme
  
  var foregroundColor: Color
  var cornerRadius: CGFloat
  
  public func body(content: Content) -> some View {
    content
      .background(RoundedRectangle(cornerRadius: cornerRadius,
                                   style: .continuous)
        .fill(.shadow(.inner(color: theme.shadowColor.opacity(0.3),
                             radius: 1,
                             x: 0,
                             y: 3)))
          .foregroundStyle(foregroundColor))
      .overlay(
          RoundedRectangle(cornerRadius: cornerRadius)
            .strokeBorder( LinearGradient(
              gradient: Gradient(colors: [
                theme.shadowColor.opacity(0.2),
                Color.black.opacity(0.1)
              ]),
              startPoint: .top,
              endPoint: .bottom
          ),
                           lineWidth: 1)
      )
      .compositingGroup()
      .shadow(color: theme.shadowColor.opacity(0.2), radius: 2, x: 0, y: 3)
  }
}

public struct FadeIn: ViewModifier {
  var duration: CGFloat
  @State private var opacity: CGFloat = 0
  
  public func body(content: Content) -> some View {
    content
      .opacity(opacity)
      .animation(.easeIn(duration: duration), value: opacity)
      .onAppear {
        opacity = 1
      }
  }
}


public struct TapToHideKeyboard: ViewModifier {
  public func body(content: Content) -> some View {
    content
      .simultaneousGesture(TapGesture(count: 1)
        .onEnded {
          #if !TARGET_IS_EXTENSION
          UIApplication.shared.endEditing()
          #endif
        })
  }
}

public extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder),
                   to: nil,
                   from: nil,
                   for: nil)
    }
}

public extension Optional where Wrapped: Combine.Publisher {
    func orEmpty() -> AnyPublisher<Wrapped.Output, Wrapped.Failure> {
        self?.eraseToAnyPublisher() ?? Empty().eraseToAnyPublisher()
    }
}

public struct OptionalFrame<Frame: View> : ViewModifier {
  let apply: Bool
  @ViewBuilder let frame: (_ content: any View) -> Frame
  
  public func body(content: Content) -> some View {
    if apply {
      frame(content)
    } else {
      content
    }
  }
}

public extension View {
  @ViewBuilder func isHidden(_ hidden: Bool, remove: Bool = false) -> some View {
    if hidden {
      if !remove {
        self.hidden()
      }
    } else {
      self
    }
  }
  
  func align(_ alignment: Alignment) -> some View {
    self.modifier(AlignView(alignment: alignment))
  }
  
  func depth(foregroundColor: Color = .app(.backgroundColorBottom), cornerRadius: CGFloat = 16) -> some View {
    modifier(Depth(foregroundColor: foregroundColor, cornerRadius: cornerRadius))
  }
  
  func asAnyView() -> AnyView {
    AnyView(self)
  }

  func fadeIn(duration: CGFloat) -> some View {
    modifier(FadeIn(duration: duration))
  }
  
  func optionalFrame<Frame: View>(apply: Bool,
                                  @ViewBuilder frame: @escaping (_ content: any View) -> Frame) -> some View {
    return modifier(OptionalFrame(apply: apply, frame: frame))
  }
  
  var isPreviewRender: Bool {
    ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] != nil
  }
  
  func replaceWith(_ view: Binding<AnyView?>) -> AnyView {
    self.modifier(HuddleReplaceView(viewToReplace: view, oldContent: self)).asAnyView()
  }
  
  func preview() -> AnyView {
    self.modifier(HuddlePreviewProvider())
      .asAnyView()
  }
  
  func iphoneSEPreview() -> some View {
    self
      .previewDevice(PreviewDevice(rawValue: "iPhone SE (3rd generation)"))
      .previewDisplayName("iPhone SE (3rd generation)")
  }
  
  func iphoneProMaxPreview() -> some View {
    self
      .previewDevice(PreviewDevice(rawValue: "iPhone 16 Pro Max"))
      .previewDisplayName("iPhone 16 Pro Max")
  }
  
  func tapToHideKeyboard() -> some View {
    self.modifier(TapToHideKeyboard())
  }
  
  @inlinable func optionalRecieveOn<P>(_ publisher: P?,
                                       perform action: @escaping (P.Output) -> Void) -> some View where P : Publisher, P.Failure == Never {
    return self.onReceive(publisher.orEmpty(),
                          perform: action)
  }
  
  
  func applyThemeBackground(gradient: Bool = true) -> some View {
    modifier(ThemeBackgroundModifier(gradient: gradient))
      .preferredColorScheme(.dark)
  }
  
  func fullscreen() -> some View {
    self.frame(maxWidth: .infinity, maxHeight: .infinity)
      .preferredColorScheme(.dark)
  }
}

struct ThemeBackgroundModifier: ViewModifier {
  @Environment(\.theme) var theme
  let gradient: Bool
  
  func body(content: Content) -> some View {
    content
      .background(getBackground().ignoresSafeArea(.all))
      .accentColor(Color.black)
  }
  
  private func getBackground() -> AppBackground {
    AppBackground(gradient: gradient)
  }
}

struct AppBackground: View {
  @Environment(\.theme) var theme
  let gradient: Bool
  
  public var body: some View {
    if gradient {
      LinearGradient(colors: [theme.backgroundColorTop,
                              theme.backgroundColorBottom], startPoint: .top,
                     endPoint: .bottom)
    } else {
      theme.backgroundColorBottom
    }
  }
}

struct HuddleReplaceView: ViewModifier {
  @Binding var viewToReplace: AnyView?
  let oldContent: any View
  
  public func body(content: Content) -> some View {
    viewToReplace ?? content.asAnyView()
  }
}


struct HuddlePreviewProvider: ViewModifier {
  public func body(content: Content) -> some View {
    content
      .fullscreen()
      .applyThemeBackground(gradient: false)
      .iphoneProMaxPreview()
    
    content
      .fullscreen()
      .applyThemeBackground(gradient: false)
      .iphoneSEPreview()

  }
}
