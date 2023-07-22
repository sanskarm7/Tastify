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
                .frame(width: 150, height: 150)
                .clipShape(Circle())
                
                Text(user.username)
                    .font(.largeTitle)
                    .foregroundColor(Color.white)
                    .fontWeight(.semibold)
                
                Text(user.userRealName)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .lineLimit(3)
                
                ZStack{
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 330, height: 90)
                        .background(Color(red: 0.24, green: 0.4, blue: 0.58))
                        .cornerRadius(20)
                    
                    HStack{
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 70, height: 70)
                            .background(
                                Image("NullAlbum")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 70, height: 70)
                                    .clipped()
                            )
                        VStack(alignment: .leading){
                            Spacer()
                            Text("COFFEE BEAN")
                                .font(.custom("Inter-Bold", size: 18)
                                      
                                )
                                .foregroundColor(.white)
                            //.frame(width: 174, height: 30, alignment: .topLeading)
                            
                            Text("Travis Scott")
                                .font(
                                    Font.custom("Inter-Bold", size: 18)
                                        .weight(.light)
                                )
                                .foregroundColor(.white)
                            //.frame(width: 174, height: 40, alignment: .topLeading)
                            Spacer()
                        }
                        .padding(.trailing)
                        AudioVisualizer().scaleEffect(x: 0.75, y: 0.75)
                        
                        
                    }
                }
                
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
