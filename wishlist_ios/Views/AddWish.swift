//
//  AddWish.swift
//  wishlist_ios
//
//  Created by Julien on 03/08/2023.
//

import PhotosUI
import SwiftUI

struct AddWish: View {
    @State private var showError: Bool = false
    @State private var error: ApiError = .init(message: "")
    @State private var isSuccess: Bool = false

    var body: some View {
        NavigationStack {
            ZStack {
                HandleErrors(isAlertShow: $showError, error: $error)

                WishForm(title: NSLocalizedString("add_wish_title", comment: "Add wish button"), buttonTitle: NSLocalizedString("add_wish", comment: "Add wish button"), action: { formData, boundary, isLoading in
                    apiCall(method: .post, path: "wish", body: formData, boundary: boundary) { (result: ApiResponse<Wish>) in

                        switch result {
                        case let .failure(apiError):
                            error = apiError
                            showError = true
                        case .success:
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

struct AddWish_Previews: PreviewProvider {
    static var previews: some View {
        AddWish()
    }
}
