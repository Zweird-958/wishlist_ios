//
//  SignUp.swift
//  wishlist_ios
//
//  Created by Julien on 02/08/2023.
//

import SwiftUI

struct SignUp: View {
    @Binding var path: NavigationPath
    @ObservedObject var error: AlertError
    @State private var redirectToSignIn: Bool = false

    var body: some View {
        ZStack {
            VStack {
                UserForm(action: {
                    email, password, isLoading in
                    if isLoading.wrappedValue {
                        return
                    }

                    isLoading.wrappedValue = true
                    let bodyData = ["email": email, "password": password]
                    let jsonData = try! JSONSerialization.data(withJSONObject: bodyData)

                    apiCall(method: .post, path: "sign-up", body: jsonData) { (_: ApiResponse<String>) in
                        DispatchQueue.main.async {
                            redirectToSignIn = true
                            isLoading.wrappedValue = false
                        }
                    }
                }, title: "sign_up_title", buttonTitle: "sign_up")
            }

            VStack {
                Spacer()

                HStack {
                    Text("already_register")
                    NavigationLink(destination: SignIn(path: $path, error: error)) {
                        Text("login")
                            .foregroundColor(.blue)
                    }
                }
            }
        }
        .toolbar(.hidden)
        .navigationDestination(isPresented: $redirectToSignIn) {
            SignIn(path: $path, error: error)
        }
    }
}
