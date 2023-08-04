//
//  AddWish.swift
//  wishlist_ios
//
//  Created by Julien on 03/08/2023.
//

import PhotosUI
import SwiftUI

struct AddWish: View {
    @Binding var path: NavigationPath
    @ObservedObject var error: AlertError

    @State private var token: String = ""

    var body: some View {
        WishForm(title: NSLocalizedString("add_wish_title", comment: "Add wish button"), buttonTitle: NSLocalizedString("add_wish", comment: "Add wish button"), action: { formData, boundary, isLoading in
            apiCall(method: .post, path: "wish", body: formData, boundary: boundary) { (result: ApiResponse<Wish>) in
                DispatchQueue.main.async {
                    switch result {
                    case let .failure(apiError):
                        error.message = apiError.message
                        error.status = apiError.status
                        error.isShown = true
                    case .success:
                        path.removeLast()
                    }
                    isLoading.wrappedValue = false
                }
            }
        })
    }
}
