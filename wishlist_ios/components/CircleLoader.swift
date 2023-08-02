//
//  CircleLoader.swift
//  wishlist_ios
//
//  Created by Julien on 02/08/2023.
//

import SwiftUI

struct CircleLoader: View {
    @State private var isAnimating = false

    var body: some View {
        Circle()
            .trim(from: 0.0, to: 0.7)
            .stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
            .rotationEffect(Angle(degrees: isAnimating ? 360 : 0))
            .onAppear {
                withAnimation(Animation.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                    self.isAnimating = true
                }
            }
    }
}

struct CircleLoader_Previews: PreviewProvider {
    static var previews: some View {
        CircleLoader()
    }
}
