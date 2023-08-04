//
//  HandleErrors.swift
//  wishlist_ios
//
//  Created by Julien on 03/08/2023.
//

import SwiftUI

struct HandleErrors: View {
    @ObservedObject var error: AlertError
    @State private var is403: Bool = false

    @Binding var path: NavigationPath

    var body: some View {
        AlertPopUp(error: error.message, isAlertShown: $error.isShown, dismissAction: {
            if error.status == 403 {
                path = NavigationPath(["signIn"])
            }
        })
    }
}
