//
//  WishForm.swift
//  wishlist_ios
//
//  Created by Julien on 04/08/2023.
//

import PhotosUI
import SwiftUI

struct WishForm: View {
    @State private var name: String = ""
    @State private var price: String = ""
    @State private var link: String = ""

    @State private var selectedImageData: Data? = nil
    @State private var selectedItem: PhotosPickerItem? = nil

    @State private var selectedCurrency: String = ""
    @State private var currencies: [String] = []

    @State private var showError: Bool = false
    @State private var error: ApiError = .init(message: "")

    @ObservedObject var wishValidation = WishValidation()

    @State private var isLoading: Bool = false
    @State private var isSuccess: Bool = false

    let action: (Data, String, Binding<Bool>) -> Void
    let wish: Wish?
    let title: String
    let buttonTitle: String

    init(wish: Wish? = nil, title: String, buttonTitle: String, action: @escaping (Data, String, Binding<Bool>) -> Void = { _, _, _ in }) {
        self.action = action
        self.wish = wish
        self.title = title
        self.buttonTitle = buttonTitle

        if wish != nil {
            name = wish?.name ?? ""
            price = String(describing: wish?.price)
            link = wish?.link ?? ""
        }
    }

    var body: some View {
        NavigationStack {
            Form(title: title) {
                FormField(text: $name, placeholder: NSLocalizedString("name", comment: "Name Placeholder"), error: $wishValidation.nameError)
                    .onChange(of: name) { _ in
                        wishValidation.nameIsValid(name: name)
                    }
                FormField(text: $price, placeholder: NSLocalizedString("price", comment: "Price Placeholder"), error: $wishValidation.priceError)
                    .keyboardType(.decimalPad)
                    .onChange(of: price) { _ in
                        wishValidation.priceIsValid(price: price)
                    }

                FormField(text: $link, placeholder: NSLocalizedString("link", comment: "Link Placeholder"), error: $wishValidation.linkError)
                    .onChange(of: link) { _ in
                        wishValidation.linkIsValid(link: link)
                    }

                Picker("currency", selection: $selectedCurrency) {
                    ForEach(currencies, id: \.self) { currency in
                        Text(currency).tag(currency)
                    }
                }

                PhotosPicker(
                    selection: $selectedItem,
                    matching: .images,
                    photoLibrary: .shared()
                ) {
                    Text("select_photo")
                }
                .onChange(of: selectedItem) { newItem in
                    Task {
                        if let data = try? await newItem?.loadTransferable(type: Data.self) {
                            selectedImageData = data
                        }
                    }
                }

                if let selectedImageData,
                   let uiImage = UIImage(data: selectedImageData)
                {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 250, height: 250)
                }

                LoaderButton(title: buttonTitle, action: {
                    if isLoading || !wishValidation.formIsValid(name: name, price: price, link: link) {
                        return
                    }

                    isLoading = true

                    var parameters = [
                        "name": name,
                        "price": price,
                        "currency": selectedCurrency,
                        "link": link,
                        "image": selectedImageData != nil ? UIImage(data: selectedImageData!) : nil,
                    ] as [String: Any]

                    let boundary = "Boundary-\(UUID().uuidString)"
                    let formData = createFormData(parameters: parameters, boundary: boundary)

                    action(formData, boundary, $isLoading)
                }, isLoading: $isLoading)

            }.onAppear {
                apiCall(method: .get, path: "currency", body: nil) { (result: ApiResponse<[String]>) in

                    switch result {
                    case let .success(apiResult):
                        currencies = apiResult
                        selectedCurrency = currencies[0]

                    case let .failure(apiError):
                        error = apiError
                        showError = true
                    }
                }
            }
        }
    }
}
