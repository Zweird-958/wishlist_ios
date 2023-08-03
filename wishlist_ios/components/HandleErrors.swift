//
//  HandleErrors.swift
//  wishlist_ios
//
//  Created by Julien on 03/08/2023.
//

import SwiftUI

struct HandleErrors: View {
    @Binding var isAlertShow: Bool
    @Binding var error: ApiError
    @State private var is403: Bool = false

    var body: some View {
        NavigationStack {
            AlertPopUp(error: error.message, isAlertShown: $isAlertShow, dismissAction: {
                if (error.status) == 403 {
                    is403 = true
                }
            })
        }
        .navigationDestination(isPresented: $is403) {
            SignIn()
        }
    }
}
