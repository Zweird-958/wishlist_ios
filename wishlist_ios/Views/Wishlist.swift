//
//  Wishlist.swift
//  wishlist_ios
//
//  Created by Julien on 02/08/2023.
//

import SwiftUI

struct Wishlist: View {
    @State private var wishlist: [Wish] = []
    @State private var error: String = ""
    @State private var showError: Bool = false
    
    func fetchWishlist(){
        apiCall(method: .get, path: "wish", body: nil) { (result: ApiResponse<[Wish]>) in

            switch result {
            case let .success(apiResult):
                wishlist = apiResult

            case let .failure(apiError):
                error = apiError.message
                showError = true
            }
        }
    }

    var body: some View {
        NavigationStack {
            AlertPopUp(error: error, isAlertShown: $showError)
            List(wishlist) { wish in
                HStack {
                    WishImage(image: wish.image)

                    VStack(alignment: .leading, spacing: 8) {
                        Text(wish.name)
                            .lineLimit(1)
                        Text(wish.priceFormatted)
                            .font(.subheadline)
                        if wish.link != nil {
                            RoundedButton(action: {
                                guard let url = URL(string: wish.link!) else { return }
                                UIApplication.shared.open(url)
                            }) {
                                Text("buy")
                            }
                        } else {
                            Rectangle().opacity(0)
                        }
                    }
                    .frame(height: 80, alignment: .leading)
                    .padding(.horizontal)

                    Spacer()

                    Image(systemName: "chevron.right")
                        .foregroundColor(.blue)
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    print("clicked \(wish.id)")
                }
                .padding(.all, 5)
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

struct Wishlist_Previews: PreviewProvider {
    static var previews: some View {
        Wishlist()
    }
}
