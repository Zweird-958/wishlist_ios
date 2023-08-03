//
//  Wish.swift
//  wishlist_ios
//
//  Created by Julien on 02/08/2023.
//

import Foundation

struct Wish: Decodable, Identifiable {
    let id: Int
    let name: String
    let image: String?
    let link: String?
    let price: Float
    let currency: String
    let userId: Int
    let purchased: Bool
    let createdAt: String
    let priceFormatted: String
}
