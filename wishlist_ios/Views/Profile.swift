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
        RoundedButton(action: {
            UserDefaults.standard.set(nil, forKey: Config().keys.token)
            path = NavigationPath(["signIn"])
        }, verticalPadding: 8){
            Text("sign_out")
        }
    }
}
