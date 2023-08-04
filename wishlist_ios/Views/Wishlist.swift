//
//  Wishlist.swift
//  wishlist_ios
//
//  Created by Julien on 02/08/2023.
//

import SwiftUI

struct Wishlist: View {
    @State private var wishlist: [Wish] = []

    @State private var selectedWish: Wish? = nil
    @State private var wishIsSelected: Bool = false

    @Binding var path: NavigationPath
    @ObservedObject var error: AlertError

    func fetchWishlist() {
        apiCall(method: .get, path: "wish", body: nil) { (result: ApiResponse<[Wish]>) in
            DispatchQueue.main.async {
                switch result {
                case let .success(apiResult):
                    wishlist = apiResult

                case let .failure(apiError):
                    error.message = apiError.message
                    error.status = apiError.status
                    error.isShown = true
                }
            }
        }
    }

    var body: some View {
        ZStack {
            FloatingButton(action: {
                path.append("addWish")
            })

            List {
                ForEach(wishlist, id: \.id) { wish in
                    WishCard(wish: wish, onTapGesture: { path.append(wish) }, onSuccess: { wishDeleted in
                        wishlist = wishlist.filter { wishFilter in
                            wishFilter.id != wishDeleted.id
                        }
                    }, error: error)
                }
                .listRowInsets(EdgeInsets())
            }
            .refreshable {
                fetchWishlist()
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationTitle("wishlist_title")

        .onAppear {
            fetchWishlist()
        }
    }
}
