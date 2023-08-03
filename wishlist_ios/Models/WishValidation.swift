//
//  WishValidation.swift
//  wishlist_ios
//
//  Created by Julien on 04/08/2023.
//

import Foundation
import UIKit

class WishValidation: ObservableObject {
    @Published var nameError: String = ""
    @Published var priceError: String = ""
    @Published var linkError: String = ""

    func formIsValid(name: String, price: String, link: String) -> Bool {
        let nameValidity = nameIsValid(name: name)
        let priceValidity = priceIsValid(price: price)
        let linkValidity = linkIsValid(link: link)

        return nameValidity && priceValidity && linkValidity
    }

    func nameIsValid(name: String) -> Bool {
        nameError = ""

        if name.isEmpty {
            nameError = NSLocalizedString("name_required", comment: "Name Required Error")
            return false
        }

        return true
    }

    func priceIsValid(price: String) -> Bool {
        priceError = ""

        if price.isEmpty {
            priceError = NSLocalizedString("price_required", comment: "Price Required Error")
            return false
        }

        if Double(price) == nil {
            if price.contains(",") {
                let priceFormatted = price.replacingOccurrences(of: ",", with: ".")
                return priceIsValid(price: priceFormatted)
            }
            priceError = NSLocalizedString("price_invalid", comment: "Price Invalid Format")
            return false
        }

        return true
    }

    func linkIsValid(link: String) -> Bool {
        linkError = ""

        if link.contains(" ") {
            linkError = NSLocalizedString("link_invalid", comment: "Link Invalid Format")
            return false
        }

        if let url = URL(string: link) {
            if !UIApplication.shared.canOpenURL(url) {
                linkError = NSLocalizedString("link_invalid", comment: "Link Invalid Format")
                return false
            }
        }

        return true
    }
}
