//
//  ProfileView.swift
//  Music App
//
//  Created by Jay Sunkara on 7/6/23.
//

import SwiftUI

struct ProfileView: View {
    
    @EnvironmentObject var spotify: Spotify

    var body: some View {
        VStack{
            
            if spotify.isAuthorized == false{
                Text("This is the Profile View\nPlease Authorize your Spotify Account")
            }
            else if spotify.isAuthorized == true{
                Text("Your Spotify Account has been Linked!!! :)")
            }
        }
        .onAppear{
            if spotify.isAuthorized == false{
                spotify.authorize()
            }
            
            
        }
        
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
