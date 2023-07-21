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
