//
//  UserForm.swift
//  wishlist_ios
//
//  Created by Julien on 02/08/2023.
//

import SwiftUI

struct UserForm: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isLoading: Bool = false
    let action: (String, String, Binding<Bool>) -> Void
    let title: String
    let buttonTitle: String
    
    var body: some View {
        Form(title: NSLocalizedString(title, comment: "Form Title")) {
            FormField(text: $email, placeholder: NSLocalizedString("email", comment: "Email Placeholder"))
            PasswordField(text: $password, placeholder: NSLocalizedString("password", comment: "Password Placeholder"))

            LoaderButton(title: NSLocalizedString(buttonTitle, comment: "Sign in Button Title"), action: {
                action(email, password, $isLoading)
            }, isLoading: $isLoading)
        }
    }
}
