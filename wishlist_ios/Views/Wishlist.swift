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
    @State private var isPressing: Bool = false
    @State private var isLoading: Bool = true

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

            if isLoading {
                ProgressView()
            } else {
                List {
                    ForEach(wishlist, id: \.id) { wish in
                        WishCard(wish: wish, onTapGesture: { path.append(wish) }, onSuccess: { wishDeleted in
                            wishlist = wishlist.filter { wishFilter in
                                wishFilter.id != wishDeleted.id
                            }
                        }, error: error)
                            .onLongPressGesture(minimumDuration: 1, perform: {
                                selectedWish = wish
                            })
                    }
                    .listRowInsets(EdgeInsets())
                }
                .refreshable {
                    fetchWishlist()
                }
            }
        }
        .onAppear {
            fetchWishlist()
            isLoading = false
        }
        .sheet(item: $selectedWish, onDismiss: { selectedWish = nil }) { _ in
            VStack {
                Text(selectedWish?.name ?? "")
                Text(selectedWish?.priceFormatted ?? "").padding(.all, 4)
                WishImage(image: selectedWish?.image).frame(height: 300)
                BuyButton(link: selectedWish?.link)
            }
            .presentationDetents([.medium, .large])
        }
    }
}
