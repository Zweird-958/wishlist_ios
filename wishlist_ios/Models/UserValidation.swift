//
//  UserValidation.swift
//  wishlist_ios
//
//  Created by Julien on 04/08/2023.
//

import Foundation

class UserValidation: ObservableObject {
    @Published var emailError: String = ""
    @Published var passwordError: String = ""

    func formIsValid(email: String, password: String) -> Bool {
        let emailValidity = emailIsValid(email: email)
        let passwordValidity = passwordIsValid(password: password)
        return emailValidity && passwordValidity
    }

    func emailIsValid(email: String) -> Bool {
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

    func passwordIsValid(password: String) -> Bool {
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
