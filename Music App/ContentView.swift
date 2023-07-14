//
//  ContentView.swift
//  Music App
//
//  Created by Sanskar Mishra on 7/4/23.
//
import CoreData
import SwiftUI
import PhotosUI

struct ContentView: View {
    
    @Environment (\.managedObjectContext) var managedObjContxt

//    @FetchRequest(sortDescriptors: []) var users: FetchedResults<MobileUser>
    @AppStorage("log_status") var logStatus: Bool = false
    var user = FetchedResults<MobileUser>.Element()

    var body: some View{
        //MARK: Redirecting User Based on Log Status
        if logStatus{
            

            TestView()
//                .onAppear{
//                    DataController().addData(context: managedObjContxt)
//                }
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
