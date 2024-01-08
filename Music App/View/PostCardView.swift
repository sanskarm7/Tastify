//
//  PostCardView.swift
//  Music App
//
//  Created by Jay Sunkara on 7/24/23.
//

import SwiftUI
import SDWebImageSwiftUI
import Firebase
import FirebaseStorage
import FirebaseFirestore
import FirebaseFirestoreSwift
import SpotifyWebAPI
import Combine
import MarqueeText


struct PostCardView: View {
    //    @EnvironmentObject var spotify: Spotify
    //    @State private var loadImageCancellable: AnyCancellable? = nil
    //    @State private var image = Image("Spotify Album Placeholder")
    
    //    @State private var backgroundColor: Color = .clear
    
    var post: Post
    var onUpdate: (Post)->()
    var onDelete: ()->()
    
    @State var color: UIColor = .darkGray
    
    
    @State private var myProfile: User?
    
    @AppStorage("user_UID") var userUID: String = ""
    //For live Reactions updates
    @State private var docListener: ListenerRegistration?
    
    
    
    var body: some View {
        ZStack{
            
            PostInteraction()
            //            .padding(.top,-15)
                .vAlign(.bottom)
            
            ZStack{
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 316, height: 510)
                
                    .background(Color(cgColor: CGColor(colorSpace: CGColorSpace(name: CGColorSpace.sRGB)!, components: post.imageColor)!).blur(radius: 1))
                    .cornerRadius(50)
                VStack{
                    
                    VStack{
                        HStack(alignment: .center){
                            WebImage(url: myProfile?.userProfileURL).placeholder{
                                //MARK: Placeholder Image
                                Image("null_pfp")
                            }
                            .resizable()
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                            
                            //                    Text("UserName")
                            Text(post.userName)
                                .font(
                                    Font.custom("Inter", size: 20
                                               ).weight(.semibold)
                                )
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                        }
                        
                        .padding(.top,-25)
                        .padding(.leading,15)
                        .padding(.bottom,10)
                    }
                    
                    VStack{
                        WebImage(url: post.albumImageURL).placeholder{
                            //MARK: Placeholder Image
                            Image("Spotify Album Placeholder")
                        }
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 215, height: 215)
                        .clipped()
                        .shadow(color: .black.opacity(0.5), radius: 15, x: 0, y: 0)
                        //                            .padding(.top)
                        .padding(.bottom)
                        
                        MarqueeText(
                            text: post.track.name,
                             font: UIFont(name: "Inter-Bold", size: 25)!,
                             leftFade: 3,
                             rightFade: 3,
                             startDelay: 3,
                             alignment: .center
                             )
                        .foregroundColor(.white)
                        .frame(maxWidth: 250)
                        
                        
                        MarqueeText(
                            text: post.track.artists?.first?.name ?? "error fetching artist name",
                             font: UIFont(name: "Inter-Light", size: 20)!,
                             leftFade: 3,
                             rightFade: 3,
                             startDelay: 3,
                             alignment: .center
                             )
                        .foregroundColor(.white)
                        .frame(maxWidth: 250)
                        .padding(.bottom)
                        
                        AudioVisualizer(isPlaying: true)
                        
//                        Text("AnimBars")
//                            .font(
//                                Font.custom("Inter", size: 25)
//                                    .weight(.light)
//                            )
                        
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
                            Menu{
                                Button("Delete Post", role: .destructive, action: deletePost)

                            } label: {
                                Image(systemName: "ellipsis")
                                    .font(.headline)
                                    .foregroundColor(Color.white)
                            }

                            
                        }
                        .padding(.trailing)
                    }
                    
                }
            }
            .frame(width: 316, height: 510)
            
            
            
        }
        .frame(width: 316, height: 600)
        //when the post is visible on the screen, the cofument listner is added; otherwise the listener is removed.
        //Since we used LazyVStack earlier, onAppear(), and onDisappear() will be called when the view enters or leaves the screen, respectiviely
        .onAppear{
            if docListener == nil{
                guard let postID = post.id else{return}
                docListener = Firestore.firestore().collection("Posts").document(postID).addSnapshotListener({ snapshot,
                    error in
                    if let snapshot{
                        if snapshot.exists{
                            // - document updated
                            //fetching updated doc
                            if let updatedPost = try? snapshot.data(as: Post.self){
                                onUpdate(updatedPost)
                            }
                        } else{
                            onDelete()
                        }
                    }
                    
                })
            }
        }
        .onDisappear{
            if let docListener{
                docListener.remove()
                self.docListener = nil
            }
        }
        
        .task{
            await fetchUserData()
        }
    }
    
    func fetchUserData()async{
        
        //         let userUID = (post.userUID)
        guard let user = try? await Firestore.firestore().collection("Users").document(post.userUID).getDocument(as: User.self) else{return}
        await MainActor.run(body: {
            myProfile = user
        })
        //        self.setAverageColor()
        
    }
    
    @ViewBuilder
    func PostInteraction()->some View{
        
        ZStack{
            RoundedRectangle(cornerRadius: 25, style: .continuous)
            
                .fill(Color(self.color))
            //              .foregroundColor(.clear)
                .frame(width: 211, height: 60)
                .offset(y: -60 / 2)
                .clipped()
                .offset(y: 60 / 4)
                .frame(height: 60 / 2)
            //              .background(Color(red: 0.85, green: 0.85, blue: 0.85))
            //              .cornerRadius(30)
            VStack{
                Spacer()
                
                HStack(spacing: 25){
                    HStack{
                        Button(action: likePost){
                            Image(systemName: post.likedIDs.contains(userUID) ? "flame.fill" : "flame")
                                .foregroundColor(.white)
                        }
                        
                        Text("\(post.likedIDs.count)")
                            .font(.caption)
                            .foregroundColor(.white)
                    }
                    
                    HStack{
                        Button(action: neutralPost) {
                            
                            Image(systemName: post.neutralIDs.contains(userUID) ? "plusminus.circle.fill" : "plusminus.circle")
                                .foregroundColor(.white)
                        }
                        
                        Text("\(post.neutralIDs.count)")
                            .font(.caption)
                            .foregroundColor(.white)
                    }
                    
                    HStack{
                        Button(action: dislikePost){
                            Image(systemName: post.dislikedIDs.contains(userUID) ? "hand.thumbsdown.fill" : "hand.thumbsdown")
                                .foregroundColor(.white)
                        }
                        
                        Text("\(post.dislikedIDs.count)")
                            .font(.caption)
                            .foregroundColor(.white)
                    }
                    
                    
                    
                }
                .foregroundColor(.black)
                .padding(.bottom,20)
            }
            
        }
        .onAppear{
            color = UIColor(Color(cgColor: CGColor(colorSpace: CGColorSpace(name: CGColorSpace.sRGB)!, components: post.imageColor)!))
            color = color.modified(withAdditionalHue: 0, additionalSaturation: 0, additionalBrightness: -0.05)
        }
        .frame(width: 211, height: 60)
        
        
        
    }
    
    func likePost(){
        guard let postID = post.id else{return}
        
        if post.likedIDs.contains(userUID){
            Firestore.firestore().collection("Posts").document(postID).updateData([
                "likedIDs": FieldValue.arrayRemove([userUID])])
        } else{
            Firestore.firestore().collection("Posts").document(postID).updateData([
                "likedIDs": FieldValue.arrayUnion([userUID]),
                "dislikedIDs": FieldValue.arrayRemove([userUID]),
                "neutralIDs": FieldValue.arrayRemove([userUID])
            ])
        }
    }
    
    func neutralPost(){
        guard let postID = post.id else{return}
        
        if post.neutralIDs.contains(userUID){
            Firestore.firestore().collection("Posts").document(postID).updateData([
                "neutralIDs": FieldValue.arrayRemove([userUID])])
        } else{
            Firestore.firestore().collection("Posts").document(postID).updateData([
                "neutralIDs": FieldValue.arrayUnion([userUID]),
                "likedIDs": FieldValue.arrayRemove([userUID]),
                "dislikedIDs": FieldValue.arrayRemove([userUID])
            ])
        }
    }
    
    func dislikePost(){
        guard let postID = post.id else{return}
        
        if post.dislikedIDs.contains(userUID){
            Firestore.firestore().collection("Posts").document(postID).updateData([
                "dislikedIDs": FieldValue.arrayRemove([userUID])])
        } else{
            Firestore.firestore().collection("Posts").document(postID).updateData([
                "dislikedIDs": FieldValue.arrayUnion([userUID]),
                "likedIDs": FieldValue.arrayRemove([userUID]),
                "neutralIDs": FieldValue.arrayRemove([userUID])
            ])
        }
    }
    
    func deletePost(){
        Task{
            do{
                try await Storage.storage().reference().child("Post_Images").child(post.imageReferenceID).delete()
                guard let postID = post.id else{return}
                try await Firestore.firestore().collection("Posts").document(postID).delete()
            } catch{
                print(error.localizedDescription)
            }
        }
    }
    
}



//struct PostCardView_Previews: PreviewProvider {
//    static var previews: some View {
//        PostCardView()
//    }
//}
