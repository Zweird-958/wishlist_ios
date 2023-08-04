//
//  Profile.swift
//  wishlist_ios
//
//  Created by Julien on 04/08/2023.
//

import SwiftUI

struct Profile: View {
    @Binding var path: NavigationPath
    
    var body: some View {
        List{
            Button("change_language") {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            }
            Button("sign_out") {
                UserDefaults.standard.set(nil, forKey: Config().keys.token)
                path = NavigationPath(["signIn"])
            }.foregroundColor(.red)
        }
    }
}
