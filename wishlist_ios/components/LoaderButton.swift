//
//  LoaderButton.swift
//  wishlist_ios
//
//  Created by Julien on 02/08/2023.
//

import SwiftUI

struct LoaderButton: View {
    let title: String
    let action: () -> Void
    @Binding var isLoading: Bool

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if isLoading {
                    CircleLoader()
                        .frame(width: 20, height: 20).foregroundColor(.white)
                }
                Text(title)
            }
            .foregroundColor(.white)
            .padding(.horizontal, 40)
            .padding(.vertical, 10)
            .background(Color.blue)
            .cornerRadius(8)
        }
    }
}
