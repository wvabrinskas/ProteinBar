//
//  ProteinBarApp.swift
//  ProteinBar
//
//  Created by William Vabrinskas on 4/16/25.
//

import SwiftUI

@main
struct ProteinBarApp: App {
  @Environment(\.rootModule) var rootModule
  
  var body: some Scene {
    WindowGroup {
      rootModule
        .routeToRootView()
        .asAnyView()
    }
  }
}
