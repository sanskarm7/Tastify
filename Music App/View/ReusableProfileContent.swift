//
//  ReusableProfileContent.swift
//  Music App
//
//  Created by Sanskar Mishra on 7/18/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct ReusableProfileContent: View {
    var user: User
    
    var body: some View{
        ScrollView(.vertical, showsIndicators: false) {
            VStack{
                WebImage(url: user.userProfileURL).placeholder{
                    //MARK: Placeholder Image
                    Image("null_pfp")
                        .resizable()
                }
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 100, height: 100)
                .clipShape(Circle())
                
                Text(user.username)
                    .font(.largeTitle)
                    .foregroundColor(Color.white)
                    .fontWeight(.semibold)
                
                Text(user.userRealName)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .lineLimit(3)
                
                //MARK: Displaying Bio Link, if given while signing up
                
//                if let bioLink = URL(string: user.userBioLink){
//                    Link(user.userBioLink, destination: bioLink)
//                        .font(.callout)
//                        .tint(.blue)
//                        .lineLimit(1)
//                }
            }
        }
    }
}
