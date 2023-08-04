//
//  EditWish.swift
//  wishlist_ios
//
//  Created by Julien on 04/08/2023.
//

import SwiftUI

struct EditWish: View {
    let wish: Wish
    @Binding var path: NavigationPath
    @ObservedObject var error: AlertError

    var body: some View {
        WishForm(wish: wish, title: NSLocalizedString("edit_wish_title", comment: "Edit wish button"), buttonTitle: NSLocalizedString("edit_wish", comment: "Edit wish button"), action: { formData, boundary, isLoading in
            apiCall(method: .patch, path: "wish/\(wish.id)", body: formData, boundary: boundary) { (result: ApiResponse<Wish>) in
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
