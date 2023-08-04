//
//  WishImage.swift
//  wishlist_ios
//
//  Created by Julien on 03/08/2023.
//

import SwiftUI

struct WishImage: View {
    let image: String?

    var body: some View {
        ZStack {
            if image?.isEmpty == false {
                AsyncImage(url: URL(string: image ?? "")) { image in
                    image.resizable()

                } placeholder: {
                    ProgressView()
                }
                .zIndex(2)
                .padding(.all, 10)
                .aspectRatio(contentMode: .fit)
                .edgesIgnoringSafeArea(.all)
                .clipped()

                AsyncImage(url: URL(string: image ?? "")) { image in
                    image.resizable().blur(radius: 10)
                } placeholder: {
                    ProgressView()
                }
                .zIndex(1)
                .edgesIgnoringSafeArea(.all)
                .clipped()

            } else {
                Image(systemName: "multiply")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.red).zIndex(2)
                    .padding(.all, 30)

                Image(systemName: "multiply")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.red).zIndex(2)
                    .padding(.all, 10)
                    .blur(radius: 20)
            }
        }
        .padding(.all, 6)
        .edgesIgnoringSafeArea(.all)
    }
}
