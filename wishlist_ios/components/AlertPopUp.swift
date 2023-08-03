//
//  AlertPopUp.swift
//  wishlist_ios
//
//  Created by Julien on 02/08/2023.
//

import SwiftUI

struct AlertPopUp: View {
    let error: String
    @Binding var isAlertShown: Bool
    let dismissAction: () -> Void

    init(error: String, isAlertShown: Binding<Bool>, dismissAction: @escaping () -> Void = {}) {
        self.error = error
        _isAlertShown = isAlertShown
        self.dismissAction = dismissAction
    }

    var body: some View {
        VStack {}
            .alert(isPresented: $isAlertShown) {
                Alert(title: Text("error"), message: Text(error), dismissButton: .default(Text("ok"), action: dismissAction))
            }
    }
}
