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
import FirebaseFirestoreSwift
import SpotifyWebAPI
import Combine



struct CreateNewPost: View {
    //pass in track
    let track: Track
            var onPost: (Post)->()
    @State private var postText: String = ""
    @State var postImageData: Data?
    @State private var myProfile: User?
    @Environment(\.dismiss) private var dismiss
    @State private var isLoading: Bool = false
    @State private var errorMessage: String = ""
    @State private var showError: Bool = false
    //    @State var albumImage: Data?
    @EnvironmentObject var spotify: Spotify
    @State private var loadImageCancellable: AnyCancellable? = nil
    @State private var image = Image("Spotify Album Placeholder")
    @State var backgroundColor: Color = .clear
    
    

    
    
    
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
                
                Button(action: createPost){
                    Text("Post")
                        .font(.callout)
                        .foregroundColor(.white)
                        .padding(.horizontal,20)
                        .padding(.vertical,6)
                        .background(.black, in: Capsule())
                }
                //                .disableWithOpacity(postText == "")
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
            .background{
                Rectangle()
                    .fill(.gray.opacity(0.05))
                    .ignoresSafeArea()
            }
            
            Text("Posting: " + track.name)
            Text("By: " + (track.artists?.first?.name ?? "Error getting artist"))
            Text("Length: " + String(track.durationMS ?? 0))
        }
        .vAlign(.top)
        .task{
            //MARK: Initial Fetch
            
            if myProfile != nil{return}
            await fetchUserData()
        }
        .alert(errorMessage, isPresented: $showError,actions: {})
        .overlay{
            LoadingView(show: $isLoading)
        }
        
    }
    
    func fetchUserData()async{
        
        guard let userUID = Auth.auth().currentUser?.uid else{ return}
        guard let user = try? await Firestore.firestore().collection("Users").document(userUID).getDocument(as: User.self) else{return}
        await MainActor.run(body: {
            myProfile = user
        })
        loadImage()
        
    }
    
    func createPost(){
        isLoading = true
        Task{
            do{
                //                guard let userprofileURL = myProfile?.userProfileURL else{return}
                let imagePostID = "\(myProfile?.userUID ?? "nil")\(Date())"
                let storageRef = Storage.storage().reference().child("Post_Images").child(imagePostID)
                
                //Image to Data
                let uiImage: UIImage = self.image.asUIImage()
                postImageData = uiImage.pngData()
                
                backgroundColor = Color(uiImage.averageColor ?? .darkGray)
                let color = backgroundColor.description.dropFirst(25).components(separatedBy: " ").map {
                    CGFloat(($0 as NSString).doubleValue)
                }
                
                
                if let postImageData{
                    let _ = try await storageRef.putDataAsync(postImageData)
                    let downloadURL = try await storageRef.downloadURL()
                    
                    let post = Post(track: track, albumImageURL: downloadURL, imageReferenceID: imagePostID, imageColor: color, userName: myProfile!.username, userUID: myProfile!.userUID, userProfileURL: myProfile!.userProfileURL)
                    try await createDocumentAtFirebase(post)
                    
                } else{
                    let post = Post(track: track, imageColor: color, userName: myProfile!.username, userUID: myProfile!.userUID, userProfileURL: myProfile!.userProfileURL)
                    try await createDocumentAtFirebase(post)
                }
            } catch{
                await setError(error)
            }
        }
    }
    
    func createDocumentAtFirebase(_ post: Post) async throws{
        //if successfully uploaded to fireBase
        let doc = Firestore.firestore().collection("Posts").document()
        let _ = try doc.setData(from: post, completion: { error in
            if error == nil{
                isLoading = false
                //                onPost(post)
                var updatedPost = post
                updatedPost.id = doc.documentID
                onPost(updatedPost)
                print("Saved Post successfully")
                dismiss()
            }
        })
    }
    
    func loadImage() {
        guard let spotifyImage = track.album?.images?.first else {
            // print("no image found for '\(playlist.name)'")
            return
        }
        
        self.loadImageCancellable = spotifyImage.load()
            .receive(on: RunLoop.main)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { image in
                    
                    // print("received image for '\(playlist.name)'")
                    self.image = image
                    //                    self.setAverageColor()
                }
            )
    }
    
    
    func setError(_ error: Error) async{
        //MARK: UI Must be run on Main Thread
        
        await MainActor.run(body: {
            //            isLoading = false
            errorMessage = error.localizedDescription
            showError.toggle()
        })
    }
    
}

//struct CreateNewPost_Previews: PreviewProvider {
//    static let tracks: [Track] = []
//    //    static let track = nil
//
//    static var previews: some View {
//
//        List(tracks, id: \.id) { track in
//            CreateNewPost(track: track)
//        }
//        //        CreateNewPost()
//
//    }
//}
