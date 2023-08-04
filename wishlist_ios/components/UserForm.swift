//
//  UserForm.swift
//  wishlist_ios
//
//  Created by Julien on 02/08/2023.
//

import Combine
import SwiftUI

struct UserForm: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isLoading: Bool = false
    let action: (String, String, Binding<Bool>) -> Void
    let title: String
    let buttonTitle: String

    @ObservedObject var userValidation = UserValidation()
    @State private var isDisabled: Bool = true

    var body: some View {
        Form(title: NSLocalizedString(title, comment: "Form Title")) {
            FormField(text: $email, placeholder: NSLocalizedString("email", comment: "Email Placeholder"), error: $userValidation.emailError)
                .onChange(of: email) { _ in
                    userValidation.emailIsValid(email: email)
                }
            PasswordField(text: $password, placeholder: NSLocalizedString("password", comment: "Password Placeholder"), error: $userValidation.passwordError)
                .onChange(of: password) { _ in
                    userValidation.passwordIsValid(password: password)
                }

            LoaderButton(title: NSLocalizedString(buttonTitle, comment: "Sign in Button Title"), action: {
                if !userValidation.formIsValid(email: email, password: password) {
                    return
                }

                action(email, password, $isLoading)
            }, isLoading: $isLoading)
        }
    }
}
