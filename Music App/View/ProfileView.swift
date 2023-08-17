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


struct ProfileView: View {
    @AppStorage("log_status") var logStatus: Bool = false
    @State private var myProfile: User?
    // MARK: Error Message
    @State var errorMessage: String = ""
    @State var showError: Bool = false
    @State var isLoading: Bool = false
    
    @EnvironmentObject var spotify: Spotify
    @State var isPlaying: Bool? = false
    @State var currentlyPlaying: PlaylistItem? = nil
    
    @State private var trackCancellable: AnyCancellable? = nil
    

    var body: some View {
        NavigationStack{
            ZStack{
                Color(red: 0.03, green: 0, blue: 0.09).edgesIgnoringSafeArea(.all)
                    VStack(){

                        if let myProfile{
                            ReusableProfileContent(user: myProfile)
                                .refreshable {
                                    
                                print("this runs - refreshable")
                                //Refresh User Data
                                
                                self.myProfile = nil
                                await fetchUserData()
                                getCurrentTrack()
                                //updateUser(profile: myProfile)
                                
                            }
                        }
                        else{
                            ProgressView()
                        }
                    }
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            
                            
                            //Change to pass myProfile?
                            NavigationLink(destination: SettingsView(currUserName: myProfile?.username ?? "Username", currUserRealName: myProfile?.userRealName ?? "Name", currUserEmail: myProfile?.userEmail ?? "email")) {
                                Image("Settings")
                                    .font(.headline)
                            }
                    }
                }
            }
            
        }

        .overlay{
                LoadingView(show: $isLoading)
            }
            .alert(errorMessage, isPresented: $showError){
                
            }
            .task{
                //MARK: Initial Fetch
                print("initial fetch")
                if myProfile != nil{return}
                print("print before await")
                await fetchUserData()
//                print("initial get track")
                getCurrentTrack()
//                print(currentlyPlaying?.name)
//                print("initial update user")



            }

    }
    //MARK: Fetching User Data
    func fetchUserData() async {
        print("fetch user data called")
        guard let userUID = Auth.auth().currentUser?.uid else{ return }
        print("user UID gotten " + userUID)
        
        guard let user = try? await Firestore.firestore().collection("Users").document(userUID).getDocument(as: User.self)
        else {
            print("failed")
            return
            
        }
        print("user received")
//        return user
        
        await MainActor.run(body: {
            myProfile = user
           print("main actor finish")

        })
        print("after main actor")
        
    }
    

    func setError(_ error: Error) async{
        //MARK: UI Must be run on Main Thread
        
        await MainActor.run(body: {
            isLoading = false
            errorMessage = error.localizedDescription
            showError.toggle()
        })
    }
    
    func getCurrentTrack() {
        print("getCurrentTrack running")
        var currentPlayback: CurrentlyPlayingContext?
        trackCancellable = self.spotify.api.currentPlayback()
            .receive(on: RunLoop.main)
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        print("Error: \(error)")
                    }
                },
                receiveValue: { playbackContext in
                    print("running")
                    if playbackContext != nil{
                        currentPlayback = playbackContext!
                        currentlyPlaying = playbackContext?.item
                        isPlaying = playbackContext?.isPlaying
                        updateUser(profile: myProfile!)
                    }
                    
                    print("get track: " + (currentlyPlaying?.name ?? "nil"))
                    //print("get track status: " + isPlaying)
                    print("Currently Playing: " + (currentPlayback?.item?.name ?? "nothing"))
                    

                    
                }
                
            )
        
    }
    
    func updateUser(profile: User) {
        print("update user called")
        print(profile.username)
        print("currently playing update user: " + (currentlyPlaying?.name ?? "none"))
    
        let db = Firestore.firestore()
        

        let docRef = db.collection("Users").document(profile.userUID)
        
        if currentlyPlaying != nil {
            let currently: current?
//            switch currentlyPlaying! {
//            case .track(let track):
//                currently = current(track: track, isPlaying: self.isPlaying!)
//            case .episode(_):
//                currently = nil
//            }
            currently = current(PlaylistItem: self.currentlyPlaying!, isPlaying: self.isPlaying!)
            
            if currently != nil {
                do{
                    //let encoder = JSONEncoder()
                    
                    //encoder.outputFormatting = .prettyPrinted
                    
                    let data = try Firestore.Encoder().encode(currently!)
                    
                    //print(String(data: data, encoding: .utf8)!)
                    
                    docRef.updateData(["currentlyPlaying": [data]]) { error in
                        if let error = error {
                            print("Error updating document: \(error)")
                        } else {
                            print("currently playing successfully updated!")
                        }
                    }
                }
                catch{
                    print("error, not serializable")
                }
            }
           
            
            
            
        }
        
            
        
    }
    
    
}

struct current: Codable {
    var PlaylistItem: PlaylistItem
    var isPlaying: Bool
    
    
}


struct figma_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
