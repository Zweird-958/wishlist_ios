//
//  ContentView.swift
//  wishlist_ios
//
//  Created by Julien on 01/08/2023.
//

import SwiftUI

struct SignIn: View {
    @Binding var path: NavigationPath
    @ObservedObject var error: AlertError

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

                    apiCall(method: .post, path: "sign-in", body: jsonData) { (result: ApiResponse<String>) in
                        DispatchQueue.main.async {
                            switch result {
                            case let .success(apiResponse):
                                UserDefaults.standard.set(apiResponse, forKey: Config().keys.token)
                                path.append("wishlist")

                            case let .failure(apiError):
                                error.message = apiError.message
                                error.status = apiError.status
                                error.isShown = true
                            }
                            isLoading.wrappedValue = false
                        }
                    }
                }, title: "sign_in_title", buttonTitle: "sign_in")
            }

            VStack {
                Spacer()

                HStack {
                    Text("new_account")
                    NavigationLink(destination: SignUp(path: $path, error: error)) {
                        Text("register")
                            .foregroundColor(.blue)
                    }
                }
            }
        }.navigationBarHidden(true)
    }
}
