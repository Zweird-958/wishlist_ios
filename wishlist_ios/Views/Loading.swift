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
                        apiCall(method: .get, path: "wish", body: nil) { (result: ApiResponse<[Wish]>) in

                            switch result {
                            case let .success(apiResult):
                                isSuccess = true
                            case let .failure(apiError):
                                print(apiError.message)
                                isError = true
                            }
                        }
                    }.navigationDestination(isPresented: $isSuccess) {
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
