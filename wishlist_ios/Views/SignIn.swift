//
//  ContentView.swift
//  wishlist_ios
//
//  Created by Julien on 01/08/2023.
//

import SwiftUI

struct SignIn: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isLoading: Bool = false
    @State private var error: String = ""
    @State private var showError: Bool = false
    @State private var valid: Bool = false

    var body: some View {
        NavigationStack {
            VStack {
                VStack {
                    Text("Sign In")
                        .bold()
                        .font(.system(.title, design: .monospaced))
                        .foregroundColor(.blue)
                    FormField(text: $email, placeholder: "Email")
                    PasswordField(text: $password, placeholder: "Password")
                }
                .padding()

                Button(action: {
                    if isLoading {
                        return
                    }

                    isLoading = true
                    let bodyData = ["email": email, "password": password]
                    let jsonData = try! JSONSerialization.data(withJSONObject: bodyData)

                    apiCall(method: .post, path: "sign-in", body: jsonData) { (result: ApiResponse<String>) in

                        switch result {
                        case let .success(apiResponse):
                            UserDefaults.standard.set(apiResponse, forKey: Config().keys.token)
                            valid = true

                        case let .failure(apiError):
                            error = apiError
                            showError.toggle()
                            print(apiError)
                        }
                        isLoading = false
                    }
                }) {
                    HStack(spacing: 8) {
                        if isLoading {
                            CircleLoader()
                                .frame(width: 20, height: 20).foregroundColor(.white)
                        }
                        Text("Sign In")
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 40)
                    .padding(.vertical, 10)
                    .background(Color.blue)
                    .cornerRadius(8)
                }
            }
            .navigationDestination(isPresented: $valid) {
                Wishlist()
            }
            .navigationBarHidden(true)
            .alert(isPresented: $showError) {
                Alert(title: Text("Error"), message: Text(error), dismissButton: .default(Text("Ok")))
            }
        }
    }
}

struct SignIn_Previews: PreviewProvider {
    static var previews: some View {
        SignIn()
    }
}
