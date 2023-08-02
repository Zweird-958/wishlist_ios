//
//  SignUp.swift
//  wishlist_ios
//
//  Created by Julien on 02/08/2023.
//

import SwiftUI

struct SignUp: View {
    @State private var error: String = ""
    @State private var showError: Bool = false
    @State private var valid: Bool = false

    var body: some View {
        NavigationStack {
            ZStack {
                AlertPopUp(error: error, isAlertShown: $showError)
                VStack {
                    UserForm(action: {
                        email, password, isLoading in
                        if isLoading.wrappedValue {
                            return
                        }

                        isLoading.wrappedValue = true
                        let bodyData = ["email": email, "password": password]
                        let jsonData = try! JSONSerialization.data(withJSONObject: bodyData)

                        apiCall(method: .post, path: "sign-up", body: jsonData) { (result: ApiResponse<String>) in

                            switch result {
                            case .success(_):
                                valid = true

                            case let .failure(apiError):
                                error = apiError
                                showError.toggle()
                                print(apiError)
                            }
                            isLoading.wrappedValue = false
                        }
                    }, title: "sign_up_title", buttonTitle: "sign_up")
                }
                .navigationDestination(isPresented: $valid) {
                    SignIn()
                }
                .navigationBarHidden(true)

                VStack {
                    Spacer()

                    HStack {
                        Text("already_register")
                        NavigationLink(destination: SignIn()) {
                            Text("login")
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
        }
    }

}

struct SignUp_Previews: PreviewProvider {
    static var previews: some View {
        SignUp()
    }
}
