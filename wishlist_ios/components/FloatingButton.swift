//
//  FloatingButton.swift
//  wishlist_ios
//
//  Created by Julien on 03/08/2023.
//

import SwiftUI

struct FloatingButton: View {
    let action: () -> Void

    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    self.action()
                }) {
                    Image(systemName: "plus")
                        .foregroundColor(.white)
                }
                .padding()
                .background(.blue)
                .clipShape(Circle())
                .shadow(radius: 5)
            }
        }
        .padding()
        .zIndex(2)
    }
}
