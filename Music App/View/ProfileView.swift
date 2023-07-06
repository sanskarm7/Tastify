//
//  ProfileView.swift
//  Music App
//
//  Created by Jay Sunkara on 7/6/23.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        VStack{
            Text("This is the Profile View")
        }
        .onAppear{
            UIApplication.shared.open(authorizationURL)
        }
        
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
