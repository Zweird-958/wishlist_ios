//
//  BuyButton.swift
//  wishlist_ios
//
//  Created by Julien on 05/08/2023.
//

import SwiftUI

struct BuyButton: View {
    let link: String?

    var body: some View {
        if link != nil {
            RoundedButton(action: {
                guard let url = URL(string: link!) else { return }
                UIApplication.shared.open(url)
            }) {
                Text("buy")
            }
        } else {
            Rectangle().opacity(0)
        }
    }
}
