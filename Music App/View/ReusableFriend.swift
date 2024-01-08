//
//  figma.swift
//  Music App
//
//  Created by Jay Sunkara on 7/14/23.
//

import SwiftUI
import SDWebImageSwiftUI
import Firebase
import FirebaseStorage
import FirebaseFirestore
import Combine
import SpotifyWebAPI


struct ReusableFriend: View {
    @State var friend: User
    @State var user: User = Globals.currentUser!

    var body: some View {
        
        NavigationStack{
            ZStack{
                Color(red: 0.03, green: 0, blue: 0.09).edgesIgnoringSafeArea(.all)
                    VStack(){

                            ReusableProfileContent(user: friend)
                
                    }
                    
            }
            
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                
                Button {
                    friendRequest()
                } label: {
                    Image(systemName: "plus")
                        .font(.headline)
                        .foregroundColor(.white)
                }

            }
            
    }
        .toolbarBackground(Color(red: 0.03, green: 0, blue: 0.09), for: .navigationBar)
    

    }
    
    func friendRequest() {
        
        let docRef = Firestore.firestore().collection("Friends").document(user.userUID)
            
    }

    



        
    }
    
   
    


