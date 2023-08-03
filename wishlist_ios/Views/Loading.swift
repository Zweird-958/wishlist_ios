//
//  Loading.swift
//  wishlist_ios
//
//  Created by Julien on 02/08/2023.
//

import SwiftUI

struct Loading: View {
    @State private var isError = false
    @State private var isSuccess = false
    @State private var isAnimating = false

    var body: some View {
        VStack {
            NavigationStack {
                CircleLoader()
                    .frame(width: 50, height: 50).foregroundColor(.blue)
                    .onAppear {
                        let token = UserDefaults.standard.string(forKey: Config().keys.token)

                        if token == nil {
                            isError = true
                            return
                        }

                        apiCall(method: .get, path: "wish", body: nil) { (result: ApiResponse<[Wish]>) in

                            switch result {
                            case .success:

                                isSuccess = true
                            case .failure:
                                isError = true
                            }
                        }
                    }
                    .navigationDestination(isPresented: $isSuccess) {
                        Wishlist()
                    }
                    .navigationDestination(isPresented: $isError) {
                        SignIn()
                    }
            }
        }
    }
}

struct Loading_Previews: PreviewProvider {
    static var previews: some View {
        Loading()
    }
}
