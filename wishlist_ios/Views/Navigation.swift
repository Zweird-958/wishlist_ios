//
//  Navigation.swift
//  wishlist_ios
//
//  Created by Julien on 04/08/2023.
//

import SwiftUI

class AlertError: ObservableObject {
    @Published var message: String = ""
    @Published var isShown: Bool = false
    @Published var status: Int?
}

struct Navigation: View {
    @State private var path = NavigationPath(["loading"])
    @ObservedObject var alertError = AlertError()

    var body: some View {
        NavigationStack(path: $path) {
            HandleErrors(error: alertError, path: $path)
                .navigationBarHidden(true)
                .navigationDestination(for: Wish.self) { wish in
                    EditWish(wish: wish, path: $path, error: alertError)
                }
                .navigationDestination(for: String.self) { view in
                    switch view {
                    case "signIn":
                        SignIn(path: $path, error: alertError)
                    case "wishlist":
                        Wishlist(path: $path, error: alertError)
                    case "addWish":
                        AddWish(path: $path, error: alertError)
                    case "loading":
                        Loading(path: $path)
                    default:
                        Text("error").navigationBarHidden(true)
                    }
                }
        }
    }
}

struct Navigation_Previews: PreviewProvider {
    static var previews: some View {
        Navigation()
    }
}
