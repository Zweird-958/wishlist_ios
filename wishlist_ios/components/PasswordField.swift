//
//  PasswordField.swift
//  wishlist_ios
//
//  Created by Julien on 01/08/2023.
//

import SwiftUI

struct PasswordField: View {
    @Binding var text: String
    let placeholder: String
    @Binding var error: String

    var body: some View {
        VStack {
            SecureField(placeholder, text: $text)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(error.isEmpty ? .gray.opacity(0.1) : .red.opacity(0.5), lineWidth: 2)
                )
                .accentColor(error.isEmpty ? .blue : .red)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)

            if !error.isEmpty {
                Text(error).foregroundColor(.red).frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 10)
    }
}
