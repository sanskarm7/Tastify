//
//  PostsView.swift
//  Music App
//
//  Created by Sanskar Mishra on 7/22/23.
//

import SwiftUI

struct PostsView: View {
    var body: some View {
        ZStack{
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 316, height: 525)

                .background(Color(red: 0.91, green: 0.38, blue: 0.66))
                .cornerRadius(50)
            VStack{

                HStack(alignment: .center){
                    //                    WebImage(url: myProfile?.userProfileURL).placeholder{
                    //MARK: Placeholder Image
                    Image("null_pfp")
                        .resizable()
                        .frame(width: 50, height: 50)
                    //                    }
                    //                    .resizable()
                    //                    .aspectRatio(contentMode: .fill)
                    //                    .frame(width: 100, height: 100)
                        .clipShape(Circle())

                    Text("UserName")
                    //                    Text(myProfile?.username ?? "UserName null")
                        .font(
                            Font.custom("Inter", size: 20
                                       ).weight(.semibold)
                        )

                }
                .frame(width: 175, height: 50)
//                    .frame(alignment: .bottomLeading)
                .hAlign(.leading)
VStack{
                    Image("null_pfp")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 214, height: 217)
                        .clipped()
                        .shadow(color: .black.opacity(0.5), radius: 15, x: 0, y: 0)
//                            .padding(.top)
                        .padding(.bottom)

                    Text("Pluto to Mars")
                        .font(
                        Font.custom("Inter", size: 25)
                            .weight(.bold)
                        )

                    Text("Lil Uzi Vert")
                        .padding(.bottom)
                        .font(
                        Font.custom("Inter", size: 20)
                            .weight(.light)
                        )

                    Text("AnimBars")
                        .font(
                        Font.custom("Inter", size: 25)
                            .weight(.light)
                        )

                }
                .hAlign(.center)

                HStack{
                    Spacer()
                    VStack{
                        Button{
                            //Mute Aduio
                        } label: {
                            //if mute variable is false
                            Image(systemName: "speaker.slash")
                                .font(.headline)
                                .foregroundColor(Color.white)

                            //if mute var is true
    //                        Image(systemName: "speaker.slash.fill")
                        }
                    }
                    .padding(.trailing)
                }
            }
        }
        .frame(width: 316, height: 525)
    }
}
struct PostsView_Previews: PreviewProvider {
    static var previews: some View {
        PostsView()
    }
}
