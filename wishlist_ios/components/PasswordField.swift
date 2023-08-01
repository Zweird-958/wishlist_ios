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

    var body: some View {
        SecureField(placeholder, text: $text)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(.horizontal, 20)
            .padding(.bottom, 10)
            .autocapitalization(.none)
    }
}
