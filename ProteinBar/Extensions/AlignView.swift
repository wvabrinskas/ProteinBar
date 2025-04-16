//
//  AlignView.swift
//  ProteinBar
//
//  Created by William Vabrinskas on 4/16/25.
//



import Foundation
import SwiftUI

struct AlignView: ViewModifier {
  let alignment: Alignment
  
  private var maxHeight: CGFloat? {
    if alignment == .bottom ||
        alignment == .top ||
        alignment == .bottomLeading ||
        alignment == .bottomTrailing ||
        alignment == .topLeading ||
        alignment == .topTrailing {
      return .infinity
    }
    
    return nil
  }
  
  private var maxWidth: CGFloat? {
    if alignment == .leading ||
        alignment == .trailing ||
        alignment == .bottomLeading ||
        alignment == .bottomTrailing ||
        alignment == .topLeading ||
        alignment == .topTrailing {
      return .infinity
    }
    
    return nil
  }
  
  public func body(content: Content) -> some View {
  
    content
      .frame(maxWidth: maxWidth,
             maxHeight: maxHeight,
             alignment: alignment)
  }
}
