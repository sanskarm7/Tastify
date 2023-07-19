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




struct ProfileView: View {
    @AppStorage("log_status") var logStatus: Bool = false
    @State private var myProfile: User?
    // MARK: Error Message
    @State var errorMessage: String = ""
    @State var showError: Bool = false
    @State var isLoading: Bool = false
    @EnvironmentObject var spotify: Spotify
    

    var body: some View {
        NavigationStack{
            ZStack{
                Color(red: 0.03, green: 0, blue: 0.09).edgesIgnoringSafeArea(.all)
                    VStack(){

                        if let myProfile{
                            ReusableProfileContent(user: myProfile)
                                .refreshable {
                                //Refresh User Data
                                self.myProfile = nil
                                await fetchUserData()
                            }
                        }
                        else{
                            ProgressView()
                        }
                    }
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Menu{
                                Button("Logout", action: logOutUser)
                                
//                                Button("Delete Account", role: .destructive){
//
//                                }
                            } label: {
                                Image("Settings")
                                    .font(.headline)
                                    .padding()
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
                
                if myProfile != nil{return}
                await fetchUserData()
            }

    }
    //MARK: Fetching User Data
    func fetchUserData()async{
        
        guard let userUID = Auth.auth().currentUser?.uid else{ return}
        guard let user = try? await Firestore.firestore().collection("Users").document(userUID).getDocument(as: User.self) else{return}
        await MainActor.run(body: {
            myProfile = user
        })
        
    }
    
    //MARK: Logging User Out
    func logOutUser(){
        try? Auth.auth().signOut()
        logStatus = false
        spotify.api.authorizationManager.deauthorize()
    }
    
    //MARK: eleting user Entire Account
//    func deleteAccount(){
//        isLoading = true
//        Task{
//            do{
//                guard let userUID = Auth.auth().currentUser?.uid else{return}
//                // Step 1: First Deleting Profile Image From Storage
//                let reference = Storage.storage().reference().child("Profile_Images").child(userUID)
//                try await reference.delete()
//                // Step 2: Deleting Firestore User Document
//                try await Firestore.firestore().collection("Users").document(userUID).delete()
//                // Final Step: Deleting Auth Acount and Setting Log Status to False
//                try await Auth.auth().currentUser?.delete()
//                logStatus = false
//
//            }catch{
//                await setError(error)
//            }
//
//        }
//    }
    func setError(_ error: Error) async{
        //MARK: UI Must be run on Main Thread
        
        await MainActor.run(body: {
            isLoading = false
            errorMessage = error.localizedDescription
            showError.toggle()
        })
    }
    
    
}
struct figma_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
