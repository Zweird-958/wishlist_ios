//
//  UserForm.swift
//  wishlist_ios
//
//  Created by Julien on 02/08/2023.
//

import Combine
import SwiftUI

class UserValidation: ObservableObject {
    @Published var emailError: String = ""
    @Published var passwordError: String = ""
    
    func formIsValid(email: String,password: String)-> Bool {
        let emailValidity = emailIsValid(email: email)
        let passwordValidity = passwordIsValid(password: password)
        return emailValidity && passwordValidity
    }

    func emailIsValid(email: String)-> Bool {
        emailError = ""
        if email.isEmpty {
            emailError = NSLocalizedString("email_required", comment: "Email Required Error")
            return false
        }

        let emailRegex = #"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)

        if !emailPredicate.evaluate(with: email) {
            emailError = NSLocalizedString("email_invalid", comment: "Email Invalid Format Error")
            return false
        }
        
        return true
    }

    func passwordIsValid(password: String)-> Bool {
        passwordError = ""

        if password.isEmpty {
            passwordError = NSLocalizedString("password_required", comment: "Password len required")
            return false
        }

        if password.count < 8 {
            passwordError = NSLocalizedString("password_len", comment: "Password len required")
            return false
        }
        
        return true
    }
}

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
