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
  var values: [TrackingValue]
  var reset: Bool
  var settings: Bool
  
  init(values: [TrackingValue] = [],
       reset: Bool = false,
       settings: Bool = false) {
    self.values = values
    self.reset = reset
    self.settings = settings
  }
}

