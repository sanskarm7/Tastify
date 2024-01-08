//
//  MusicTab.swift
//  Music App
//
//  Created by Sanskar Mishra on 8/4/23.
//

import SwiftUI

struct MusicTab: View {
    var user: User
    var body: some View {
        ReusableProfilePosts(user: self.user)
    }
}

//struct MusicTab_Previews: PreviewProvider {
//    static var previews: some View {
//        MusicTab()
//    }
//}
