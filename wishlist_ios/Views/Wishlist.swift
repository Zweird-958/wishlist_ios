//
//  Wishlist.swift
//  wishlist_ios
//
//  Created by Julien on 02/08/2023.
//

import SwiftUI

let filters = ["all", "plural_purchased", "not_purchased"]
let sorts = ["date", "ascending_price", "descending_price"]

struct Wishlist: View {
    @State private var wishlist: [Wish] = []
    @State private var wishlistFilter: [Wish] = []
    @State private var selectedWish: Wish? = nil
    @State private var isPressing: Bool = false
    @State private var isLoading: Bool = true
    @State private var selectedFilter: String = filters[0]
    @State private var selectedSort: String = sorts[0]

    @Binding var path: NavigationPath
    @ObservedObject var error: AlertError

    func sortWishlist() {
        switch selectedSort {
        case sorts[1]:
            wishlistFilter.sort { $0.price < $1.price }
        case filters[2]:
            wishlistFilter.sort { $0.price > $1.price }
        default:
            wishlistFilter.sort { $0.createdAt < $1.createdAt }
        }
    }

    func filterWishlist() {
        switch selectedFilter {
        case filters[1]:
            wishlistFilter = wishlist.filter { wish in wish.purchased }
        case filters[2]:
            wishlistFilter = wishlist.filter { wish in !wish.purchased }
        default:
            wishlistFilter = wishlist
        }
    }

    func fetchWishlist() {
        apiCall(method: .get, path: "wish", body: nil) { (result: ApiResponse<[Wish]>) in
            DispatchQueue.main.async {
                switch result {
                case let .success(apiResult):
                    wishlist = apiResult
                    filterWishlist()
                    sortWishlist()

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
                    Section("options") {
                        Picker("sort", selection: $selectedSort) {
                            ForEach(sorts, id: \.self) { sort in
                                Text(NSLocalizedString(sort, comment: "Sort"))
                            }
                        }.onChange(of: selectedSort) { _ in
                            sortWishlist()
                        }

                        Picker("filter", selection: $selectedFilter) {
                            ForEach(filters, id: \.self) { filter in
                                Text(NSLocalizedString(filter, comment: "Filter"))
                            }
                        }.onChange(of: selectedFilter) { _ in
                            filterWishlist()
                        }
                    }

                    Section {
                        ForEach(wishlistFilter, id: \.id) { wish in
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
        .sheet(item: $selectedWish, onDismiss: { selectedWish = nil }) { wish in
            VStack {
                Text(wish.name)
                Text(wish.priceFormatted).padding(.all, 4)
                WishImage(image: wish.image).frame(height: 300)
                BuyButton(link: wish.link)
            }
            .presentationDetents([.medium, .large])
        }
    }
}
