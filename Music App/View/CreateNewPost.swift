//
//  CreateNewPost.swift
//  Music App
//
//  Created by Jay Sunkara on 7/19/23.
//

import SwiftUI
import SDWebImageSwiftUI
import Firebase
import FirebaseStorage
import FirebaseFirestore
import SpotifyWebAPI


struct CreateNewPost: View {
    
    //    var onPost: (Post)->()
    @State private var postText: String = ""
    
    @State private var myProfile: User?
    @Environment(\.dismiss) private var dismiss
    @State private var isLoading: Bool = false
    @State private var errorMessage: String = ""
    @State private var showError: Bool = false
    
    //pass in track
    //    let track: Track
    
    
    
    var body: some View {
        
        VStack{
            HStack{
                Menu{
                    Button("Cancel", role: .destructive){
                        dismiss()
                    }
                } label: {
                    Text("Cancel")
                        .font(.callout)
                        .foregroundColor(.black)
                }
                .hAlign(.leading)
                
                Button(action: {}){
                    Text("Post")
                        .font(.callout)
                        .foregroundColor(.white)
                        .padding(.horizontal,20)
                        .padding(.vertical,6)
                        .background(.black, in: Capsule())
                }
                .disableWithOpacity(postText == "")
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
            .background{
                Rectangle()
                    .fill(.gray.opacity(0.05))
                    .ignoresSafeArea()
            }
            
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
        .vAlign(.top)
        .task{
            //MARK: Initial Fetch
            
            if myProfile != nil{return}
            await fetchUserData()
            
        }
        
    }
    
    func fetchUserData()async{
        
        guard let userUID = Auth.auth().currentUser?.uid else{ return}
        guard let user = try? await Firestore.firestore().collection("Users").document(userUID).getDocument(as: User.self) else{return}
        await MainActor.run(body: {
            myProfile = user
        })
        
    }
    
}

struct CreateNewPost_Previews: PreviewProvider {
    static let tracks: [Track] = []
    //    static let track = nil
    
    static var previews: some View {
        
        //        List(tracks, id: \.id) { trak in
        //            CreateNewPost(track: trak)
        //        }
        CreateNewPost()
        
    }
}
