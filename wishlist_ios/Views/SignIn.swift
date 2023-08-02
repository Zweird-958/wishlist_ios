//
//  ContentView.swift
//  wishlist_ios
//
//  Created by Julien on 01/08/2023.
//

import SwiftUI

struct SignIn: View {
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
                            isLoading.wrappedValue = false
                        }
                    }, title: "sign_in_title", buttonTitle: "sign_in")
                }
                .navigationDestination(isPresented: $valid) {
                    Wishlist()
                }
                .navigationBarHidden(true)

                VStack {
                    Spacer()

                    HStack {
                        Text("new_account")
                        NavigationLink(destination: SignUp()) {
                            Text("register")
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
        }
    }
}

struct SignIn_Previews: PreviewProvider {
    static var previews: some View {
        SignIn()
    }
}
