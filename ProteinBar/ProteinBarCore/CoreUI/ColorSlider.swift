//
//  ColorSlider.swift
//  ProteinBar
//
//  Created by William Vabrinskas on 4/18/25.
//

import SwiftUI

struct ColorSlider: View {
  @Environment(\.theme) var theme
  
  @Binding var value: Double
  let range: ClosedRange<Double>
  let trackColor: Color
  let progressColor: Color
  let thumbColor: Color
  let height: CGFloat
  let showsButtons: Bool
  let onEnded: (() -> Void)?
  
  init(value: Binding<Int>,
       range: ClosedRange<Int>,
       trackColor: Color,
       progressColor: Color,
       thumbColor: Color,
       height: CGFloat = 60,
       showsButtons: Bool = false,
       onEnded: (() -> Void)? = nil) {
    self._value = .init(get: {
      Double(value.wrappedValue)
    }, set: { newValue in
      value.wrappedValue = Int(newValue)
    })
    self.range = Double(range.lowerBound)...Double(range.upperBound)
    self.trackColor = trackColor
    self.progressColor = progressColor
    self.thumbColor = thumbColor
    self.height = height
    self.showsButtons = showsButtons
    self.onEnded = onEnded
  }
  
  private let thumbWidth: CGFloat = 22
  private let cornerRadius: CGFloat = 10
  @State private var timer: Timer?
  
  var body: some View {
    HStack {
      ProteinBarButton(viewModel: .circle(image: Image(systemName: "minus"),
                                          size: 16,
                                          buttonSize: height,
                                          backgroundColor: trackColor,
                                          foregroundColor: progressColor,
                                          enabled: true)) {
        subtractValue()
      }
                                          .padding(.top, 10)
                                          .sensoryFeedback(.decrease, trigger: value)
      
      GeometryReader { geometry in
        
        // Track
        ZStack(alignment: .leading) {
          RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .fill(trackColor)
            .frame(height: height)
            .depth(foregroundColor: .clear, cornerRadius: cornerRadius)
          
          // Progress
          RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .fill(progressColor)
            .frame(width: CGFloat(((value - range.lowerBound) / (range.upperBound - range.lowerBound))) * geometry.size.width,
                   height: height)
            .depth(foregroundColor: .clear, cornerRadius: cornerRadius)
          
          // Thumb
          RoundedRectangle(cornerRadius: 10, style: .continuous)
            .fill(thumbColor.mix(with: .white, by: 0.2))
            .frame(width: thumbWidth, height: height + 10)
            .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
            .offset(x: CGFloat((value - range.lowerBound) / (range.upperBound - range.lowerBound)) * (geometry.size.width - thumbWidth))
            .gesture(
              DragGesture()
                .onChanged { gesture in
                  let percent = min(max(0, gesture.location.x / (geometry.size.width - thumbWidth)), 1)
                  withAnimation(.easeOut(duration: 0.35)) {
                    self.value = range.lowerBound + Double(percent) * (range.upperBound - range.lowerBound)
                  }
                }
                .onEnded({ _ in
                  onEnded?()
                })
            )
        }
        
      }
      
      ProteinBarButton(viewModel: .circle(image: Image(systemName: "plus"),
                                          size: 16,
                                          buttonSize: height,
                                          backgroundColor: trackColor,
                                          foregroundColor: progressColor,
                                          enabled: true)) {
        addValue()
      }
                                          .padding(.top, 10)
                                          .sensoryFeedback(.increase, trigger: value)
      
    }
    .frame(height: height)
  }
  
  private func addValue() {
    withAnimation(.easeOut(duration: 0.35)) {
      let newValue = value + 1
      value = max(range.lowerBound, min(range.upperBound, newValue))
    }
  }
  
  private func subtractValue() {
    withAnimation(.easeOut(duration: 0.35)) {
      let newValue = value - 1
      value = max(range.lowerBound, min(range.upperBound, newValue))
    }
  }
}

extension Int {
  var asDouble: Double {
    Double(self)
  }
}

struct ColorSlider_Previews: PreviewProvider {
  static var previews: some View {
    ColorSlider(value: .constant(50), range: 0...100, trackColor: .app(.primaryAppColor),
                progressColor: .app(.secondaryAppColor),
                thumbColor: .app(.secondaryAppColor),
                height: 40)
    .preview()
  }
}
