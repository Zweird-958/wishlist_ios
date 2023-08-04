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

struct TabItem {
    let label: String
    let icon: String
}

struct Navigation: View {
    @State private var path = NavigationPath(["loading"])
    @ObservedObject var alertError = AlertError()

    @State private var selectedTab: Tab = .wishlist

    enum Tab {
        case wishlist
        case profile

        var label: String {
            switch self {
            case .wishlist:
                return "wishlist_title"

            case .profile:
                return "profile"
            }
        }

        var icon: String {
            switch self {
            case .wishlist:
                return "heart.fill"

            case .profile:
                return "person.crop.circle"
            }
        }
    }

    var body: some View {
        NavigationStack(path: $path) {
            HandleErrors(error: alertError, path: $path)
                .toolbar(.hidden)
                .navigationDestination(for: Wish.self) { wish in
                    EditWish(wish: wish, path: $path, error: alertError)
                }
                .navigationDestination(for: String.self) { view in
                    switch view {
                    case "signIn":
                        SignIn(path: $path, error: alertError)
                    case "wishlist":
                        TabView(selection: $selectedTab) {
                            Wishlist(path: $path, error: alertError)
                                .tabItem {
                                    Label(NSLocalizedString(Tab.wishlist.label,comment: "Wishlist label"), systemImage: Tab.wishlist.icon)
                                }
                                .tag(Tab.wishlist)

                            Text("Profile Page")
                                .tabItem {
                                    Label(NSLocalizedString(Tab.profile.label,comment: "Profile label"), systemImage: Tab.profile.icon)
                                }
                                .tag(Tab.profile)
                        }
                        .navigationBarBackButtonHidden(true)
                        .navigationTitle(NSLocalizedString(selectedTab.label,comment: "Selected Label"))
                    case "addWish":
                        AddWish(path: $path, error: alertError)
                    case "loading":
                        Loading(path: $path)
                    default:
                        Text("error").toolbar(.hidden)
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
