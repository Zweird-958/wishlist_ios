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
    @State private var isPurchased: Bool = false

    @ObservedObject var wishValidation = WishValidation()
    @ObservedObject var error: AlertError

    @State private var isLoading: Bool = false
    @State private var isSuccess: Bool = false

    let action: (Data, String, Binding<Bool>) -> Void
    let wish: Wish?
    let title: String
    let buttonTitle: String

    init(wish: Wish? = nil, title: String, buttonTitle: String, error: AlertError, action: @escaping (Data, String, Binding<Bool>) -> Void = { _, _, _ in }) {
        self.action = action
        self.wish = wish
        self.title = title
        self.buttonTitle = buttonTitle
        self.error = error

        if wish != nil {
            if let unwrappedStr = wish?.name {
                name = unwrappedStr
            }

            if let unwrappedPrice = wish?.price {
                _price = State(initialValue: String(describing: unwrappedPrice))
            }

            _name = State(initialValue: wish?.name ?? "")
            _link = State(initialValue: wish?.link ?? "")
            _isPurchased = State(initialValue: wish?.purchased ?? false)
        }
    }

    var body: some View {
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
                Text(wish?.image == nil && selectedImageData == nil ? "select_photo" : "change_image")
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
                ZStack {
                    Image(uiImage: uiImage)
                        .resizable()
                        .zIndex(2)
                        .padding(.all, 10)
                        .aspectRatio(contentMode: .fit)
                        .edgesIgnoringSafeArea(.all)
                        .clipped()

                    Image(uiImage: uiImage)
                        .resizable()
                        .blur(radius: 10)
                        .zIndex(1)
                        .edgesIgnoringSafeArea(.all)
                        .clipped()
                }
                .frame(width: 150, height: 150)
                .padding(.all, 6)
                .edgesIgnoringSafeArea(.all)

            } else if wish?.image != nil {
                WishImage(image: wish?.image).frame(width: 150, height: 150)
            }

            if wish != nil {
                Toggle("purchased", isOn: $isPurchased).padding(.horizontal, 20).toggleStyle(SwitchToggleStyle(tint: .blue))
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
                    "image": selectedImageData != nil ? UIImage(data: selectedImageData!) : wish?.image,
                    "purchased": isPurchased,
                ] as [String: Any]

                let boundary = "Boundary-\(UUID().uuidString)"
                let formData = createFormData(parameters: parameters, boundary: boundary)

                action(formData, boundary, $isLoading)
            }, isLoading: $isLoading)

        }.onAppear {
            apiCall(method: .get, path: "currency", body: nil) { (result: ApiResponse<[String]>) in
                DispatchQueue.main.async {
                    switch result {
                    case let .success(apiResult):
                        currencies = apiResult
                        selectedCurrency = wish?.currency ?? currencies[0]

                    case let .failure(apiError):
                        error.message = apiError.message
                        error.status = apiError.status
                        error.isShown = true
                    }
                }
            }
        }
    }
}
