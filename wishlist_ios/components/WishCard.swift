//
//  WishCard.swift
//  wishlist_ios
//
//  Created by Julien on 04/08/2023.
//

import SwiftUI

struct WishCard: View {
    let wish: Wish
    let onTapGesture: () -> Void
    let onSuccess: (Wish) -> Void
    let error: AlertError

    @State private var isAlertShown: Bool = false
    @State private var offset: CGFloat = 0

    private let threshold: CGFloat = 100
    private let animationDuration = 0.3

    var body: some View {
        ZStack {
            HStack {
                Spacer()
                ZStack {
                    Rectangle()
                        .foregroundColor(.red)
                        .frame(width: threshold)
                    Image(systemName: "trash")
                        .foregroundColor(.white)
                }.onTapGesture {
                    isAlertShown = true
                    print("to delete")
                }
            }
            Rectangle()
                .foregroundColor(.white)
                .zIndex(2)
                .offset(x: offset)

            HStack {
                WishImage(image: wish.image).frame(width: 80, height: 80)

                VStack(alignment: .leading, spacing: 8) {
                    Text(wish.name)
                        .lineLimit(1)

                    Text(wish.priceFormatted)
                        .font(.subheadline)

                    BuyButton(link: wish.link)
                }
                .frame(height: 80, alignment: .leading)
                .padding(.horizontal)

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundColor(.blue)
            }
            .background(.white)
            .contentShape(Rectangle())
            .offset(x: offset)
            .gesture(
                DragGesture(minimumDistance: 25, coordinateSpace: .local)
                    .onChanged { gesture in
                        withAnimation {
                            let x = gesture.translation.width
                            if (x < 0 && x > -threshold) || (offset < 0 && x > -threshold) {
                                offset = x
                            }
                        }
                    }
                    .onEnded { _ in
                        withAnimation {
                            if offset < -threshold / 2 {
                                offset = -threshold
                            } else {
                                offset = 0
                            }
                        }
                    }
            )
            .onTapGesture {
                onTapGesture()
            }
            .zIndex(3)
            .padding()
        }
        .alert(isPresented: $isAlertShown) {
            Alert(
                title: Text("delete"),
                message: Text("delete_confirmation"),
                primaryButton: .default(Text("cancel")),
                secondaryButton: .default(Text("ok"), action: {
                    apiCall(method: .delete, path: "wish/\(wish.id)", body: nil) {
                        (result: ApiResponse<Wish>) in
                        DispatchQueue.main.async {
                            switch result {
                            case let .success(apiResponse):

                                withAnimation(.easeInOut(duration: animationDuration)) {
                                    offset = 0
                                }

                                DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) {
                                    onSuccess(apiResponse)
                                }

                            case let .failure(apiError):
                                error.message = apiError.message
                                error.status = apiError.status
                                error.isShown = true
                            }
                        }
                    }
                })
            )
        }
    }
}
