//
//  SettingsView.swift
//  Music App
//
//  Created by Jay Sunkara on 7/17/23.
//

import SwiftUI
import Firebase
import FirebaseStorage
import FirebaseFirestore


struct SettingsView: View {
    @AppStorage("log_status") var logStatus: Bool = false
    @State private var myProfile: User?
    // MARK: Error Message
    @State var errorMessage: String = ""
    @State var showError: Bool = false
    @State var isLoading: Bool = false
    @State private var showingPopover = false
    @EnvironmentObject var spotify: Spotify


    
    var body: some View {
        NavigationStack{
            ZStack{
                Color(red: 0.03, green: 0, blue: 0.09).edgesIgnoringSafeArea(.all)
                ScrollView(.vertical,showsIndicators: false){
                    
                    VStack() {
                        
                        Text("SettingsView")
                        
                        Button{
                            //Edit Profile picture and name
                        } label: {
                            Text("Edit Profile")
                        }
                        
                        Button {
                            logOutUser()
                        } label: {
                            Text("Logout")
                        }

                    }
                }
                .refreshable {
                    //Refresh User Data
                }
            }
        }
        
        .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {

                    Button {
                        showingPopover = true
                    } label: {
                        Image(systemName: "info.circle")
                    }
                    .popover(isPresented: $showingPopover) {

                        InfoView()
                    }

            }
        }
        .overlay{
                LoadingView(show: $isLoading)
            }
            .alert(errorMessage, isPresented: $showError){
                
            }

    }
    
    
    
    
    //MARK: Logging User Out
    func logOutUser(){
        try? Auth.auth().signOut()
        logStatus = false
        spotify.api.authorizationManager.deauthorize()

    }
    
    //MARK: deleting user Entire Account
    func deleteAccount(){
        isLoading = true
        Task{
            do{
                guard let userUID = Auth.auth().currentUser?.uid else{return}
                // Step 1: First Deleting Profile Image From Storage
                let reference = Storage.storage().reference().child("Profile_Images").child(userUID)
                try await reference.delete()
                // Step 2: Deleting Firestore User Document
                try await Firestore.firestore().collection("Users").document(userUID).delete()
                // Final Step: Deleting Auth Acount and Setting Log Status to False
                try await Auth.auth().currentUser?.delete()
                logStatus = false
                
            }catch{
                await setError(error)
            }
            
        }
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

struct InfoView: View{
    @Environment(\.dismiss) var dismiss

    var body: some View{
        NavigationView{
            VStack{
                Text("This is the help page")
                    .font(.headline)
                    .padding()
                Text("Share Music posts with your friends by searching a song up and posting it!")
                    .padding()
            }

        }
        .toolbar {//not showing???
            ToolbarItem(placement: .navigationBarTrailing) {
                Button{
                    dismiss()
                } label: {
                    Text("Done")
                }
                
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
