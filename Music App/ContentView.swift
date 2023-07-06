//
//  ContentView.swift
//  Music App
//
//  Created by Sanskar Mishra on 7/4/23.
//

import SwiftUI
import PhotosUI

struct ContentView: View {
    @AppStorage("log_status") var logStatus: Bool = false
    var body: some View{
        //MARK: Redirecting User Based on Log Status
        if logStatus{
            ProfileView()
//            Text("Main View")
            //Prompt User to authorize/connect Spotify Account
            

        }else{
            LoginView()
        }
    }
    
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
