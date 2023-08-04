//
//  EditWish.swift
//  wishlist_ios
//
//  Created by Julien on 04/08/2023.
//

import SwiftUI

struct EditWish: View {
    @State private var showError: Bool = false
    @State private var error: ApiError = .init(message: "")
    @State private var isSuccess: Bool = false

    let wish: Wish

    var body: some View {
        NavigationStack {
            ZStack {
                HandleErrors(isAlertShow: $showError, error: $error)

                WishForm(wish: wish, title: NSLocalizedString("edit_wish_title", comment: "Edit wish button"), buttonTitle: NSLocalizedString("edit_wish", comment: "Edit wish button"), action: { formData, boundary, isLoading in
                    apiCall(method: .patch, path: "wish/\(wish.id)", body: formData, boundary: boundary) { (result: ApiResponse<Wish>) in

                        switch result {
                        case let .failure(apiError):
                            error = apiError
                            showError = true
                        case let .success(apiResult):
                            print(apiResult)
                            isSuccess = true
                        }
                        isLoading.wrappedValue = false
                    }
                })

                .navigationDestination(isPresented: $isSuccess) {
                    Wishlist()
                }
            }
        }
    }
}
