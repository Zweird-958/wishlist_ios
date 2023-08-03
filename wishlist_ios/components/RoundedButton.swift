//
//  RoundedButton.swift
//  wishlist_ios
//
//  Created by Julien on 03/08/2023.
//

import SwiftUI

struct RoundedButton<Content: View>: View {
    let action: () -> Void
    let children: Content

    init(action: @escaping () -> Void, @ViewBuilder children: () -> Content) {
        self.action = action
        self.children = children()
    }

    var body: some View {
        Button(action: action) {
            children
        }

        .foregroundColor(.white)
        .padding(.horizontal, 20)
        .padding(.vertical, 3)
        .background(.blue)
        .cornerRadius(8)
        .buttonStyle(PlainButtonStyle())
    }
}
