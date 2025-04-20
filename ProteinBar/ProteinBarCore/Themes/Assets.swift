//
//  Assets.swift
//  Huddle
//
//  Created by William Vabrinskas on 12/25/23.
//

import Foundation
import SwiftUI

public protocol Images: AnyObject {
  subscript(dynamicMember member: String) -> Image? { get }
}

public protocol Assets {
  associatedtype I: Images
  var images: I { get }
}

@dynamicMemberLookup
public final class LaunchImages: Images, Sendable {
  public subscript(dynamicMember member: String) -> Image? {
    Image(member)
  }
}

public final class LaunchAssets: Assets, Sendable {
  public let images = LaunchImages()
}
