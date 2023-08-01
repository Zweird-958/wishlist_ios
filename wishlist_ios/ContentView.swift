//
//  ContentView.swift
//  wishlist_ios
//
//  Created by Julien on 01/08/2023.
//

import SwiftUI

struct ContentView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isLoading: Bool = false

    var body: some View {
        VStack {
            VStack {
                Text("Sign In")
                    .bold()
                    .font(.system(.title, design: .monospaced))
                    .foregroundColor(.blue)
                FormField(text: $email, placeholder: "Email")
                PasswordField(text: $password, placeholder: "Password")
            }.padding()
            Button(action: {
                if isLoading {
                    return
                }
                
                isLoading = true
                let bodyData = ["email": email, "password": password]
                let jsonData = try! JSONSerialization.data(withJSONObject: bodyData)

                sendPostRequest(method: .post, path: "sign-in", body: jsonData) { (result: ApiResponse<String>) in
                    switch result {
                    case let .success(apiResponse):
                        print(apiResponse)
                    case let .failure(apiError):
                        print(apiError)
                    }
                    isLoading = false
                }
            }) {
                HStack(spacing: 8) {
                    if isLoading {
                        CircleLoader()
                            .frame(width: 20, height: 20)
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
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
