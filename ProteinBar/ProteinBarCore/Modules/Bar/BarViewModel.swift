//
//  
//  BarViewModel.swift
//  ProteinBar
//
//  Created by William Vabrinskas on 4/16/25.
//
//

import Foundation
import SwiftUI
import HuddleArch

@Observable
public final class BarViewModel {
  var values: TrackingValues
  var reset: Bool
  var editing: Bool
  
  init(values: TrackingValues = .empty(),
       reset: Bool = false,
       editing: Bool = false) {
    self.values = values
    self.reset = reset
    self.editing = editing
  }
}

