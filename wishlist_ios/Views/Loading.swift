//
//  Loading.swift
//  wishlist_ios
//
//  Created by Julien on 02/08/2023.
//

import SwiftUI

struct Loading: View {
    @Binding var path: NavigationPath

    var body: some View {
        CircleLoader()
            .frame(width: 50, height: 50).foregroundColor(.blue)
            .onAppear {
                let token = UserDefaults.standard.string(forKey: Config().keys.token)

                if token == nil {
                    path.append("signIn")
                    return
                }

                apiCall(method: .get, path: "wish", body: nil) { (result: ApiResponse<[Wish]>) in
                    DispatchQueue.main.async {
                        switch result {
                        case .success:
                            path.append("wishlist")
                        case .failure:
                            path.append("signIn")
                        }
                    }
                }
            }
            .toolbar(.hidden)
    }
}
