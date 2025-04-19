//
//  
//  SettingsViewModel.swift
//  ProteinBar
//
//  Created by William Vabrinskas on 4/18/25.
//
//

import Foundation
import SwiftUI
import HuddleArch

@Observable
public final class SettingsViewModel {
  var numberOfColumns: Int
  var trackingValues: [[TrackingValue]]
  
  init(numberOfColumns: Int = 2,
       trackingValues: [[TrackingValue]] = []) {
    self.numberOfColumns = numberOfColumns
    self.trackingValues = trackingValues
  }
}
