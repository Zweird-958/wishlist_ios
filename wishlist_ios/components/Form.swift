//
//  Form.swift
//  wishlist_ios
//
//  Created by Julien on 02/08/2023.
//

import SwiftUI

struct Form<Content: View>: View {
    let title: String
    let children: Content

    init(title: String, @ViewBuilder children: () -> Content) {
        self.title = title
        self.children = children()
    }

    var body: some View {
        VStack {
            Text(title)
                .bold()
                .font(.system(.title, design: .monospaced))
                .foregroundColor(.blue)

            children
        }
    }
}
